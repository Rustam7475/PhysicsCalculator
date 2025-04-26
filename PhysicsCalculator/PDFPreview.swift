import SwiftUI
import PDFKit
import UIKit
import SwiftMath

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
                    ProgressView("Генерация PDF...")
                }
            }
            .navigationBarTitle("Предпросмотр PDF", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Закрыть") { dismiss() },
                trailing: Button(action: { showShareSheet = true }) {
                    Image(systemName: "square.and.arrow.up")
                }
            )
        }
        .onAppear {
            generatePDF()
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = pdfURL {
                ShareSheet(items: [url])
            }
        }
    }
    
    private func generatePDF() {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pdfPath = documentsPath.appendingPathComponent("calculation_result.pdf")
        
        do {
            try renderer.writePDF(to: pdfPath) { context in
                context.beginPage()
                
                // Настройка шрифтов и стилей
                let titleFont = UIFont.systemFont(ofSize: 26, weight: .bold)
                let subtitleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
                let regularFont = UIFont.systemFont(ofSize: 16)
                let captionFont = UIFont.systemFont(ofSize: 14)
                let padding: CGFloat = 40
                var yPosition: CGFloat = padding
                
                // Заголовок
                let title = formula.localizedName as NSString
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: titleFont,
                    .foregroundColor: darkTextColor
                ]
                title.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: titleAttributes)
                yPosition += 40
                
                // Описание
                let description = formula.localizedDescription as NSString
                let descriptionAttributes: [NSAttributedString.Key: Any] = [
                    .font: regularFont,
                    .foregroundColor: lightTextColor
                ]
                let descriptionRect = CGRect(x: padding, y: yPosition, width: pageRect.width - 2 * padding, height: 60)
                description.draw(in: descriptionRect, withAttributes: descriptionAttributes)
                yPosition += 80
                
                // Формула с символами
                let symbolFormula = formula.getRearrangedFormula(for: calculatedSymbol)
                let mathLabel1 = MTMathUILabel()
                mathLabel1.latex = symbolFormula
                mathLabel1.fontSize = 24
                mathLabel1.textColor = primaryColor
                mathLabel1.textAlignment = .center
                let mathWidth = pageRect.width - 2 * padding
                mathLabel1.frame = CGRect(x: padding, y: yPosition, width: mathWidth, height: 40)
                mathLabel1.sizeToFit()
                
                // Создаем контекст для рендеринга
                UIGraphicsBeginImageContextWithOptions(mathLabel1.bounds.size, false, 0.0)
                if let context = UIGraphicsGetCurrentContext() {
                    context.translateBy(x: 0, y: mathLabel1.bounds.size.height)
                    context.scaleBy(x: 1.0, y: -1.0)
                    mathLabel1.layer.render(in: context)
                }
                if let mathImage1 = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    let mathX1 = padding + (mathWidth - mathImage1.size.width) / 2
                    mathImage1.draw(at: CGPoint(x: mathX1, y: yPosition))
                }
                yPosition += 30
                
                // Формула с подставленными значениями
                let valueFormula = getFormulaWithValues()
                let mathLabel2 = MTMathUILabel()
                mathLabel2.latex = valueFormula
                mathLabel2.fontSize = 24
                mathLabel2.textColor = darkTextColor
                mathLabel2.textAlignment = .center
                mathLabel2.frame = CGRect(x: padding, y: yPosition, width: mathWidth, height: 40)
                mathLabel2.sizeToFit()
                
                // Создаем контекст для рендеринга
                UIGraphicsBeginImageContextWithOptions(mathLabel2.bounds.size, false, 0.0)
                if let context = UIGraphicsGetCurrentContext() {
                    context.translateBy(x: 0, y: mathLabel2.bounds.size.height)
                    context.scaleBy(x: 1.0, y: -1.0)
                    mathLabel2.layer.render(in: context)
                }
                if let mathImage2 = UIGraphicsGetImageFromCurrentImageContext() {
                    UIGraphicsEndImageContext()
                    let mathX2 = padding + (mathWidth - mathImage2.size.width) / 2
                    mathImage2.draw(at: CGPoint(x: mathX2, y: yPosition))
                }
                yPosition += 60
                
                // Введенные значения
                let inputTitle = "Введенные значения:" as NSString
                let inputTitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: subtitleFont,
                    .foregroundColor: darkTextColor
                ]
                inputTitle.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: inputTitleAttributes)
                yPosition += 30
                
                // Фон для введенных значений
                let inputBackgroundRect = CGRect(x: padding, y: yPosition, width: pageRect.width - 2 * padding, height: CGFloat(formula.variables.count - 1) * 30 + 20)
                let inputBackgroundPath = UIBezierPath(roundedRect: inputBackgroundRect, cornerRadius: 10)
                secondaryColor.setFill()
                inputBackgroundPath.fill()
                
                // Значения
                for variable in formula.variables where variable.symbol != calculatedSymbol {
                    let value = inputValues[variable.symbol, default: ""]
                    let text = "\(variable.localizedName): \(value) \(variable.unit_si)" as NSString
                    let valueAttributes: [NSAttributedString.Key: Any] = [
                        .font: regularFont,
                        .foregroundColor: darkTextColor
                    ]
                    text.draw(at: CGPoint(x: padding + 20, y: yPosition + 10), withAttributes: valueAttributes)
                    yPosition += 30
                }
                yPosition += 30
                
                // Результат
                let resultTitle = "Результат:" as NSString
                let resultTitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: subtitleFont,
                    .foregroundColor: darkTextColor
                ]
                resultTitle.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: resultTitleAttributes)
                yPosition += 30
                
                // Фон для результата
                if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                    let resultBackgroundRect = CGRect(x: padding, y: yPosition, width: pageRect.width - 2 * padding, height: 50)
                    let resultBackgroundPath = UIBezierPath(roundedRect: resultBackgroundRect, cornerRadius: 10)
                    secondaryColor.setFill()
                    resultBackgroundPath.fill()
                    
                    let resultText = "\(resultVariable.localizedName): \(String(format: "%.4g", calculatedValue)) \(resultVariable.unit_si)" as NSString
                    let resultAttributes: [NSAttributedString.Key: Any] = [
                        .font: regularFont,
                        .foregroundColor: primaryColor
                    ]
                    resultText.draw(at: CGPoint(x: padding + 20, y: yPosition + 15), withAttributes: resultAttributes)
                }
                yPosition += 80
                
                // Дата и время
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                let dateText = "Дата расчета: \(formatter.string(from: calculationDate))" as NSString
                let dateAttributes: [NSAttributedString.Key: Any] = [
                    .font: captionFont,
                    .foregroundColor: lightTextColor
                ]
                dateText.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: dateAttributes)
            }
            
            self.pdfURL = pdfPath
        } catch {
            print("Ошибка при создании PDF: \(error)")
        }
    }
    
    private func getFormulaWithValues() -> String {
        // Формируем левую часть (символ вычисляемой переменной)
        let leftSide = calculatedSymbol
        
        // Получаем правило расчета для вычисляемой переменной
        guard let rule = formula.calculation_rules[calculatedSymbol] else {
            return "\(leftSide) = ?"
        }
        
        // Заменяем символы переменных их значениями
        var rightSide = rule
        for variable in formula.variables where variable.symbol != calculatedSymbol {
            if let value = inputValues[variable.symbol] {
                rightSide = rightSide.replacingOccurrences(of: variable.symbol, with: value)
            }
        }
        
        // Заменяем операторы на LaTeX-эквиваленты
        rightSide = rightSide.replacingOccurrences(of: "*", with: " \\cdot ")
                            .replacingOccurrences(of: "/", with: " \\div ")
        
        return "\(leftSide) = \(rightSide)"
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