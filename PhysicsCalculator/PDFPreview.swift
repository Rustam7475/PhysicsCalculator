import SwiftUI
import PDFKit
import UIKit

struct PDFPreview: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let calculationDate: Date
    @Environment(\.dismiss) private var dismiss
    @State private var pdfURL: URL?
    @State private var showShareSheet = false
    
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
                let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
                let subtitleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
                let regularFont = UIFont.systemFont(ofSize: 14)
                let padding: CGFloat = 40
                var yPosition: CGFloat = padding
                
                // Заголовок
                let title = formula.localizedName as NSString
                title.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: [.font: titleFont])
                yPosition += 40
                
                // Формула (пока просто текстом, позже можно добавить LaTeX рендеринг)
                let equation = formula.equation_latex as NSString
                equation.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: [.font: subtitleFont])
                yPosition += 40
                
                // Введенные значения
                let inputTitle = "Введенные значения:" as NSString
                inputTitle.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: [.font: subtitleFont])
                yPosition += 30
                
                for variable in formula.variables where variable.symbol != calculatedSymbol {
                    let value = inputValues[variable.symbol, default: ""]
                    let text = "\(variable.localizedName): \(value) \(variable.unit_si)" as NSString
                    text.draw(at: CGPoint(x: padding + 20, y: yPosition), withAttributes: [.font: regularFont])
                    yPosition += 20
                }
                yPosition += 20
                
                // Результат
                let resultTitle = "Результат:" as NSString
                resultTitle.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: [.font: subtitleFont])
                yPosition += 30
                
                if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                    let resultText = "\(resultVariable.localizedName): \(String(format: "%.4g", calculatedValue)) \(resultVariable.unit_si)" as NSString
                    resultText.draw(at: CGPoint(x: padding + 20, y: yPosition), withAttributes: [.font: regularFont])
                }
                yPosition += 40
                
                // Дата и время
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                let dateText = "Дата расчета: \(formatter.string(from: calculationDate))" as NSString
                dateText.draw(at: CGPoint(x: padding, y: yPosition), withAttributes: [.font: regularFont])
            }
            
            self.pdfURL = pdfPath
        } catch {
            print("Ошибка при создании PDF: \(error)")
        }
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