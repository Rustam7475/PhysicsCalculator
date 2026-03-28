import SwiftUI
import CoreData
import UIKit

struct CalculationResultView: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let unitSelections: [String: String]
    let calculationDate: Date
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showingPDFPreview = false
    @State private var copiedToClipboard = false
    @State private var showSteps = false
    
    // FetchRequest для проверки избранного
    @FetchRequest private var savedItems: FetchedResults<SavedCalculation>
    
    init(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String], unitSelections: [String: String] = [:], calculationDate: Date) {
        self.formula = formula
        self.calculatedSymbol = calculatedSymbol
        self.calculatedValue = calculatedValue
        self.inputValues = inputValues
        self.unitSelections = unitSelections
        self.calculationDate = calculationDate
        
        // Инициализация FetchRequest — только избранное для этой формулы
        let predicate = NSPredicate(format: "formulaId == %@ AND isFavorite == YES", formula.id)
        _savedItems = FetchRequest<SavedCalculation>(
            sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: true)],
            predicate: predicate,
            animation: .default
        )
    }
    
    // Проверяем возможность построения графика
    private var canShowGraph: Bool {
        formula.variables.count >= 2
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var formattedDate: String {
        let lang = AppSettings.shared.currentLanguageCode
        Self.dateFormatter.locale = Locale(identifier: lang == "ru" ? "ru_RU" : "en_US")
        return Self.dateFormatter.string(from: calculationDate)
    }
    
    private var displaySymbol: String {
        Variable.displaySymbol(for: calculatedSymbol)
    }
    
    /// Возвращает символ единицы измерения с учётом выбора пользователя
    private func displayUnit(for variable: Variable) -> String {
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.symbol
        }
        return variable.unit_si
    }
    
    /// Конвертирует введённое значение в СИ с учётом выбранных единиц
    private func siValue(for variable: Variable) -> Double? {
        guard let raw = inputValues[variable.symbol],
              let value = Double(raw.replacingOccurrences(of: ",", with: ".")) else { return nil }
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.toSI(value)
        }
        return value
    }
    
    /// Конвертирует результат из СИ в выбранную пользователем единицу
    private var displayResult: Double {
        guard let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }),
              let unitId = unitSelections[calculatedSymbol],
              let units = UnitConverter.units(forSI: resultVar.unit_si),
              let selectedUnit = units.first(where: { $0.id == unitId }) else {
            return calculatedValue
        }
        return selectedUnit.fromSI(calculatedValue)
    }
    
    /// Единица результата с учётом выбора пользователя
    private var resultUnit: String {
        guard let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) else {
            return ""
        }
        return displayUnit(for: resultVar)
    }
    
    private func getFormulaWithValues() -> String {
        formula.getFormulaWithValues(calculatedSymbol: calculatedSymbol, inputValues: inputValues)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Название формулы
                Text(formula.localizedName)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                
                // Формулы в карточке
                VStack(spacing: 12) {
                    GeometryReader { geometry in
                        MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol),
                                fontSize: min(geometry.size.width * 0.08, 28))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 50)
                    
                    Divider()
                    
                    GeometryReader { geometry in
                        MathLabel(latex: getFormulaWithValues(),
                                fontSize: min(geometry.size.width * 0.07, 24))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 50)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // Пошаговое решение
                StepByStepSection(
                    formula: formula,
                    calculatedSymbol: calculatedSymbol,
                    calculatedValue: calculatedValue,
                    inputValues: inputValues,
                    unitSelections: unitSelections,
                    isExpanded: $showSteps
                )
                
                // Результат — выделенная карточка
                VStack(spacing: 8) {
                    Text(L10n.result)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                        HStack(spacing: 4) {
                            Text(resultVariable.localizedName)
                                .font(.title3)
                            Text("=")
                                .font(.title3)
                            Text(String(format: "%.4g", displayResult))
                                .font(.title.weight(.bold))
                                .foregroundColor(.accentColor)
                            Text(resultUnit)
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // Введённые значения
                VStack(alignment: .leading, spacing: 10) {
                    Text(L10n.inputValues)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    ForEach(formula.variables) { variable in
                        if variable.symbol != calculatedSymbol {
                            HStack {
                                Text(variable.localizedName)
                                    .foregroundColor(.primary)
                                Spacer()
                                Text("\(inputValues[variable.symbol, default: ""]) \(displayUnit(for: variable))")
                                    .fontWeight(.medium)
                            }
                            if variable.id != formula.variables.filter({ $0.symbol != calculatedSymbol }).last?.id {
                                Divider()
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // Дата
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Кнопки действий — сетка
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: canShowGraph ? 3 : 2), spacing: 12) {
                    ActionButton(icon: copiedToClipboard ? "checkmark.circle.fill" : "doc.on.doc",
                                label: L10n.copy,
                                color: copiedToClipboard ? .green : .accentColor) {
                        copyResult()
                    }
                    
                    ActionButton(icon: "arrow.down.doc", label: "PDF", color: .accentColor) {
                        showingPDFPreview = true
                    }
                    
                    if canShowGraph,
                       let xVar = formula.variables.first(where: { $0.symbol != calculatedSymbol }),
                       let yVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                        NavigationLink {
                            FormulaGraphView(
                                formula: formula,
                                xVariable: xVar,
                                yVariable: yVar,
                                otherValues: formula.variables.reduce(into: [:]) { result, variable in
                                    if variable.symbol != calculatedSymbol,
                                       let converted = siValue(for: variable) {
                                        result[variable.symbol] = converted
                                    }
                                }
                            )
                        } label: {
                            ActionButtonLabel(icon: "chart.line.uptrend.xyaxis", label: L10n.graph, color: .accentColor)
                        }
                    }
                    
                    ShareLink(item: generateShareText()) {
                        ActionButtonLabel(icon: "square.and.arrow.up", label: L10n.share, color: .accentColor)
                    }
                    
                    ActionButton(icon: isFavorite ? "star.fill" : "star",
                                label: L10n.favorite,
                                color: isFavorite ? .yellow : .accentColor) {
                        toggleFavorite()
                    }
                    
                    NavigationLink {
                        MultiCalcView(formula: formula, unknownSymbol: calculatedSymbol)
                    } label: {
                        ActionButtonLabel(icon: "tablecells", label: L10n.multi, color: .accentColor)
                    }
                    
                    NavigationLink {
                        ErrorCalculatorView(
                            formula: formula,
                            calculatedSymbol: calculatedSymbol,
                            calculatedValue: calculatedValue,
                            inputValues: inputValues
                        )
                    } label: {
                        ActionButtonLabel(icon: "plusminus", label: L10n.errorCalc, color: .accentColor)
                    }
                }
                
                // Кнопки навигации
                VStack(spacing: 12) {
                    NavigationLink(destination: CalculationView(formula: formula)) {
                        Text(L10n.newCalculation)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(12)
                    
                    Button {
                        dismiss()
                    } label: {
                        Text(L10n.backToCalculation)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(12)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarTitleDisplayMode(.inline)
        .oledBackground()
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
        let text = generateShareText()
        UIPasteboard.general.string = text
        withAnimation {
            copiedToClipboard = true
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            copiedToClipboard = false
        }
    }
    
    private func generateShareText() -> String {
        var text = "📐 \(formula.localizedName)\n"
        text += "\(formula.localizedDescription)\n\n"
        
        text += L10n.shareInputValues + "\n"
        for variable in formula.variables where variable.symbol != calculatedSymbol {
            let value = inputValues[variable.symbol, default: ""]
            text += "  • \(variable.localizedName) = \(value) \(displayUnit(for: variable))\n"
        }
        
        if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
            text += "\n" + L10n.shareResult + "\n"
            text += "  ▸ \(resultVariable.localizedName) = \(String(format: "%.4g", displayResult)) \(resultUnit)\n"
        }
        
        text += "\n📅 \(formattedDate)"
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



// MARK: - Action Button

struct ActionButton: View {
    let icon: String
    let label: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ActionButtonLabel(icon: icon, label: label, color: color)
        }
    }
}

struct ActionButtonLabel: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            Text(label)
                .font(.caption2)
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Step-by-step Solution

struct StepByStepSection: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let unitSelections: [String: String]
    @Binding var isExpanded: Bool
    
    private func displayUnit(for variable: Variable) -> String {
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.symbol
        }
        return variable.unit_si
    }
    
    private func displayResultValue(for variable: Variable) -> Double {
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.fromSI(calculatedValue)
        }
        return calculatedValue
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header button
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "list.number")
                        .foregroundColor(.accentColor)
                    Text(L10n.stepByStep)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding()
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    
                    // Step 1: Original formula
                    StepRow(number: 1, title: L10n.stepOriginalFormula) {
                        GeometryReader { geometry in
                            MathLabel(latex: formula.equation_latex,
                                    fontSize: min(geometry.size.width * 0.07, 24))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: 44)
                    }
                    
                    // Step 2: Rearrange (skip if the unknown is already the left-hand side)
                    let rearranged = formula.getRearrangedFormula(for: calculatedSymbol)
                    if rearranged != formula.equation_latex {
                        StepRow(number: 2, title: L10n.stepRearrange) {
                            GeometryReader { geometry in
                                MathLabel(latex: rearranged,
                                        fontSize: min(geometry.size.width * 0.07, 24))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(height: 44)
                        }
                    }
                    
                    // Step 3: Substitute values
                    let stepNumber = rearranged != formula.equation_latex ? 3 : 2
                    StepRow(number: stepNumber, title: L10n.stepSubstitute) {
                        VStack(alignment: .leading, spacing: 6) {
                            ForEach(formula.variables.filter { $0.symbol != calculatedSymbol }, id: \.symbol) { variable in
                                HStack(spacing: 4) {
                                    Text(variable.localizedName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("=")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text("\(inputValues[variable.symbol, default: ""]) \(displayUnit(for: variable))")
                                        .font(.subheadline.weight(.medium))
                                }
                            }
                            
                            GeometryReader { geometry in
                                MathLabel(latex: formula.getFormulaWithValues(calculatedSymbol: calculatedSymbol, inputValues: inputValues),
                                        fontSize: min(geometry.size.width * 0.065, 22))
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .frame(height: 44)
                        }
                    }
                    
                    // Step 4: Result
                    StepRow(number: stepNumber + 1, title: L10n.stepCalculate) {
                        if let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                            let resultDisplay = displayResultValue(for: resultVar)
                            HStack(spacing: 4) {
                                Text(resultVar.localizedName)
                                    .font(.headline)
                                Text("=")
                                    .font(.headline)
                                Text(String(format: "%.4g", resultDisplay))
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(.accentColor)
                                Text(displayUnit(for: resultVar))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

struct StepRow<Content: View>: View {
    let number: Int
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("\(number)")
                    .font(.caption.weight(.bold))
                    .foregroundColor(.white)
                    .frame(width: 22, height: 22)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                Text(title)
                    .font(.subheadline.weight(.medium))
                    .foregroundColor(.secondary)
            }
            content
        }
    }
}