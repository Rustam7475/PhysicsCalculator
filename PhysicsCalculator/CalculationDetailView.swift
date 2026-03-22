import SwiftUI
// import UIKit // Удалено, не требуется
import CoreData // Потребуется для ObservedObject
import SwiftMath


struct CalculationDetailView: View {
    // Получаем сохраненный объект из FavoritesView
    @ObservedObject var savedCalculation: SavedCalculation

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
        guard let _ = savedCalculation.equationLatex,
              let inputs = savedCalculation.inputValues,
              let calculatedSymbol = savedCalculation.calculatedSymbol,
              let formulaVars = savedCalculation.formulaVariables
        else { return savedCalculation.equationLatex ?? "Формула не найдена" }

        // Формируем левую часть — символ вычисляемой переменной
        let leftSide = calculatedSymbol
        // Формируем правую часть — выражение с подставленными значениями
        var rightSide = ""
        if let formulaId = savedCalculation.formulaId,
           let physicsData = loadPhysicsData(),
           let formula = physicsData.formulas.first(where: { $0.id == formulaId }),
           let rule = formula.calculation_rules[calculatedSymbol] {
            // Заменяем символы переменных их значениями
            rightSide = rule
            for variable in formulaVars where variable.symbol != calculatedSymbol {
                if let value = inputs[variable.symbol] {
                    rightSide = rightSide.replacingOccurrences(of: variable.symbol, with: value)
                }
            }
            // Заменяем операторы на LaTeX-эквиваленты
            rightSide = rightSide.replacingOccurrences(of: "*", with: " \\cdot ")
                                 .replacingOccurrences(of: "/", with: " \\div ")
        } else {
            // Fallback: просто подставляем значения через умножение
            var expressionParts: [String] = []
            for variable in formulaVars where variable.symbol != calculatedSymbol {
                if let value = inputs[variable.symbol] {
                    expressionParts.append(value)
                }
            }
            rightSide = expressionParts.joined(separator: " \\cdot ")
        }
        return "\\displaystyle " + leftSide + " = " + rightSide
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


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // 1. Название формулы
                Text(savedCalculation.formulaName ?? "Детали расчета")
                    .font(.largeTitle)
                    .padding(.bottom)

                // 2. Формула с символами
                Text("Формула:")
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
                Text("Решение:")
                    .font(.headline)
                MathLabel(latex: solvedEquationString)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                // 4. Список всех переменных
                Text("Значения:")
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
                            Text("(Рассчитано)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Divider()
                }

                // 5. Дата сохранения
                HStack {
                     Spacer()
                     Text("Сохранено: \(savedCalculation.timestamp ?? Date(), formatter: Self.dateFormatter)")
                         .font(.caption)
                         .foregroundColor(.secondary)
                     Spacer()
                 }
                 .padding(.top)

            } // Конец VStack
            .padding() // Отступы для VStack
        } // Конец ScrollView
        // Устанавливаем заголовок NavigationBar (но можно и не дублировать)
        // .navigationTitle("Детали расчета")
        // .navigationBarTitleDisplayMode(.inline)
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
