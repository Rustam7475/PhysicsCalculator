import Foundation

// MARK: - PhysicsData

public struct PhysicsData: Codable {
    public let sections: [PhysicsSection]
    public let subsections: [PhysicsSubsection]
    public let formulas: [Formula]
    
    public init(sections: [PhysicsSection], subsections: [PhysicsSubsection], formulas: [Formula]) {
        self.sections = sections
        self.subsections = subsections
        self.formulas = formulas
    }
}

// MARK: - PhysicsSection

public struct PhysicsSection: Codable, Identifiable, Hashable {
    public let id: String
    public let name_ru: String
    public let name_en: String
    public let levels: [String]
    
    public init(id: String, name_ru: String, name_en: String, levels: [String]) {
        self.id = id
        self.name_ru = name_ru
        self.name_en = name_en
        self.levels = levels
    }

    /// Локализованное имя для заданного кода языка (для тестирования)
    public func localizedName(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return name_ru
        case "en": return name_en
        default: return L10n.physicsName(name_en)
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
    }
}

// MARK: - PhysicsSubsection

public struct PhysicsSubsection: Codable, Identifiable, Hashable {
    public let id: String
    public let sectionId: String
    public let name_ru: String
    public let name_en: String
    public let levels: [String]
    
    public init(id: String, sectionId: String, name_ru: String, name_en: String, levels: [String]) {
        self.id = id
        self.sectionId = sectionId
        self.name_ru = name_ru
        self.name_en = name_en
        self.levels = levels
    }

    public func localizedName(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return name_ru
        case "en": return name_en
        default: return L10n.physicsName(name_en)
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
    }
}

// MARK: - Example Problem

public struct ExampleProblem: Codable, Hashable {
    public let problem_ru: String
    public let problem_en: String
    public let problem_de: String?
    public let problem_es: String?
    public let problem_fr: String?
    public let problem_zh: String?
    public let answer_ru: String
    public let answer_en: String
    public let answer_de: String?
    public let answer_es: String?
    public let answer_fr: String?
    public let answer_zh: String?

    public var localizedProblem: String {
        let code = AppSettings.shared.currentLanguageCode
        switch code {
        case "ru": return problem_ru
        case "en": return problem_en
        case "de": return problem_de ?? problem_en
        case "es": return problem_es ?? problem_en
        case "fr": return problem_fr ?? problem_en
        case "zh": return problem_zh ?? problem_en
        default: return problem_en
        }
    }

    public var localizedAnswer: String {
        let code = AppSettings.shared.currentLanguageCode
        switch code {
        case "ru": return answer_ru
        case "en": return answer_en
        case "de": return answer_de ?? answer_en
        case "es": return answer_es ?? answer_en
        case "fr": return answer_fr ?? answer_en
        case "zh": return answer_zh ?? answer_en
        default: return answer_en
        }
    }
}

// MARK: - Formula

public struct Formula: Codable, Identifiable, Hashable {
    public let id: String
    public let subsectionId: String
    public let name_ru: String
    public let name_en: String
    public let levels: [String]
    public let equation_latex: String
    public let description_ru: String
    public let description_en: String
    public let description_de: String?
    public let description_es: String?
    public let description_fr: String?
    public let description_zh: String?
    public let theory_ru: String?
    public let theory_en: String?
    public let theory_de: String?
    public let theory_es: String?
    public let theory_fr: String?
    public let theory_zh: String?
    public let examples: [ExampleProblem]?
    public let variables: [Variable]
    public let calculation_rules: [String: String]
    
    public init(
        id: String,
        subsectionId: String,
        name_ru: String,
        name_en: String,
        levels: [String],
        equation_latex: String,
        description_ru: String,
        description_en: String,
        description_de: String? = nil,
        description_es: String? = nil,
        description_fr: String? = nil,
        description_zh: String? = nil,
        theory_ru: String? = nil,
        theory_en: String? = nil,
        theory_de: String? = nil,
        theory_es: String? = nil,
        theory_fr: String? = nil,
        theory_zh: String? = nil,
        examples: [ExampleProblem]? = nil,
        variables: [Variable],
        calculation_rules: [String: String]
    ) {
        self.id = id
        self.subsectionId = subsectionId
        self.name_ru = name_ru
        self.name_en = name_en
        self.levels = levels
        self.equation_latex = equation_latex
        self.description_ru = description_ru
        self.description_en = description_en
        self.description_de = description_de
        self.description_es = description_es
        self.description_fr = description_fr
        self.description_zh = description_zh
        self.theory_ru = theory_ru
        self.theory_en = theory_en
        self.theory_de = theory_de
        self.theory_es = theory_es
        self.theory_fr = theory_fr
        self.theory_zh = theory_zh
        self.examples = examples
        self.variables = variables
        self.calculation_rules = calculation_rules
    }

