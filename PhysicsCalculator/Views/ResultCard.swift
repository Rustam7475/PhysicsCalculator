import SwiftUI

/// Карточка с результатом расчёта: имя переменной, значение, единица измерения.
struct ResultCard: View {
    let formula: Formula
    let calculatedSymbol: String
    let displayResult: Double
    let resultUnit: String

    var body: some View {
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
    }
}
