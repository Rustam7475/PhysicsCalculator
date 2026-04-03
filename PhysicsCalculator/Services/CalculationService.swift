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
            var log = Math.log; var log10 = Math.log10; var exp = Math.exp; var abs = Math.abs;
            var PI = Math.PI;
        """)
        return ctx
    }()
    
    /// Зарезервированные слова JavaScript, которые нельзя использовать как имена переменных
    private static let jsReservedWords: Set<String> = [
        "do", "in", "if", "for", "new", "try", "var", "let", "case", "else",
        "this", "void", "with", "enum", "while", "break", "catch", "throw",
        "const", "class", "super", "return", "typeof", "delete", "switch",
        "export", "import", "default", "finally", "extends", "function", "continue"
    ]
    
    func calculate(rule: String, variables: [String: Double]) throws -> Double {
        var cleanedRule = rule.replacingOccurrences(of: "function.", with: "")
        
        // Заменяем переменные, чьи имена совпадают с зарезервированными словами JS
        var safeVariables: [String: Double] = [:]
        for (key, value) in variables {
            if Self.jsReservedWords.contains(key) {
                let safeKey = "_\(key)"
                // Заменяем в правиле целые слова
                cleanedRule = cleanedRule.replacingOccurrences(
                    of: "\\b\(key)\\b",
                    with: safeKey,
                    options: .regularExpression
                )
                safeVariables[safeKey] = value
            } else {
                safeVariables[key] = value
            }
        }
        
        for (key, value) in safeVariables {
            jsContext.setObject(value, forKeyedSubscript: key as NSString)
        }
        
        defer {
            // Очищаем переменные, чтобы не загрязнять контекст для следующих вычислений
            for key in safeVariables.keys {
                jsContext.setObject(nil, forKeyedSubscript: key as NSString)
            }
        }
        
        guard let result = jsContext.evaluateScript(cleanedRule) else {
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
    
    /// Форматирует результат для отображения (6 знач. цифр, красивая науч. нотация, локаль)
    func formatResult(_ result: Double) -> String {
        Self.formatNumber(result)
    }
    
    /// Единый форматтер чисел для всего приложения
    /// - 6 значащих цифр
    /// - Научная нотация: `1.23 × 10⁵` вместо `1.23e+05`
    /// - Десятичный разделитель по текущей локали
    static func formatNumber(_ value: Double) -> String {
        let raw = String(format: "%.6g", value)
        // Конвертируем научную нотацию e+/-N в × 10ˣ
        let result: String
        if let eRange = raw.range(of: "e", options: .caseInsensitive) {
            let mantissa = String(raw[raw.startIndex..<eRange.lowerBound])
            let expPart = String(raw[raw.index(after: eRange.lowerBound)..<raw.endIndex])
            let exponent = Int(expPart) ?? 0
            let superscript = Self.toSuperscript(exponent)
            result = "\(mantissa) × 10\(superscript)"
        } else {
            result = raw
        }
        // Десятичный разделитель по локали
        let lang = AppSettings.shared.currentLanguageCode
        let useComma = ["ru", "de", "es", "fr"].contains(lang)
        return useComma ? result.replacingOccurrences(of: ".", with: ",") : result
    }
    
    /// Конвертирует целое число в Unicode-суперскрипт: -23 → ⁻²³
    private static func toSuperscript(_ n: Int) -> String {
        let superMap: [Character: Character] = [
            "0": "\u{2070}", "1": "\u{00B9}", "2": "\u{00B2}", "3": "\u{00B3}",
            "4": "\u{2074}", "5": "\u{2075}", "6": "\u{2076}", "7": "\u{2077}",
            "8": "\u{2078}", "9": "\u{2079}", "-": "\u{207B}"
        ]
        return String(n).compactMap { superMap[$0] }.map(String.init).joined()
    }
    
    /// Фильтрует единицу "—" для безразмерных величин (возвращает "")
    static func displayUnit(_ unit: String) -> String {
        unit == "—" ? "" : unit
    }
    
    /// Форматирует входное значение: если число — через formatNumber, иначе как есть
    static func formatInputValue(_ value: String) -> String {
        let cleaned = value.replacingOccurrences(of: ",", with: ".")
        if let num = Double(cleaned) {
            return formatNumber(num)
        }
        return value
    }
}
