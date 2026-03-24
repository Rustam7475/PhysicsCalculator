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

    @State private var showingPDFPreview = false
    @State private var copiedToClipboard = false
    @State private var showSteps = true
    
    // FetchRequest для проверки избранного
    @FetchRequest private var savedItems: FetchedResults<SavedCalculation>
    
    init(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String], calculationDate: Date) {
        self.formula = formula
        self.calculatedSymbol = calculatedSymbol
        self.calculatedValue = calculatedValue
        self.inputValues = inputValues
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
        formatter.locale = Locale(identifier: AppSettings.shared.currentLanguageCode == "ru" ? "ru_RU" : "en_US")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: AppSettings.shared.currentLanguageCode == "ru" ? "ru_RU" : "en_US")
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: calculationDate)
    }
    
    private var displaySymbol: String {
        let greekMap: [String: String] = [
            "nu": "ν", "alpha": "α", "beta": "β", "gamma": "γ",
            "delta": "δ", "epsilon": "ε", "theta": "θ", "lambda": "λ",
            "mu": "μ", "rho": "ρ", "sigma": "σ", "tau": "τ",
            "phi": "φ", "omega": "ω", "eta": "η", "Phi": "Φ",
            "DeltaS": "ΔS", "DeltaU": "ΔU", "DeltaT": "ΔT",
            "dPhi": "ΔΦ", "dphi": "Δφ", "dPhiB": "dΦ_B", "dPhiE": "dΦ_E",
            "alpha1": "α₁", "alpha2": "α₂",
            "v1prime": "v'₁", "v2prime": "v'₂",
            "n_ord": "n", "Avyh": "A_вых", "Eup": "E_уп", "Ep": "E_p",
            "eps0": "ε₀", "mu0": "μ₀", "Z0": "Z₀", "Id": "I_d"
        ]
        return greekMap[calculatedSymbol] ?? calculatedSymbol
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
                            Text(String(format: "%.4g", calculatedValue))
                                .font(.title.weight(.bold))
                                .foregroundColor(.accentColor)
                            Text(resultVariable.unit_si)
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
                                Text("\(inputValues[variable.symbol, default: ""]) \(variable.unit_si)")
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
                                       let value = inputValues[variable.symbol],
                                       let doubleValue = Double(value.replacingOccurrences(of: ",", with: ".")) {
                                        result[variable.symbol] = doubleValue
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            copiedToClipboard = false
        }
    }
    
    private func generateShareText() -> String {
        var text = "📐 \(formula.localizedName)\n"
        text += "\(formula.localizedDescription)\n\n"
        
        text += L10n.shareInputValues + "\n"
        for variable in formula.variables where variable.symbol != calculatedSymbol {
            let value = inputValues[variable.symbol, default: ""]
            text += "  • \(variable.localizedName) = \(value) \(variable.unit_si)\n"
        }
        
        if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
            text += "\n" + L10n.shareResult + "\n"
            text += "  ▸ \(resultVariable.localizedName) = \(String(format: "%.4g", calculatedValue)) \(resultVariable.unit_si)\n"
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
    @Binding var isExpanded: Bool
    
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
                                    Text("\(inputValues[variable.symbol, default: ""]) \(variable.unit_si)")
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
                            HStack(spacing: 4) {
                                Text(resultVar.localizedName)
                                    .font(.headline)
                                Text("=")
                                    .font(.headline)
                                Text(String(format: "%.4g", calculatedValue))
                                    .font(.headline.weight(.bold))
                                    .foregroundColor(.accentColor)
                                Text(resultVar.unit_si)
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