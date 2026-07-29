import SwiftUI

/// Раскрывающийся блок пошагового решения задачи.
struct StepByStepSection: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let unitSelections: [String: String]
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

    // MARK: - Helpers

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
}

// MARK: - Step Row

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
