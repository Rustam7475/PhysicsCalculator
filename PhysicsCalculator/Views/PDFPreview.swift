import SwiftUI
import PDFKit
import UIKit
import SwiftMath
import os

private let logger = Logger(subsystem: AppConfiguration.appName, category: "PDF")

struct PDFPreview: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let calculationDate: Date
    @Environment(\.dismiss) private var dismiss
    @State private var pdfURL: URL?
    @State private var showShareSheet = false
    
    // Цвета для PDF
    private let primaryColor = UIColor(red: 52/255, green: 120/255, blue: 246/255, alpha: 1) // #3478F6
    private let secondaryColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1) // #EFEFEF
    private let darkTextColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1) // #1D1D1F
    private let lightTextColor = UIColor(red: 134/255, green: 134/255, blue: 139/255, alpha: 1) // #86868B
    
    var body: some View {
        NavigationView {
            Group {
                if let url = pdfURL {
                    PDFKitView(url: url)
                } else {
                    ProgressView(L10n.generatingPDF)
                }
            }
            .navigationBarTitle(L10n.pdfPreviewTitle, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.close) { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showShareSheet = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear {
            generatePDF()
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL {
                ActivityView(items: [url])
            }
        }
    }
    
    // MARK: - PDF Generation
    
    private func generatePDF() {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pdfPath = documentsPath.appendingPathComponent("calculation_result.pdf")
        
        do {
            try renderer.writePDF(to: pdfPath) { context in
                context.beginPage()
                
                let titleFont = UIFont.systemFont(ofSize: 26, weight: .bold)
                let sectionFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
                let labelFont = UIFont.systemFont(ofSize: 13)
                let valueFont = UIFont.systemFont(ofSize: 16, weight: .medium)
                let valueBoldFont = UIFont.systemFont(ofSize: 18, weight: .bold)
                let captionFont = UIFont.systemFont(ofSize: 13)
                let padding: CGFloat = 40
                let contentWidth = pageRect.width - 2 * padding
                var y: CGFloat = padding
                
                // ── Заголовок ──
                let titleStr = formula.localizedName as NSString
                let titleRect = titleStr.boundingRect(
                    with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [.font: titleFont, .foregroundColor: darkTextColor],
                    context: nil
                )
                titleStr.draw(in: CGRect(x: padding, y: y, width: contentWidth, height: titleRect.height),
                              withAttributes: [.font: titleFont, .foregroundColor: darkTextColor])
                y += titleRect.height + 6
                
                // Описание
                let descStr = formula.localizedDescription as NSString
                let descRect = descStr.boundingRect(
                    with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
                    options: .usesLineFragmentOrigin,
                    attributes: [.font: captionFont, .foregroundColor: lightTextColor],
                    context: nil
                )
                descStr.draw(in: CGRect(x: padding, y: y, width: contentWidth, height: descRect.height),
                             withAttributes: [.font: captionFont, .foregroundColor: lightTextColor])
                y += descRect.height + 24
                
                // ── 1. Исходная формула ──
                y = drawSectionTitle("1. \(L10n.stepOriginalFormula)", font: sectionFont, x: padding, y: y, width: contentWidth)
                y = drawLatex(formula.equation_latex, x: padding, y: y, width: contentWidth, fontSize: 22)
                y += 16
                
                // ── 2. Формула для неизвестной (если перестроена) ──
                let rearranged = formula.getRearrangedFormula(for: calculatedSymbol)
                var stepNum = 2
                if rearranged != formula.equation_latex {
                    y = drawSectionTitle("\(stepNum). \(L10n.stepRearrange)", font: sectionFont, x: padding, y: y, width: contentWidth)
                    y = drawLatex(rearranged, x: padding, y: y, width: contentWidth, fontSize: 22)
                    y += 16
                    stepNum += 1
                }
                
                // ── 3. Подставляем значения ──
                y = drawSectionTitle("\(stepNum). \(L10n.stepSubstitute)", font: sectionFont, x: padding, y: y, width: contentWidth)
                
                // Введённые значения: название сверху, значение снизу
                for variable in formula.variables where variable.symbol != calculatedSymbol {
                    let rawValue = inputValues[variable.symbol, default: ""]
                    let formattedVal = CalculationService.formatInputValue(rawValue)
                    let unit = CalculationService.displayUnit(variable.unit_si)
                    
                    // Название переменной
                    let nameStr = variable.localizedName as NSString
                    nameStr.draw(at: CGPoint(x: padding + 16, y: y),
                                 withAttributes: [.font: labelFont, .foregroundColor: lightTextColor])
                    y += 18
                    // Значение + единица
                    let valStr = "\(formattedVal) \(unit)".trimmingCharacters(in: .whitespaces) as NSString
                    valStr.draw(at: CGPoint(x: padding + 16, y: y),
                                withAttributes: [.font: valueFont, .foregroundColor: darkTextColor])
                    y += 28
                }
                
                // Формула с подставленными числами
                let valueFormula = formula.getFormulaWithValues(calculatedSymbol: calculatedSymbol, inputValues: inputValues)
                y = drawLatex(valueFormula, x: padding, y: y, width: contentWidth, fontSize: 20)
                y += 20
                stepNum += 1
                
                // ── 4. Вычисляем результат ──
                y = drawSectionTitle("\(stepNum). \(L10n.stepCalculate)", font: sectionFont, x: padding, y: y, width: contentWidth)
                
                if let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                    let unit = CalculationService.displayUnit(resultVar.unit_si)
                    
                    // Фон для результата
                    let resultBoxHeight: CGFloat = 60
                    let resultBgRect = CGRect(x: padding, y: y, width: contentWidth, height: resultBoxHeight)
                    let resultBgPath = UIBezierPath(roundedRect: resultBgRect, cornerRadius: 10)
                    UIColor(red: 230/255, green: 240/255, blue: 255/255, alpha: 1).setFill()
                    resultBgPath.fill()
                    
                    // Название
                    let nameStr = resultVar.localizedName as NSString
                    nameStr.draw(at: CGPoint(x: padding + 16, y: y + 8),
                                 withAttributes: [.font: labelFont, .foregroundColor: lightTextColor])
                    // = значение единица
                    let resultStr = "= \(CalculationService.formatNumber(calculatedValue)) \(unit)".trimmingCharacters(in: .whitespaces) as NSString
                    resultStr.draw(at: CGPoint(x: padding + 16, y: y + 28),
                                   withAttributes: [.font: valueBoldFont, .foregroundColor: primaryColor])
                    y += resultBoxHeight + 24
                }
                
                // ── Разделитель ──
                let separatorPath = UIBezierPath()
                separatorPath.move(to: CGPoint(x: padding, y: y))
                separatorPath.addLine(to: CGPoint(x: padding + contentWidth, y: y))
                UIColor(white: 0.85, alpha: 1).setStroke()
                separatorPath.lineWidth = 0.5
                separatorPath.stroke()
                y += 16
                
                // ── Дата ──
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                let dateText = "\(L10n.pdfDate) \(formatter.string(from: calculationDate))" as NSString
                dateText.draw(at: CGPoint(x: padding, y: y),
                              withAttributes: [.font: captionFont, .foregroundColor: lightTextColor])
            }
            
            self.pdfURL = pdfPath
        } catch {
            logger.error("Ошибка при создании PDF: \(error.localizedDescription)")
        }
    }
    
    /// Рисует заголовок секции и возвращает новую y-позицию
    private func drawSectionTitle(_ text: String, font: UIFont, x: CGFloat, y: CGFloat, width: CGFloat) -> CGFloat {
        let nsText = text as NSString
        nsText.draw(at: CGPoint(x: x, y: y),
                    withAttributes: [.font: font, .foregroundColor: darkTextColor])
        return y + font.lineHeight + 10
    }
    
    /// Рендерит LaTeX через MTMathUILabel в PDF и возвращает новую y-позицию
    private func drawLatex(_ latex: String, x: CGFloat, y: CGFloat, width: CGFloat, fontSize: CGFloat) -> CGFloat {
        let mathLabel = MTMathUILabel()
        mathLabel.latex = latex
        mathLabel.fontSize = fontSize
        mathLabel.textColor = darkTextColor
        mathLabel.textAlignment = .center
        mathLabel.frame = CGRect(x: 0, y: 0, width: width, height: 60)
        mathLabel.sizeToFit()
        
        let size = mathLabel.bounds.size
        guard size.width > 0, size.height > 0 else { return y + 30 }
        
        // Масштабируем если формула шире контента
        let scale = min(1.0, width / size.width)
        let renderSize = CGSize(width: size.width * scale, height: size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 2.0)
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.translateBy(x: 0, y: size.height)
            ctx.scaleBy(x: 1.0, y: -1.0)
            mathLabel.layer.render(in: ctx)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image {
            let drawX = x + (width - renderSize.width) / 2
            image.draw(in: CGRect(x: drawX, y: y, width: renderSize.width, height: renderSize.height))
            return y + renderSize.height + 8
        }
        return y + 30
    }
}

