import SwiftUI

/// Сетка кнопок действий (копировать, PDF, график, поделиться, избранное, мульти, погрешности).
struct ActionButtonsGrid: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let unitSelections: [String: String]
    let canShowGraph: Bool
    let copiedToClipboard: Bool
    let isFavorite: Bool
    let onCopy: () -> Void
    let onToggleFavorite: () -> Void

    @State private var showingPDFPreview = false

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: canShowGraph ? 3 : 2), spacing: 12) {
            ActionButton(icon: copiedToClipboard ? "checkmark.circle.fill" : "doc.on.doc",
                        label: L10n.copy,
                        color: copiedToClipboard ? .green : .accentColor) {
                onCopy()
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
                onToggleFavorite()
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
        .sheet(isPresented: $showingPDFPreview) {
            PDFPreview(
                formula: formula,
                calculatedSymbol: calculatedSymbol,
                calculatedValue: calculatedValue,
                inputValues: inputValues,
                calculationDate: Date()
            )
        }
    }

    // MARK: - Helpers

    private func displayUnit(for variable: Variable) -> String {
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.symbol
        }
        return variable.unit_si
    }

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

    private func displayResultValue(for variable: Variable) -> Double {
        if let unitId = unitSelections[calculatedSymbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.fromSI(calculatedValue)
        }
        return calculatedValue
    }

    private func resultUnit() -> String {
        guard let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) else {
            return ""
        }
        return displayUnit(for: resultVar)
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
            let displayResult = displayResultValue(for: resultVariable)
            text += "\n" + L10n.shareResult + "\n"
            text += "  ▸ \(resultVariable.localizedName) = \(String(format: "%.4g", displayResult)) \(resultUnit())\n"
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        let lang = AppSettings.shared.currentLanguageCode
        formatter.locale = Locale(identifier: lang == "ru" ? "ru_RU" : "en_US")
        text += "\n📅 \(formatter.string(from: Date()))"
        return text
    }
}

// MARK: - Action Button Components

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
