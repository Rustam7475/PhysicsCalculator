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
        // Базовые замены
        result = result
            .replacingOccurrences(of: "*", with: " \\cdot ")
            .replacingOccurrences(of: "/", with: " \\div ")
        return result
    }
    
    /// Конвертирует func(...) в \func{...} (для sqrt) или \func(...) (для триг.)
    private static func convertFunctionToLatex(_ input: String, function: String, latex: String) -> String {
        var result = input
        while let range = result.range(of: "\(function)(") {
            guard let closing = findMatchingParen(in: result, from: range.upperBound) else { break }
            let content = String(result[range.upperBound..<closing])
            let isSqrt = function == "sqrt"
            let replacement = isSqrt ? "\(latex){\(content)}" : "\(latex)(\(content))"
            result = result.replacingCharacters(in: range.lowerBound..<result.index(after: closing), with: replacement)
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
