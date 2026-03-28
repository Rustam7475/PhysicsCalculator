import SwiftUI

// MARK: - ViewModel для экрана вычислений
@MainActor
final class CalculationViewModel: ObservableObject {
    
    let formula: Formula
    
    @Published var inputValues: [String: String]
    @Published var selectedUnknownSymbol: String?
    @Published var calculatedResult: Double?
    @Published var errorMessage: String?
    @Published var showingResult = false
    @Published var calculationDate = Date()
    
    private let calculationService: CalculationServiceProtocol
    private let persistenceController: PersistenceControllerProtocol
    
    init(formula: Formula,
         calculationService: CalculationServiceProtocol = CalculationService(),
         persistenceController: PersistenceControllerProtocol = PersistenceController.shared,
         initialInputValues: [String: String] = [:],
         initialUnknownSymbol: String? = nil) {
        self.formula = formula
        self.calculationService = calculationService
        self.persistenceController = persistenceController
        self.selectedUnknownSymbol = initialUnknownSymbol
        
        // Предзаполнение физических констант, затем поверх — переданные значения
        var values: [String: String] = [:]
        for variable in formula.variables {
            if let constant = PhysicalConstants.match(for: variable) {
                values[variable.symbol] = PhysicalConstants.formattedValue(constant)
            }
        }
        for (k, v) in initialInputValues {
            values[k] = v
        }
        self.inputValues = values
    }
    
    // MARK: - Выбор неизвестной переменной
    
    func selectUnknown(symbol: String) {
        if selectedUnknownSymbol == symbol {
            // Снимаем выбор — восстанавливаем значение константы если есть
            selectedUnknownSymbol = nil
            if let variable = formula.variables.first(where: { $0.symbol == symbol }),
               let constant = PhysicalConstants.match(for: variable) {
                inputValues[symbol] = PhysicalConstants.formattedValue(constant)
            } else {
                inputValues[symbol] = ""
            }
        } else {
            // Восстанавливаем значение предыдущей неизвестной, если это константа
            if let prev = selectedUnknownSymbol,
               let prevVar = formula.variables.first(where: { $0.symbol == prev }),
               let constant = PhysicalConstants.match(for: prevVar) {
                inputValues[prev] = PhysicalConstants.formattedValue(constant)
            }
            selectedUnknownSymbol = symbol
            inputValues[symbol] = ""
        }
        calculatedResult = nil
        errorMessage = nil
    }
    
    // MARK: - Проверка готовности к вычислению
    
    var canCalculate: Bool {
        guard let unknownSymbol = selectedUnknownSymbol else { return false }
        for variable in formula.variables where variable.symbol != unknownSymbol {
            if inputValues[variable.symbol, default: ""]
                .trimmingCharacters(in: .whitespaces).isEmpty {
                return false
            }
        }
        return true
    }
    
    // MARK: - Сброс
    
    func reset() {
        inputValues = [:]
        // Предзаполнение физических констант
        for variable in formula.variables {
            if let constant = PhysicalConstants.match(for: variable) {
                inputValues[variable.symbol] = PhysicalConstants.formattedValue(constant)
            }
        }
        selectedUnknownSymbol = nil
        calculatedResult = nil
        errorMessage = nil
        showingResult = false
    }
    
    // MARK: - Вычисление
    
    func calculate(unitSelections: [String: String] = [:]) {
        guard let unknown = selectedUnknownSymbol else {
            errorMessage = L10n.selectUnknownVariable
            return
        }
        
        calculatedResult = nil
        errorMessage = nil
        
        // Собираем значения переменных с конвертацией единиц
        var variables: [String: Double] = [:]
        for variable in formula.variables where variable.symbol != unknown {
            guard let valueString = inputValues[variable.symbol]?
                    .replacingOccurrences(of: ",", with: "."),
                  let value = Double(valueString) else {
                errorMessage = L10n.enterCorrectValue(variable.localizedName)
                return
            }
            
            // Конвертируем в СИ если выбрана нестандартная единица
            var siValue = value
            if let unitId = unitSelections[variable.symbol],
               let units = UnitConverter.units(forSI: variable.unit_si),
               let selectedUnit = units.first(where: { $0.id == unitId }) {
                siValue = selectedUnit.toSI(value)
            }
            variables[variable.symbol] = siValue
        }
        
        // Получаем правило расчёта
        guard let rule = formula.calculation_rules[unknown] else {
            errorMessage = L10n.noRuleFor(unknown)
            return
        }
        
        // Вычисляем через сервис
        do {
            let result = try calculationService.calculate(rule: rule, variables: variables)
            calculatedResult = result
            calculationDate = Date()
            showingResult = true
            
            // Автосохранение в историю
            var currentInputs: [String: String] = [:]
            for variable in formula.variables where variable.symbol != unknown {
                currentInputs[variable.symbol] = inputValues[variable.symbol, default: ""]
            }
            persistenceController.saveToHistory(
                formula: formula,
                calculatedSymbol: unknown,
                calculatedValue: result,
                inputValues: currentInputs
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
