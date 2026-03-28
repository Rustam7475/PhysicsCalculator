import SwiftUI
// import UIKit // Удалено, не требуется
import CoreData // Потребуется для ObservedObject
import SwiftMath


struct CalculationDetailView: View {
    // Получаем сохраненный объект из FavoritesView
    @ObservedObject var savedCalculation: SavedCalculation
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var copiedToClipboard = false

    // Форматтер для даты
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Можно сделать стиль даты подробнее
        formatter.timeStyle = .short
        return formatter
    }()

    // --- Вспомогательные вычисляемые свойства ---

    // Формула с подставленными значениями
    private var solvedEquationString: String {
        guard let inputs = savedCalculation.inputValues,
              let calculatedSymbol = savedCalculation.calculatedSymbol
        else { return savedCalculation.equationLatex ?? L10n.formulaNotFound }

        if let formulaId = savedCalculation.formulaId,
           let physicsData = loadPhysicsData(),
           let formula = physicsData.formulas.first(where: { $0.id == formulaId }) {
            return "\\displaystyle " + formula.getFormulaWithValues(
                calculatedSymbol: calculatedSymbol,
                inputValues: inputs
            )
        }
        
        // Fallback
        guard let formulaVars = savedCalculation.formulaVariables else {
            return savedCalculation.equationLatex ?? L10n.formulaNotFound
        }
        let parts = formulaVars
            .filter { $0.symbol != calculatedSymbol }
            .compactMap { inputs[$0.symbol] }
        return "\\displaystyle " + calculatedSymbol + " = " + parts.joined(separator: " \\cdot ")
    }

    // Список всех переменных (введенных и рассчитанной)
    private var allVariablesList: [(symbol: String, name: String, value: String, unit: String, isCalculated: Bool)] {
        guard let formulaVars = savedCalculation.formulaVariables, // Используем декодированные данные
              let inputs = savedCalculation.inputValues,
              let calculatedSymbol = savedCalculation.calculatedSymbol
        else { return [] }

        var list: [(symbol: String, name: String, value: String, unit: String, isCalculated: Bool)] = []

        for variable in formulaVars {
            let isCalculated = (variable.symbol == calculatedSymbol)
            var valueString: String

            if isCalculated {
                valueString = String(format: "%.4g", savedCalculation.calculatedValue)
            } else {
                // Ищем введенное значение, форматируем если это число
                 if let inputValue = inputs[variable.symbol] {
                     if let doubleVal = Double(inputValue) {
                         valueString = String(format: "%.4g", doubleVal)
                     } else {
                         valueString = inputValue // Если не число
                     }
                 } else {
                     valueString = "???" // Если значение не найдено
                 }
            }
            list.append((symbol: variable.symbol, name: variable.localizedName, value: valueString, unit: variable.unit_si, isCalculated: isCalculated))
        }
        // Сортируем, чтобы рассчитанная была последней (или первой)
        list.sort { !$0.isCalculated && $1.isCalculated }
        return list
    }


    private func generateDetailShareText() -> String {
        var text = "📐 \(savedCalculation.formulaName ?? "")\n\n"
        
        for item in allVariablesList {
            let prefix = item.isCalculated ? "▸ " : "  • "
            text += "\(prefix)\(item.name) = \(item.value) \(item.unit)"
            if item.isCalculated { text += " (\(L10n.calculated))" }
            text += "\n"
        }
        
        if let date = savedCalculation.timestamp {
            text += "\n📅 \(Self.dateFormatter.string(from: date))"
        }
        return text
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // 1. Название формулы
                Text(savedCalculation.formulaName ?? L10n.detailsTitle)
                    .font(.largeTitle)
                    .padding(.bottom)

                // 2. Формула с символами
                Text(L10n.formulaLabel)
                    .font(.headline)
                Group {
                    if let formulaId = savedCalculation.formulaId,
                       let calculatedSymbol = savedCalculation.calculatedSymbol,
                       let physicsData = loadPhysicsData(),
                       let formula = physicsData.formulas.first(where: { $0.id == formulaId }) {
                        MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol))
                            .font(.title2)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.bottom, 8)
                    } else {
                        MathLabel(latex: savedCalculation.equationLatex ?? "")
                            .font(.title2)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.bottom, 8)
                    }
                }

                // 3. Формула с подставленными значениями
                Text(L10n.solutionLabel)
                    .font(.headline)
                MathLabel(latex: solvedEquationString)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                // 4. Список всех переменных
                Text(L10n.valuesLabel)
                    .font(.headline)
                ForEach(allVariablesList, id: \.symbol) { item in
                    HStack {
                        Text("\(item.symbol) (\(item.name)):")
                            .frame(width: 130, alignment: .leading) // Ширина для выравнивания
                        Spacer()
                        Text(item.value)
                            .fontWeight(item.isCalculated ? .bold : .regular) // Выделяем результат
                        Text(item.unit)
                            .foregroundColor(.secondary)
                        if item.isCalculated {
                            Text("(\(L10n.calculated))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Divider()
                }

                // 5. Дата сохранения
                HStack {
                     Spacer()
                     Text("\(L10n.savedAt) \(savedCalculation.timestamp ?? Date(), formatter: Self.dateFormatter)")
                         .font(.caption)
                         .foregroundColor(.secondary)
                     Spacer()
                 }
                 .padding(.top)

                // 6. Кнопки действий
                HStack(spacing: 12) {
                    Button {
                        UIPasteboard.general.string = generateDetailShareText()
                        withAnimation { copiedToClipboard = true }
                        Task {
                            try? await Task.sleep(for: .seconds(2))
                            copiedToClipboard = false
                        }
                    } label: {
                        ActionButtonLabel(
                            icon: copiedToClipboard ? "checkmark.circle.fill" : "doc.on.doc",
                            label: L10n.copy,
                            color: copiedToClipboard ? .green : .accentColor
                        )
                    }
                    
                    ShareLink(item: generateDetailShareText()) {
                        ActionButtonLabel(icon: "square.and.arrow.up", label: L10n.share, color: .accentColor)
                    }
                    
                    if let formulaId = savedCalculation.formulaId,
                       let physicsData = loadPhysicsData(),
                       let formula = physicsData.formulas.first(where: { $0.id == formulaId }) {
                        NavigationLink {
                            CalculationView(formula: formula)
                        } label: {
                            ActionButtonLabel(icon: "arrow.counterclockwise", label: L10n.newCalculation, color: .accentColor)
                        }
                    }
                }
                .padding(.top, 4)

            } // Конец VStack
            .padding() // Отступы для VStack
        } // Конец ScrollView
        .navigationTitle(L10n.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
        .oledBackground()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert(L10n.deleteCalcTitle, isPresented: $showDeleteConfirmation) {
            Button(L10n.delete, role: .destructive) {
                PersistenceController.shared.deleteCalculation(savedCalculation)
                dismiss()
            }
            Button(L10n.cancel, role: .cancel) {}
        } message: {
            Text(L10n.deleteCalcMessage)
        }
    } // Конец body
} // Конец CalculationDetailView


