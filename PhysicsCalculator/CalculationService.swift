import Foundation

// MARK: - Ошибки вычислений
enum CalculationError: LocalizedError {
    case noRuleFound(symbol: String)
    case invalidInput(variable: String)
    case invalidResult
    case evaluationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .noRuleFound(let symbol):
            return "Не найдено правило расчета для \(symbol)"
        case .invalidInput(let variable):
            return "Введите корректное значение для \(variable)"
        case .invalidResult:
            return "Результат не определен (деление на ноль или переполнение)"
        case .evaluationFailed(let message):
            return "Ошибка при вычислении: \(message)"
        }
    }
}

// MARK: - Протокол сервиса вычислений
protocol CalculationServiceProtocol {
    func calculate(rule: String, variables: [String: Double]) throws -> Double
    func validateInput(_ input: String) -> Bool
    func formatResult(_ result: Double) -> String
}

// MARK: - Реализация сервиса вычислений
final class CalculationService: CalculationServiceProtocol {
    
    /// Вычисляет результат по правилу с подстановкой переменных.
    /// - Parameters:
    ///   - rule: Строка-выражение (например, "m * a")
    ///   - variables: Словарь значений переменных
    /// - Returns: Результат вычисления
    func calculate(rule: String, variables: [String: Double]) throws -> Double {
        let nsVariables = variables.mapValues { NSNumber(value: $0) }
        
        let expression: NSExpression
        do {
            expression = NSExpression(format: rule)
        } catch {
            throw CalculationError.evaluationFailed(rule)
        }
        
        guard let result = expression.expressionValue(with: nsVariables, context: nil) as? NSNumber else {
            throw CalculationError.evaluationFailed(rule)
        }
        
        let doubleResult = result.doubleValue
        
        guard !doubleResult.isNaN && !doubleResult.isInfinite else {
            throw CalculationError.invalidResult
        }
        
        return doubleResult
    }
    
    /// Проверяет, является ли строка корректным числом
    func validateInput(_ input: String) -> Bool {
        let cleaned = input.trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: ",", with: ".")
        return !cleaned.isEmpty && Double(cleaned) != nil
    }
    
    /// Форматирует результат для отображения
    func formatResult(_ result: Double) -> String {
        String(format: "%.4g", result)
    }
}