extension MTMathUILabel {
    func asImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            context.translateBy(x: 0, y: bounds.size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        if let document = PDFDocument(url: url) {
            pdfView.document = document
        }
    }
}

// MARK: - Share через отдельный UIWindow (работает с Telegram, WhatsApp и др.)
enum ShareHelper {
    /// Открывает UIActivityViewController в отдельном UIWindow, независимом от SwiftUI lifecycle
    static func share(items: [Any]) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let shareWindow = UIWindow(windowScene: windowScene)
        let hostVC = UIViewController()
        hostVC.view.backgroundColor = .clear
        shareWindow.rootViewController = hostVC
        shareWindow.windowLevel = .alert + 1
        shareWindow.makeKeyAndVisible()
        
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityVC.completionWithItemsHandler = { _, _, _, _ in
            shareWindow.isHidden = true
        }
        activityVC.popoverPresentationController?.sourceView = hostVC.view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: hostVC.view.bounds.midX, y: hostVC.view.bounds.midY, width: 0, height: 0)
        
        hostVC.present(activityVC, animated: true)
    }
}

// MARK: - UIActivityViewController wrapper (for sharing files)
struct ActivityView: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Share wrapper that hosts UIActivityViewController inside its own VC
/// Решает проблему с мессенджерами (Telegram, WhatsApp), которые не отправляют текст
/// при прямом UIActivityViewController из SwiftUI
struct ShareActivityView: UIViewControllerRepresentable {
    let text: String
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> ShareHostController {
        let controller = ShareHostController()
        controller.text = text
        controller.onDismiss = { dismiss() }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ShareHostController, context: Context) {}
}

class ShareHostController: UIViewController {
    var text: String = ""
    var onDismiss: (() -> Void)?
    private var didPresent = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !didPresent else { return }
        didPresent = true
        
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { [weak self] _, _, _, _ in
            self?.onDismiss?()
        }
        // Для iPad
        activityVC.popoverPresentationController?.sourceView = view
        activityVC.popoverPresentationController?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        
        present(activityVC, animated: true)
    }
}