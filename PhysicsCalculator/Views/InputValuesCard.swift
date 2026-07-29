import SwiftUI

/// Карточка со списком введённых пользователем значений (исключая вычисленную переменную).
struct InputValuesCard: View {
    let formula: Formula
    let calculatedSymbol: String
    let inputValues: [String: String]
    let unitSelections: [String: String]

    var body: some View {
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
}
