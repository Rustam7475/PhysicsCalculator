import Foundation
import JavaScriptCore

// MARK: - Ошибки вычислений
enum CalculationError: LocalizedError {
    case noRuleFound(symbol: String)
    case invalidInput(variable: String)
    case invalidResult
    case evaluationFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .noRuleFound(let symbol):
            return L10n.noRuleFor(symbol)
        case .invalidInput(let variable):
            return L10n.enterCorrectValue(variable)
        case .invalidResult:
            return L10n.invalidResult
        case .evaluationFailed(let message):
            return L10n.evaluationError(message)
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
    
    private let jsContext: JSContext = {
        let ctx = JSContext()!
        ctx.evaluateScript("""
            var sin = Math.sin; var cos = Math.cos; var tan = Math.tan;
            var asin = Math.asin; var acos = Math.acos; var atan = Math.atan;
            var sqrt = Math.sqrt; var pow = Math.pow;
            var log = Math.log; var exp = Math.exp; var abs = Math.abs;
            var PI = Math.PI;
        """)
        return ctx
    }()
    
    func calculate(rule: String, variables: [String: Double]) throws -> Double {
        for (key, value) in variables {
            jsContext.setObject(value, forKeyedSubscript: key as NSString)
        }
        
        guard let result = jsContext.evaluateScript(rule) else {
            throw CalculationError.evaluationFailed(rule)
        }
        
        if let exception = jsContext.exception {
            jsContext.exception = nil
            throw CalculationError.evaluationFailed(exception.toString() ?? rule)
        }
        
        let doubleResult = result.toDouble()
        
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
