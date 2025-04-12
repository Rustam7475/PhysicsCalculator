import SwiftUI
import MathParser
import CoreData
import SwiftMath



struct CalculationView: View {
    let formula: Formula

    // Состояния
    @State private var inputValues: [String: String]
    @State private var selectedUnknownSymbol: String?
    @State private var calculatedResult: Double?
    @State private var errorMessage: String?
    @State private var showingResult = false
    @State private var calculationDate = Date()
    // isFavorite определяется через FetchRequest

    // Доступ к контексту Core Data
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest для поиска сохраненных расчетов ЭТОЙ формулы
    @FetchRequest private var savedItems: FetchedResults<SavedCalculation>

    // Вычисляемое свойство, чтобы определить, сохранена ли эта формула
    private var isFavorite: Bool {
        !savedItems.isEmpty
    }

    // Инициализатор для настройки FetchRequest
    init(formula: Formula, initialInputValues: [String: String] = [:], initialUnknownSymbol: String? = nil) {
        self.formula = formula
        let predicate = NSPredicate(format: "formulaId == %@", formula.id)
        _savedItems = FetchRequest<SavedCalculation>(
            sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: true)],
            predicate: predicate,
            animation: .default
        )
        // Инициализация состояний
        _inputValues = State(initialValue: initialInputValues)
        _selectedUnknownSymbol = State(initialValue: initialUnknownSymbol)
        _calculatedResult = State(initialValue: nil)
        _errorMessage = State(initialValue: nil)
        _showingResult = State(initialValue: false)
        _calculationDate = State(initialValue: Date())
    }

    // Основное тело View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Заголовок формулы
                Text(formula.localizedName)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                
                // Отображение формулы
                GeometryReader { geometry in
                    MathLabel(latex: formula.equation_latex, 
                            fontSize: min(geometry.size.width, geometry.size.height) * 0.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                
                // Описание
                Text(formula.localizedDescription)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)

                // Список переменных
                ForEach(formula.variables) { variable in
                    VariableInputRow(
                        variable: variable,
                        inputValue: Binding(
                            get: { inputValues[variable.symbol, default: ""] },
                            set: { inputValues[variable.symbol] = $0 }
                        ),
                        isUnknown: selectedUnknownSymbol == variable.symbol,
                        calculatedValue: (selectedUnknownSymbol == variable.symbol) ? calculatedResult : nil,
                        onSelectUnknown: { selectUnknown(symbol: variable.symbol) }
                    )
                    Divider()
                }

                // Отображение ошибки
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.callout)
                }

                // Кнопки действий
                HStack(spacing: 20) {
                    Button("Рассчитать") { calculate() }
                        .buttonStyle(.borderedProminent)
                        .disabled(!canCalculate())
                    Button("Сбросить") { reset() }
                        .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButtonView
            }
        }
        .onAppear {
            // Убираем сброс значений при возврате
            if inputValues.isEmpty {
                reset()
            }
        }
        .navigationDestination(isPresented: $showingResult) {
            if let result = calculatedResult, let symbol = selectedUnknownSymbol {
                CalculationResultView(
                    formula: formula,
                    calculatedSymbol: symbol,
                    calculatedValue: result,
                    inputValues: inputValues,
                    calculationDate: calculationDate
                )
            }
        }
    }

    // Кнопка Избранного
    private var favoriteButtonView: some View {
        Button {
            toggleFavorite()
        } label: {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(isFavorite ? .yellow : .gray)
        }
    }

    // --- Вспомогательные функции ---
    private func selectUnknown(symbol: String) {
        if selectedUnknownSymbol == symbol { selectedUnknownSymbol = nil }
        else { selectedUnknownSymbol = symbol }
        calculatedResult = nil; errorMessage = nil
        if selectedUnknownSymbol == symbol { inputValues[symbol] = "" }
    }

    private func canCalculate() -> Bool {
        guard let unknownSymbol = selectedUnknownSymbol else { return false }
        for variable in formula.variables where variable.symbol != unknownSymbol {
            if inputValues[variable.symbol, default: ""].trimmingCharacters(in: .whitespaces).isEmpty { return false }
        }
        return true
    }

    private func reset() {
        inputValues = [:]
        selectedUnknownSymbol = nil
        calculatedResult = nil
        errorMessage = nil
        showingResult = false
    }

    // --- Функция расчета (ИСПОЛЬЗУЯ DDMathParser - Попытка 8 + Отладка результата) ---
    private func calculate() {
        print("Начало расчета")
        
        guard let unknown = selectedUnknownSymbol else {
            errorMessage = "Выберите неизвестную величину"
            print("Ошибка: не выбрана неизвестная величина")
            return
        }
        
        print("Выбранная неизвестная величина: \(unknown)")
        calculatedResult = nil
        errorMessage = nil
        
        // Собираем словарь подстановок
        var substitutionDictionary: [String: NSNumber] = [:]
        for variable in formula.variables where variable.symbol != unknown {
            guard let valueString = inputValues[variable.symbol]?.replacingOccurrences(of: ",", with: "."),
                  let value = Double(valueString) else {
                errorMessage = "Введите корректное значение для \(variable.localizedName)"
                print("Ошибка: некорректное значение для \(variable.localizedName)")
                return
            }
            substitutionDictionary[variable.symbol] = NSNumber(value: value)
            print("Добавлено значение для \(variable.symbol): \(value)")
        }
        
        guard let ruleString = formula.calculation_rules[unknown] else {
            errorMessage = "Не найдено правило расчета для \(unknown)"
            print("Ошибка: не найдено правило расчета")
            return
        }
        
        print("Правило расчета: \(ruleString)")
        print("Подстановки: \(substitutionDictionary)")
        
        let expression = NSExpression(format: ruleString)
        if let result = expression.expressionValue(with: substitutionDictionary, context: nil) as? NSNumber {
            let resultValue = result.doubleValue
            
            print("Получен результат: \(resultValue)")
            
            if resultValue.isNaN || resultValue.isInfinite {
                errorMessage = "Результат не определен (NaN или бесконечность)"
                print("Ошибка: результат не определен")
            } else {
                calculatedResult = resultValue
                calculationDate = Date()
                print("Устанавливаем showingResult в true")
                DispatchQueue.main.async {
                    showingResult = true
                }
                print("Навигация должна быть активирована")
            }
        } else {
            errorMessage = "Ошибка при вычислении выражения"
            print("Ошибка: не удалось вычислить выражение")
        }
    }
    // --- Конец функции calculate ---

    // --- Функция для переключения статуса "Избранное" ---
    private func toggleFavorite() {
        withAnimation {
            if isFavorite {
                for item in savedItems { PersistenceController.shared.deleteCalculation(item) }
            } else {
                guard let unknown = selectedUnknownSymbol, let result = calculatedResult else {
                    errorMessage = "Сначала выполните расчет, чтобы сохранить в избранное."
                    return
                }
                var currentInputs: [String: String] = [:]
                 for variable in formula.variables where variable.symbol != unknown {
                     currentInputs[variable.symbol] = inputValues[variable.symbol, default: ""]
                 }
                PersistenceController.shared.saveCalculation( formula: formula, calculatedSymbol: unknown, calculatedValue: result, inputValues: currentInputs)
            }
        }
    }

} // Конец struct CalculationView


// --- Вспомогательное View ---
struct VariableInputRow: View {
    let variable: Variable
    @Binding var inputValue: String
    let isUnknown: Bool
    let calculatedValue: Double?
    let onSelectUnknown: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: isUnknown ? "largecircle.fill.circle" : "circle")
                .foregroundColor(isUnknown ? .accentColor : .secondary)
                .onTapGesture(perform: onSelectUnknown)
            Text("\(variable.symbol) (\(variable.localizedName)):")
                .frame(width: 90, alignment: .leading)
            if isUnknown {
                Text("Будет рассчитано")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                TextField("введите значение", text: $inputValue)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 32)
            }
            Text(variable.unit_si)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .trailing)
        }
        .frame(height: 40)
    }
}

// --- Предпросмотр ---
#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let context = persistenceController.container.viewContext
     if let previewData = loadPhysicsData(),
        let formula = previewData.formulas.first(where: { $0.id == "mech_school_newton_second" }) {
         NavigationView {
              CalculationView(formula: formula)
                 .environment(\.managedObjectContext, context)
         }
     } else { Text("Ошибка загрузки данных для превью") }
}
