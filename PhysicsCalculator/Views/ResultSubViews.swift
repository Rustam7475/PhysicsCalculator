import SwiftUI

// MARK: - Карточка формулы (LaTeX)

/// Отображает формулу в двух видах: исходная и с подставленными значениями.
struct ResultFormulaCard: View {
    let formula: Formula
    let calculatedSymbol: String
    let inputValues: [String: String]

    var body: some View {
        VStack(spacing: 12) {
            GeometryReader { geometry in
                MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol),
                        fontSize: min(geometry.size.width * 0.08, 28))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 50)

            Divider()

            GeometryReader { geometry in
                MathLabel(latex: formula.getFormulaWithValues(calculatedSymbol: calculatedSymbol, inputValues: inputValues),
                        fontSize: min(geometry.size.width * 0.07, 24))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 50)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

// MARK: - Карточка введённых значений

struct ResultInputValuesCard: View {
    let formula: Formula
    let calculatedSymbol: String
    let inputValues: [String: String]
    let unitSelections: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(L10n.inputValues)
                .font(.subheadline)
                .foregroundColor(.secondary)

            ForEach(Array(formula.variables.enumerated()), id: \.element.id) { index, variable in
                if variable.symbol != calculatedSymbol {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(variable.localizedName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text("\(inputValues[variable.symbol, default: ""]) \(displayUnit(for: variable))")
                            .font(.body.weight(.medium))
                            .foregroundColor(.primary)
                    }
                    if index < formula.variables.count - 1 {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }

    private func displayUnit(for variable: Variable) -> String {
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let selectedUnit = units.first(where: { $0.id == unitId }) {
            return selectedUnit.symbol
        }
        return variable.unit_si
    }
}

// MARK: - Сетка кнопок действий

struct ResultActionButtons: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let unitSelections: [String: String]
    let canShowGraph: Bool
    let isFavorite: Bool
    let copiedToClipboard: Bool

    let onCopy: () -> Void
    let onPDF: () -> Void
    let onShare: () -> Void
    let onToggleFavorite: () -> Void

    @State private var showingPaywall = false
    private let premium = PremiumManager.shared

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: canShowGraph ? 3 : 2), spacing: 12) {
            ActionButton(icon: copiedToClipboard ? "checkmark.circle.fill" : "doc.on.doc",
                        label: L10n.copy,
                        color: copiedToClipboard ? .green : .accentColor) {
                onCopy()
            }

            ActionButton(icon: "arrow.down.doc", label: "PDF", color: premium.isPDFAvailable ? .accentColor : .secondary) {
                if premium.isPDFAvailable {
                    onPDF()
                } else {
                    showingPaywall = true
                }
            }
            .overlay(premiumBadge(visible: !premium.isPDFAvailable))

            if canShowGraph,
               let xVar = formula.variables.first(where: { $0.symbol != calculatedSymbol }),
               let yVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                if premium.isGraphAvailable {
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
                } else {
                    Button { showingPaywall = true } label: {
                        ActionButtonLabel(icon: "chart.line.uptrend.xyaxis", label: L10n.graph, color: .secondary)
                    }
                    .overlay(premiumBadge(visible: true))
                }
            }

            ActionButton(icon: "square.and.arrow.up", label: L10n.share, color: .accentColor) {
                onShare()
            }

            ActionButton(icon: isFavorite ? "star.fill" : "star",
                        label: L10n.favorite,
                        color: !premium.isFavoritesAvailable ? .secondary : (isFavorite ? .yellow : .accentColor)) {
                if premium.isFavoritesAvailable {
                    onToggleFavorite()
                } else {
                    showingPaywall = true
                }
            }
            .overlay(premiumBadge(visible: !premium.isFavoritesAvailable))

            NavigationLink {
                MultiCalcView(formula: formula, unknownSymbol: calculatedSymbol)
            } label: {
                ActionButtonLabel(icon: "tablecells", label: L10n.multi, color: .accentColor)
            }

            if premium.isErrorCalcAvailable {
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
            } else {
                Button { showingPaywall = true } label: {
                    ActionButtonLabel(icon: "plusminus", label: L10n.errorCalc, color: .secondary)
                }
                .overlay(premiumBadge(visible: true))
            }
        }
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }

    @ViewBuilder
    private func premiumBadge(visible: Bool) -> some View {
        if visible {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "lock.fill")
                        .font(.system(size: 10))
                        .foregroundColor(.white)
                        .padding(4)
                        .background(Color.orange)
                        .clipShape(Circle())
                        .offset(x: 4, y: -4)
                }
                Spacer()
            }
        }
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
}
