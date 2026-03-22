import SwiftUI
import CoreData
import UIKit

struct CalculationResultView: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let calculationDate: Date
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showShareSheet = false
    @State private var showingPDFPreview = false
    @State private var copiedToClipboard = false
    
    // FetchRequest для проверки избранного
    @FetchRequest private var savedItems: FetchedResults<SavedCalculation>
    
    init(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String], calculationDate: Date) {
        self.formula = formula
        self.calculatedSymbol = calculatedSymbol
        self.calculatedValue = calculatedValue
        self.inputValues = inputValues
        self.calculationDate = calculationDate
        
        // Инициализация FetchRequest
        let predicate = NSPredicate(format: "formulaId == %@", formula.id)
        _savedItems = FetchRequest<SavedCalculation>(
            sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: true)],
            predicate: predicate,
            animation: .default
        )
    }
    
    // Проверяем возможность построения графика
    private var canShowGraph: Bool {
        // График можно построить, если есть хотя бы две переменные
        formula.variables.count >= 2
    }
    
    // Вспомогательные функции
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: calculationDate)
    }
    
    private func getFormulaWithValues() -> String {
        formula.getFormulaWithValues(calculatedSymbol: calculatedSymbol, inputValues: inputValues)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Верхняя панель с кнопками действий
            HStack(spacing: 20) {
                Button(action: copyResult) {
                    VStack {
                        Image(systemName: copiedToClipboard ? "checkmark.circle.fill" : "doc.on.doc")
                            .font(.system(size: 20))
                        Text("Копировать")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                if canShowGraph {
                    NavigationLink {
                        FormulaGraphView(
                            formula: formula,
                            xVariable: formula.variables.first { $0.symbol != calculatedSymbol }!,
                            yVariable: formula.variables.first { $0.symbol == calculatedSymbol }!,
                            otherValues: formula.variables.reduce(into: [:]) { result, variable in
                                if variable.symbol != calculatedSymbol,
                                   let value = inputValues[variable.symbol],
                                   let doubleValue = Double(value.replacingOccurrences(of: ",", with: ".")) {
                                    result[variable.symbol] = doubleValue
                                }
                            }
                        )
                    } label: {
                        VStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 20))
                            Text("График")
                                .font(.caption)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                Button(action: { showingPDFPreview = true }) {
                    VStack {
                        Image(systemName: "arrow.down.doc")
                            .font(.system(size: 20))
                        Text("PDF")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: { showShareSheet = true }) {
                    VStack {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                        Text("Поделиться")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                Button(action: toggleFavorite) {
                    VStack {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .font(.system(size: 20))
                            .foregroundColor(isFavorite ? .yellow : .gray)
                        Text("Избранное")
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 2)
            
            // Основной контент
            VStack(alignment: .leading, spacing: 8) {
                Text(formula.localizedName)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                // Формула в символах
                GeometryReader { geometry in
                    MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol), 
                            fontSize: min(geometry.size.width, geometry.size.height) * 0.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                
                // Формула с подставленными значениями
                GeometryReader { geometry in
                    MathLabel(latex: getFormulaWithValues(), 
                            fontSize: min(geometry.size.width, geometry.size.height) * 0.4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                
                // Контейнер для значений
                VStack(spacing: 16) {
                    // Введенные значения
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Введенные значения:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        ForEach(formula.variables) { variable in
                            if variable.symbol != calculatedSymbol {
                                HStack {
                                    Text("\(variable.localizedName):")
                                    Text("\(inputValues[variable.symbol, default: ""]) \(variable.unit_si)")
                                        .bold()
                                }
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                    
                    // Результат
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Результат:")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                            HStack {
                                Text("\(resultVariable.localizedName):")
                                Text("\(String(format: "%.4g", calculatedValue)) \(resultVariable.unit_si)")
                                    .bold()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                
                // Дата и время расчета
                Text("Расчет выполнен: \(formattedDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .leading)
                    .padding(.horizontal)
            }
            .padding()
            
            // Кнопки навигации
            VStack(spacing: 12) {
                NavigationLink(destination: CalculationView(
                    formula: formula
                )) {
                    Text("Новый расчет")
                }
                .buttonStyle(.borderedProminent)
                
                Button("Вернуться к расчету") {
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [generateShareText()])
        }
        .sheet(isPresented: $showingPDFPreview) {
            PDFPreview(
                formula: formula,
                calculatedSymbol: calculatedSymbol,
                calculatedValue: calculatedValue,
                inputValues: inputValues,
                calculationDate: calculationDate
            )
        }
    }
    
    private func copyResult() {
        if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
            let resultText = "\(String(format: "%.4g", calculatedValue)) \(resultVariable.unit_si)"
            UIPasteboard.general.string = resultText
            withAnimation {
                copiedToClipboard = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                copiedToClipboard = false
            }
        }
    }
    
    private func generateShareText() -> String {
        var text = "\(formula.localizedName)\n"
        text += "Результат расчета:\n"
        for variable in formula.variables {
            if variable.symbol == calculatedSymbol {
                text += "\(variable.localizedName): \(String(format: "%.4g", calculatedValue)) \(variable.unit_si)\n"
            } else {
                text += "\(variable.localizedName): \(inputValues[variable.symbol, default: ""]) \(variable.unit_si)\n"
            }
        }
        return text
    }
    
    private func toggleFavorite() {
        withAnimation {
            if isFavorite {
                // Удаляем из избранного
                for item in savedItems {
                    PersistenceController.shared.deleteCalculation(item)
                }
            } else {
                // Добавляем в избранное
                var currentInputs: [String: String] = [:]
                for variable in formula.variables where variable.symbol != calculatedSymbol {
                    currentInputs[variable.symbol] = inputValues[variable.symbol, default: ""]
                }
                PersistenceController.shared.saveCalculation(
                    formula: formula,
                    calculatedSymbol: calculatedSymbol,
                    calculatedValue: calculatedValue,
                    inputValues: currentInputs
                )
            }
        }
    }
    
    private var isFavorite: Bool {
        !savedItems.isEmpty
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
} 