// --- Предпросмотр для CalculationDetailView ---
#Preview {
    // Создаем моковый контекст и один моковый объект SavedCalculation
    let controller = PersistenceController(inMemory: true)
    let context = controller.container.viewContext

    // Нужны моковые данные для Formula и Variable
     struct MockVariable: Codable, Identifiable, Hashable { var id: String { symbol }; let symbol: String; let name_ru: String; let name_en: String; let unit_si: String; var localizedName: String { name_ru }}
     struct MockFormula: Codable, Identifiable, Hashable { var id: String; let subsectionId: String; let name_ru: String; let name_en: String; let levels: [String]; let equation_latex: String; let description_ru: String; let description_en: String; let variables: [MockVariable]; let calculation_rules: [String: String]; var localizedName: String { name_ru } }

     let mockVars = [
         MockVariable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
         MockVariable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
         MockVariable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
     ]
     let mockFormula = MockFormula(id: "newton_second", subsectionId: "dyn", name_ru: "Второй закон Ньютона", name_en: "NLS", levels: ["s"], equation_latex: "F = m \\cdot a", description_ru: "", description_en: "", variables: mockVars, calculation_rules: [:])

     let mockSavedCalc = SavedCalculation(context: context)
     mockSavedCalc.formulaId = mockFormula.id
     mockSavedCalc.formulaName = mockFormula.localizedName
     mockSavedCalc.equationLatex = mockFormula.equation_latex
     mockSavedCalc.calculatedSymbol = "F"
     mockSavedCalc.calculatedValue = 804.0
     mockSavedCalc.timestamp = Date()
     // Кодируем словари/массивы
     mockSavedCalc.inputValuesData = try? JSONEncoder().encode(["m": "23", "a": "35"]) // Входные данные как строки
     mockSavedCalc.variablesData = try? JSONEncoder().encode(mockVars) // Переменные формулы

    return NavigationView { // Оборачиваем в NavigationView для работы NavigationLink
        CalculationDetailView(savedCalculation: mockSavedCalc)
           .environment(\.managedObjectContext, context)
    }
}