    public func localizedName(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return name_ru
        case "en": return name_en
        default: return L10n.physicsName(name_en)
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
    }

    public func localizedDescription(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return description_ru
        case "en": return description_en
        case "de": return description_de ?? description_en
        case "es": return description_es ?? description_en
        case "fr": return description_fr ?? description_en
        case "zh": return description_zh ?? description_en
        default: return description_en
        }
    }

    public var localizedDescription: String {
        localizedDescription(for: AppSettings.shared.currentLanguageCode)
    }

    public var localizedTheory: String? {
        let code = AppSettings.shared.currentLanguageCode
        switch code {
        case "ru": return theory_ru
        case "en": return theory_en
        case "de": return theory_de ?? theory_en
        case "es": return theory_es ?? theory_en
        case "fr": return theory_fr ?? theory_en
        case "zh": return theory_zh ?? theory_en
        default: return theory_en ?? theory_ru
        }
    }

    public func getRearrangedFormula(for unknownSymbol: String) -> String {
        guard let rule = calculation_rules[unknownSymbol] else {
            return equation_latex
        }
        let latexSymbol = Self.symbolToLatex(unknownSymbol)
        return "\(latexSymbol) = \(Self.formatRuleAsLatex(Self.replaceSymbolsWithLatex(rule, variables: variables)))"
    }
    
    /// Формула с подставленными числовыми значениями
    public func getFormulaWithValues(calculatedSymbol: String, inputValues: [String: String]) -> String {
        guard let rule = calculation_rules[calculatedSymbol] else {
            let latexSymbol = Self.symbolToLatex(calculatedSymbol)
            return "\(latexSymbol) = ?"
        }
        var rightSide = rule
        // Сортируем по длине символа (сначала длинные), чтобы избежать частичных замен
        let sortedVars = variables.filter { $0.symbol != calculatedSymbol }.sorted { $0.symbol.count > $1.symbol.count }
        for variable in sortedVars {
            if let value = inputValues[variable.symbol] {
                rightSide = rightSide.replacingOccurrences(of: variable.symbol, with: value)
            }
        }
        let latexSymbol = Self.symbolToLatex(calculatedSymbol)
        return "\(latexSymbol) = \(Self.formatRuleAsLatex(rightSide))"
    }
    
    /// Маппинг символов переменных в LaTeX
    private static let latexSymbolMap: [String: String] = [
        "nu": "\\nu", "alpha": "\\alpha", "beta": "\\beta", "gamma": "\\gamma",
        "delta": "\\delta", "epsilon": "\\varepsilon", "theta": "\\theta",
        "lambda": "\\lambda", "mu": "\\mu", "rho": "\\rho", "sigma": "\\sigma",
        "tau": "\\tau", "phi": "\\phi", "omega": "\\omega",
        "eta": "\\eta", "Phi": "\\Phi",
        "DeltaS": "\\Delta S", "DeltaU": "\\Delta U", "DeltaT": "\\Delta T",
        "dPhiB": "d\\Phi_B", "dPhi": "\\Delta\\Phi", "dphi": "\\Delta\\varphi",
        "alpha1": "\\alpha_1", "alpha2": "\\alpha_2",
        "v1prime": "v'_1", "v2prime": "v'_2",
        "n_ord": "n", "Avyh": "A_{вых}", "Eup": "E_{уп}", "Ep": "E_p",
        "ρ": "\\rho", "ρ_1": "\\rho_1", "ρ_2": "\\rho_2"
    ]
    
    private static func symbolToLatex(_ symbol: String) -> String {
        latexSymbolMap[symbol] ?? symbol
    }
    
    /// Заменяет все символы переменных в выражении на LaTeX-эквиваленты
    private static func replaceSymbolsWithLatex(_ expression: String, variables: [Variable]) -> String {
        var result = expression
        let sorted = variables.sorted { $0.symbol.count > $1.symbol.count }
        for variable in sorted {
            if let latex = latexSymbolMap[variable.symbol] {
                result = result.replacingOccurrences(of: variable.symbol, with: latex)
            }
        }
        return result
    }
    
    /// Форматирует арифметическое выражение в LaTeX
    private static func formatRuleAsLatex(_ rule: String) -> String {
        var result = rule
        // Убираем префикс function.
        result = result.replacingOccurrences(of: "function.", with: "")
        // Конвертируем sqrt(...) в \sqrt{...}
        result = convertFunctionToLatex(result, function: "sqrt", latex: "\\sqrt")
        // Конвертируем тригонометрические функции
        for fn in ["sin", "cos", "tan", "asin", "acos", "atan"] {
            result = convertFunctionToLatex(result, function: fn, latex: "\\\(fn)")
        }
        // Конвертируем pow(base, exp) в {base}^{exp}
        result = convertPowToLatex(result)
        // Конвертируем деление в \frac{}{} — ДО замены * на \cdot
        result = convertDivisionsToFrac(result)
        // Базовые замены
        result = result
            .replacingOccurrences(of: "*", with: " \\cdot ")
        // Конвертируем научную нотацию (6.62607e-34) в LaTeX (6{,}62607 \times 10^{-34})
        result = convertScientificNotationToLatex(result)
        return result
    }
    
    /// Конвертирует числа в научной нотации (напр. `6.62607e-34`) в LaTeX: `6{,}62607 \\times 10^{-34}`
    private static func convertScientificNotationToLatex(_ text: String) -> String {
        // Паттерн: число (целое или десятичное) + e/E + опциональный знак + целое число
        guard let regex = try? NSRegularExpression(pattern: #"(\d+\.?\d*)[eE]([+-]?\d+)"#) else { return text }
        let nsText = text as NSString
        var result = text
        // Обрабатываем с конца, чтобы индексы не сбивались при замене
        let matches = regex.matches(in: text, range: NSRange(location: 0, length: nsText.length))
        for match in matches.reversed() {
            let mantissa = nsText.substring(with: match.range(at: 1))
            let exponent = nsText.substring(with: match.range(at: 2))
            let fullRange = Range(match.range, in: result)!
            let latex = "\(mantissa) \\times 10^{\(exponent)}"
            result.replaceSubrange(fullRange, with: latex)
        }
        return result
    }
    
    /// Конвертирует операции деления `/` в `\frac{числитель}{знаменатель}`
    /// Работает с приоритетом операторов: `a * b / c` → `\frac{a * b}{c}`, `a + b / c` → `a + \frac{b}{c}`
    private static func convertDivisionsToFrac(_ expression: String) -> String {
        let trimmed = expression.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return trimmed }
        
        // Разбиваем на сегменты верхнего уровня по + и - (не внутри скобок/фигурных скобок)
        // Каждый сегмент — это мультипликативное выражение (с * и /)
        var segments: [(op: String, content: String)] = [] // op: "" для первого, "+" или "-" для остальных
        var current = ""
        var depth = 0
        var braceDepth = 0
        var i = trimmed.startIndex
        var firstSegment = true
        
        while i < trimmed.endIndex {
            let ch = trimmed[i]
            if ch == "(" { depth += 1 }
            else if ch == ")" { depth -= 1 }
            else if ch == "{" { braceDepth += 1 }
            else if ch == "}" { braceDepth -= 1 }
            
            // Разделяем по + и - на верхнем уровне (не внутри скобок)
            // Не разделяем по - в начале (унарный минус) и по - после (
            if depth == 0 && braceDepth == 0 && (ch == "+" || ch == "-") {
                // Проверяем что это бинарный оператор, а не унарный минус или часть числа (напр. 1e-5)
                let prevNonSpace = trimmed[trimmed.startIndex..<i].last(where: { !$0.isWhitespace })
                let isBinary = prevNonSpace != nil && (prevNonSpace!.isLetter || prevNonSpace!.isNumber || prevNonSpace! == ")" || prevNonSpace! == "}")
                // Исключаем научную нотацию: 6.626e-34 — минус после e/E не является оператором
                let isScientific = prevNonSpace != nil && (prevNonSpace! == "e" || prevNonSpace! == "E") && {
                    // Проверяем что перед 'e' стоит цифра (значит это число вида 1.23e-5)
                    let beforeE = trimmed[trimmed.startIndex..<i].dropLast(1).last(where: { !$0.isWhitespace })
                    return beforeE != nil && beforeE!.isNumber
                }()
                if isBinary && !isScientific {
                    segments.append((op: firstSegment ? "" : "", content: current.trimmingCharacters(in: .whitespaces)))
                    current = ""
                    segments.append((op: String(ch), content: ""))
                    firstSegment = false
                    i = trimmed.index(after: i)
                    continue
                }
            }
            current.append(ch)
            i = trimmed.index(after: i)
        }
        if !current.trimmingCharacters(in: .whitespaces).isEmpty {
            segments.append((op: "", content: current.trimmingCharacters(in: .whitespaces)))
        }
        
        // Теперь обрабатываем каждый сегмент (содержащий только * и /) отдельно
        var result = ""
        for seg in segments {
            if seg.content.isEmpty {
                // Это оператор + или -
                result += " \(seg.op) "
            } else {
                result += convertMultiplicativeToFrac(seg.content)
            }
        }
        return result
    }
    
    /// Обрабатывает мультипликативное выражение (содержит * и /, но не + и - на верхнем уровне)
    /// Например: `a * b / c` → `\frac{a * b}{c}`, `(a + b) / (c * d)` → `\frac{(a + b)}{(c * d)}`
    private static func convertMultiplicativeToFrac(_ expr: String) -> String {
        let trimmed = expr.trimmingCharacters(in: .whitespaces)
        
        // Находим позицию первого `/` на верхнем уровне (не внутри скобок)
        var depth = 0
        var braceDepth = 0
        var divIndex: String.Index? = nil
        var i = trimmed.startIndex
        while i < trimmed.endIndex {
            let ch = trimmed[i]
            if ch == "(" { depth += 1 }
            else if ch == ")" { depth -= 1 }
            else if ch == "{" { braceDepth += 1 }
            else if ch == "}" { braceDepth -= 1 }
            else if ch == "/" && depth == 0 && braceDepth == 0 {
                divIndex = i
                break
            }
            i = trimmed.index(after: i)
        }
        
        guard let slashIdx = divIndex else {
            // Нет деления — рекурсивно обрабатываем содержимое скобок
            return processParenContents(trimmed)
        }
        
        // Разделяем на числитель и знаменатель
        let beforeSlash = String(trimmed[trimmed.startIndex..<slashIdx]).trimmingCharacters(in: .whitespaces)
        let afterSlash = String(trimmed[trimmed.index(after: slashIdx)..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
        
        // Числитель: всё до `/`
        let numerator = beforeSlash
        
        // Знаменатель: следующий токен после `/`
        // Токен — это либо `(...)` группа, либо одно слово/число
        let (denomToken, rest) = extractLeadingToken(afterSlash)
        
        // Рекурсивно обрабатываем числитель и знаменатель
        let numLatex = stripOuterParens(convertDivisionsToFrac(numerator))
        let denLatex = stripOuterParens(convertDivisionsToFrac(denomToken))
        
        var fracResult = "\\frac{\(numLatex)}{\(denLatex)}"
        
        // Если после знаменателя есть остаток (напр. `a / b * c` → `\frac{a}{b} * c`)
        let remaining = rest.trimmingCharacters(in: .whitespaces)
        if !remaining.isEmpty {
            // Проверяем что начинается с оператора
            if remaining.hasPrefix("*") {
                let afterOp = String(remaining.dropFirst()).trimmingCharacters(in: .whitespaces)
                fracResult += " * \(convertMultiplicativeToFrac(afterOp))"
            } else if remaining.hasPrefix("/") {
                // Повторное деление: \frac{...}{...} / x → рекурсия
                let afterOp = String(remaining.dropFirst()).trimmingCharacters(in: .whitespaces)
                let (nextDen, nextRest) = extractLeadingToken(afterOp)
                let nextDenLatex = stripOuterParens(convertDivisionsToFrac(nextDen))
                fracResult = "\\frac{\(fracResult)}{\(nextDenLatex)}"
                let nextRemaining = nextRest.trimmingCharacters(in: .whitespaces)
                if !nextRemaining.isEmpty {
                    fracResult += " \(convertMultiplicativeToFrac(nextRemaining))"
                }
            }
        }
        
        return fracResult
    }
    
    /// Извлекает первый токен из выражения: `(...)` группу или одно слово/число
    /// Возвращает (токен, остаток)
    private static func extractLeadingToken(_ expr: String) -> (String, String) {
        let trimmed = expr.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return ("", "") }
        
        // Если начинается со скобки — извлекаем всю группу
        if trimmed.hasPrefix("(") {
            let start = trimmed.index(after: trimmed.startIndex)
            if let closing = findMatchingParen(in: trimmed, from: start) {
                let token = String(trimmed[trimmed.startIndex...closing])
                let rest = String(trimmed[trimmed.index(after: closing)..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
                return (token, rest)
            }
        }
        
        // Если начинается с \frac, \sqrt или \func{...} — извлекаем целиком
        if trimmed.hasPrefix("\\") {
            var idx = trimmed.startIndex
            // Пропускаем команду (\frac, \sqrt, \sin и т.д.)
            idx = trimmed.index(after: idx) // skip backslash
            while idx < trimmed.endIndex && (trimmed[idx].isLetter) {
                idx = trimmed.index(after: idx)
            }
            // Собираем все {}-группы после команды
            while idx < trimmed.endIndex && trimmed[idx] == "{" {
                var bDepth = 1
                idx = trimmed.index(after: idx)
                while idx < trimmed.endIndex && bDepth > 0 {
                    if trimmed[idx] == "{" { bDepth += 1 }
                    else if trimmed[idx] == "}" { bDepth -= 1 }
                    idx = trimmed.index(after: idx)
                }
            }
            let token = String(trimmed[trimmed.startIndex..<idx])
            let rest = String(trimmed[idx..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
            return (token, rest)
        }
        
        // Обычный токен: буквы, цифры, _, точка (для чисел вроде 3.14)
        var idx = trimmed.startIndex
        while idx < trimmed.endIndex {
            let ch = trimmed[idx]
            if ch.isLetter || ch.isNumber || ch == "_" || ch == "." {
                idx = trimmed.index(after: idx)
            } else {
                break
            }
        }
        
        let token = String(trimmed[trimmed.startIndex..<idx])
        let rest = String(trimmed[idx..<trimmed.endIndex]).trimmingCharacters(in: .whitespaces)
        return (token.isEmpty ? (String(trimmed.first!), String(trimmed.dropFirst())) : (token, rest))
    }
    
    /// Убирает внешние скобки если всё выражение обёрнуто: `(a + b)` → `a + b`
    private static func stripOuterParens(_ expr: String) -> String {
        let trimmed = expr.trimmingCharacters(in: .whitespaces)
        guard trimmed.hasPrefix("(") && trimmed.hasSuffix(")") else { return trimmed }
        // Проверяем что скобки действительно охватывают всё выражение
        let inner = trimmed.index(after: trimmed.startIndex)
        if let closing = findMatchingParen(in: trimmed, from: inner),
           closing == trimmed.index(before: trimmed.endIndex) {
            return String(trimmed[inner..<closing])
        }
        return trimmed
    }
    
    /// Рекурсивно обрабатывает содержимое скобок в выражении
    private static func processParenContents(_ expr: String) -> String {
        var result = ""
        var i = expr.startIndex
        while i < expr.endIndex {
            if expr[i] == "(" {
                let start = expr.index(after: i)
                if let closing = findMatchingParen(in: expr, from: start) {
                    let inner = String(expr[start..<closing])
                    let processed = convertDivisionsToFrac(inner)
                    result += "(\(processed))"
                    i = expr.index(after: closing)
                    continue
                }
            }
            result.append(expr[i])
            i = expr.index(after: i)
        }
        return result
    }
    
    /// Конвертирует func(...) в \func{...} (для sqrt) или \func(...) (для триг.)
    private static func convertFunctionToLatex(_ input: String, function: String, latex: String) -> String {
        var result = input
        var searchStartOffset = 0
        while true {
            guard let searchStart = result.index(result.startIndex, offsetBy: searchStartOffset, limitedBy: result.endIndex),
                  searchStart < result.endIndex,
                  let range = result.range(of: "\(function)(", range: searchStart..<result.endIndex) else { break }
            // Пропускаем если перед функцией стоит \ или буква (уже сконвертировано или часть другой функции, напр. asin)
            if range.lowerBound > result.startIndex {
                let prev = result[result.index(before: range.lowerBound)]
                if prev == "\\" || prev.isLetter {
                    searchStartOffset = result.distance(from: result.startIndex, to: range.upperBound)
                    continue
                }
            }
            guard let closing = findMatchingParen(in: result, from: range.upperBound) else { break }
            let content = String(result[range.upperBound..<closing])
            let isSqrt = function == "sqrt"
            let replacement = isSqrt ? "\(latex){\(content)}" : "\(latex)(\(content))"
            let startOffset = result.distance(from: result.startIndex, to: range.lowerBound)
            result = result.replacingCharacters(in: range.lowerBound..<result.index(after: closing), with: replacement)
            searchStartOffset = startOffset + replacement.count
        }
        return result
    }
    
    /// Конвертирует pow(base, exp) в {base}^{exp}
    private static func convertPowToLatex(_ input: String) -> String {
        var result = input
        while let range = result.range(of: "pow(") {
            guard let closing = findMatchingParen(in: result, from: range.upperBound) else { break }
            let content = String(result[range.upperBound..<closing])
            let parts = content.split(separator: ",", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            if parts.count == 2 {
                let replacement = "{\(parts[0])}^{\(parts[1])}"
                result = result.replacingCharacters(in: range.lowerBound..<result.index(after: closing), with: replacement)
            } else {
                break
            }
        }
        return result
    }
    
    /// Находит закрывающую скобку, учитывая вложенность
    private static func findMatchingParen(in str: String, from start: String.Index) -> String.Index? {
        var depth = 1
        var idx = start
        while idx < str.endIndex {
            let ch = str[idx]
            if ch == "(" { depth += 1 }
            else if ch == ")" { depth -= 1; if depth == 0 { return idx } }
            idx = str.index(after: idx)
        }
        return nil
    }
}

// MARK: - Variable

public struct Variable: Codable, Identifiable, Hashable {
    public var id: String { symbol }
    public let symbol: String
    public let name_ru: String
    public let name_en: String
    public let unit_si: String

    public func localizedName(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return name_ru
        case "en": return name_en
        default: return L10n.physicsName(name_en)
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
    }

    // MARK: - Отображение символа (греческие/специальные)
    private static let greekMap: [String: String] = [
        "nu": "ν", "alpha": "α", "beta": "β", "gamma": "γ",
        "delta": "δ", "epsilon": "ε", "theta": "θ", "lambda": "λ",
        "mu": "μ", "rho": "ρ", "sigma": "σ", "tau": "τ",
        "phi": "φ", "omega": "ω", "eta": "η", "Phi": "Φ",
        "DeltaS": "ΔS", "DeltaU": "ΔU", "DeltaT": "ΔT",
        "dPhi": "ΔΦ", "dphi": "Δφ", "dPhiB": "dΦ_B", "dPhiE": "dΦ_E",
        "alpha1": "α₁", "alpha2": "α₂",
        "v1prime": "v'₁", "v2prime": "v'₂",
        "n_ord": "n", "Avyh": "A_вых", "Eup": "E_уп", "Ep": "E_p",
        "eps0": "ε₀", "mu0": "μ₀", "Z0": "Z₀", "Id": "I_d"
    ]

    public var displaySymbol: String {
        Self.greekMap[symbol] ?? symbol
    }

    public static func displaySymbol(for symbol: String) -> String {
        greekMap[symbol] ?? symbol
    }
}

// MARK: - Загрузка данных

/// Загрузка данных из JSON (с потокобезопасным кешированием)
private let _physicsDataLock = NSLock()
private var _cachedPhysicsData: PhysicsData?
private var _physicsDataLoaded = false

func loadPhysicsData() -> PhysicsData? {
    _physicsDataLock.lock()
    defer { _physicsDataLock.unlock() }
    
    if _physicsDataLoaded { return _cachedPhysicsData }
    guard let url = Bundle.main.url(forResource: "formulas_data", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        _physicsDataLoaded = true
        return nil
    }
    _cachedPhysicsData = try? JSONDecoder().decode(PhysicsData.self, from: data)
    _physicsDataLoaded = true
    return _cachedPhysicsData
}
