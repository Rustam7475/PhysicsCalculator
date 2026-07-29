import SwiftUI
import CoreData
import UIKit

// MARK: - Result View

struct CalculationResultView: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let unitSelections: [String: String]
    let calculationDate: Date
    @Environment(\.dismiss) private var dismiss
    @State private var copiedToClipboard = false
    @State private var showSteps = false

    @FetchRequest private var savedItems: FetchedResults<SavedCalculation>

    init(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String], unitSelections: [String: String] = [:], calculationDate: Date) {
        self.formula = formula
        self.calculatedSymbol = calculatedSymbol
        self.calculatedValue = calculatedValue
        self.inputValues = inputValues
        self.unitSelections = unitSelections
        self.calculationDate = calculationDate

        let predicate = NSPredicate(format: "formulaId == %@ AND isFavorite == YES", formula.id)
        _savedItems = FetchRequest<SavedCalculation>(
            sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: true)],
            predicate: predicate,
            animation: .default
        )
    }

    private var canShowGraph: Bool { formula.variables.count >= 2 }
    private var isFavorite: Bool { !savedItems.isEmpty }

    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateStyle = .long; f.timeStyle = .short; return f
    }()

    private var formattedDate: String {
        let lang = AppSettings.shared.currentLanguageCode
        Self.dateFormatter.locale = Locale(identifier: lang == "ru" ? "ru_RU" : "en_US")
        return Self.dateFormatter.string(from: calculationDate)
    }

    private func displayUnit(for variable: Variable) -> String {
        if let unitId = unitSelections[variable.symbol],
           let units = UnitConverter.units(forSI: variable.unit_si),
           let sel = units.first(where: { $0.id == unitId }) { return sel.symbol }
        return variable.unit_si
    }

    private var displayResult: Double {
        guard let rv = formula.variables.first(where: { $0.symbol == calculatedSymbol }),
              let unitId = unitSelections[calculatedSymbol],
              let units = UnitConverter.units(forSI: rv.unit_si),
              let sel = units.first(where: { $0.id == unitId }) else { return calculatedValue }
        return sel.fromSI(calculatedValue)
    }

    private var resultUnit: String {
        guard let rv = formula.variables.first(where: { $0.symbol == calculatedSymbol }) else { return "" }
        return displayUnit(for: rv)
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(formula.localizedName)
                    .font(.title2.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)

                FormulaDisplayCard(formula: formula, calculatedSymbol: calculatedSymbol, inputValues: inputValues)

                StepByStepSection(
                    formula: formula, calculatedSymbol: calculatedSymbol,
                    calculatedValue: calculatedValue, inputValues: inputValues,
                    unitSelections: unitSelections, isExpanded: $showSteps
                )

                ResultCard(formula: formula, calculatedSymbol: calculatedSymbol,
                          displayResult: displayResult, resultUnit: resultUnit)

                InputValuesCard(formula: formula, calculatedSymbol: calculatedSymbol,
                               inputValues: inputValues, unitSelections: unitSelections)

                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)

                ActionButtonsGrid(
                    formula: formula, calculatedSymbol: calculatedSymbol,
                    calculatedValue: calculatedValue, inputValues: inputValues,
                    unitSelections: unitSelections, canShowGraph: canShowGraph,
                    copiedToClipboard: copiedToClipboard, isFavorite: isFavorite,
                    onCopy: copyResult, onToggleFavorite: toggleFavorite
                )

                VStack(spacing: 12) {
                    NavigationLink(destination: CalculationView(formula: formula)) {
                        Text(L10n.newCalculation)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(12)

                    Button { dismiss() } label: {
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
    }

    // MARK: - Actions

    private func copyResult() {
        UIPasteboard.general.string = generateShareText()
        withAnimation { copiedToClipboard = true }
        Task { try? await Task.sleep(for: .seconds(2)); copiedToClipboard = false }
    }

    private func toggleFavorite() {
        withAnimation {
            if isFavorite {
                for item in savedItems { PersistenceController.shared.deleteCalculation(item) }
            } else {
                var currentInputs: [String: String] = [:]
                for variable in formula.variables where variable.symbol != calculatedSymbol {
                    currentInputs[variable.symbol] = inputValues[variable.symbol, default: ""]
                }
                PersistenceController.shared.saveCalculation(
                    formula: formula, calculatedSymbol: calculatedSymbol,
                    calculatedValue: calculatedValue, inputValues: currentInputs
                )
            }
        }
    }

    private func generateShareText() -> String {
        var text = "📐 \(formula.localizedName)\n\(formula.localizedDescription)\n\n"
        text += L10n.shareInputValues + "\n"
        for v in formula.variables where v.symbol != calculatedSymbol {
            text += "  • \(v.localizedName) = \(inputValues[v.symbol, default: ""]) \(displayUnit(for: v))\n"
        }
        if let rv = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
            text += "\n" + L10n.shareResult + "\n"
            text += "  ▸ \(rv.localizedName) = \(String(format: "%.4g", displayResult)) \(resultUnit)\n"
        }
        text += "\n📅 \(formattedDate)"
        return text
    }
}

// MARK: - Formula Display Card (inline subview — small enough to stay here)

private struct FormulaDisplayCard: View {
    let formula: Formula
    let calculatedSymbol: String
    let inputValues: [String: String]

    var body: some View {
        VStack(spacing: 12) {
            GeometryReader { g in
                MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol),
                          fontSize: min(g.size.width * 0.08, 28))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 50)

            Divider()

            GeometryReader { g in
                MathLabel(latex: formula.getFormulaWithValues(calculatedSymbol: calculatedSymbol, inputValues: inputValues),
                          fontSize: min(g.size.width * 0.07, 24))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(height: 50)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}