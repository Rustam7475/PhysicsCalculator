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
    
    init(formula: Formula,
         calculationService: CalculationServiceProtocol = CalculationService(),
         initialInputValues: [String: String] = [:],
         initialUnknownSymbol: String? = nil) {
        self.formula = formula
        self.calculationService = calculationService
        self.inputValues = initialInputValues
        self.selectedUnknownSymbol = initialUnknownSymbol
    }
    
    // MARK: - Выбор неизвестной переменной
    
    func selectUnknown(symbol: String) {
        if selectedUnknownSymbol == symbol {
            selectedUnknownSymbol = nil
            inputValues[symbol] = ""
        } else {
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
        selectedUnknownSymbol = nil
        calculatedResult = nil
        errorMessage = nil
        showingResult = false
    }
    
    // MARK: - Вычисление
    
    func calculate() {
        guard let unknown = selectedUnknownSymbol else {
            errorMessage = "Выберите неизвестную величину"
            return
        }
        
        calculatedResult = nil
        errorMessage = nil
        
        // Собираем значения переменных
        var variables: [String: Double] = [:]
        for variable in formula.variables where variable.symbol != unknown {
            guard let valueString = inputValues[variable.symbol]?
                    .replacingOccurrences(of: ",", with: "."),
                  let value = Double(valueString) else {
                errorMessage = "Введите корректное значение для \(variable.localizedName)"
                return
            }
            variables[variable.symbol] = value
        }
        
        // Получаем правило расчёта
        guard let rule = formula.calculation_rules[unknown] else {
            errorMessage = "Не найдено правило расчета для \(unknown)"
            return
        }
        
        // Вычисляем через сервис
        do {
            let result = try calculationService.calculate(rule: rule, variables: variables)
            calculatedResult = result
            calculationDate = Date()
            showingResult = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
}
