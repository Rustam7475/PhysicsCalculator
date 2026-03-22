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
        default: return name_en
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
        default: return name_en
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
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
        self.variables = variables
        self.calculation_rules = calculation_rules
    }

    public func localizedName(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return name_ru
        case "en": return name_en
        default: return name_en
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
    }

    public func localizedDescription(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return description_ru
        case "en": return description_en
        default: return description_en
        }
    }

    public var localizedDescription: String {
        localizedDescription(for: AppSettings.shared.currentLanguageCode)
    }

    public func getRearrangedFormula(for unknownSymbol: String) -> String {
        guard let rule = calculation_rules[unknownSymbol] else {
            return equation_latex
        }
        return "\(unknownSymbol) = \(Self.formatRuleAsLatex(rule))"
    }
    
    /// Формула с подставленными числовыми значениями
    public func getFormulaWithValues(calculatedSymbol: String, inputValues: [String: String]) -> String {
        guard let rule = calculation_rules[calculatedSymbol] else {
            return "\(calculatedSymbol) = ?"
        }
        var rightSide = rule
        for variable in variables where variable.symbol != calculatedSymbol {
            if let value = inputValues[variable.symbol] {
                rightSide = rightSide.replacingOccurrences(of: variable.symbol, with: value)
            }
        }
        return "\(calculatedSymbol) = \(Self.formatRuleAsLatex(rightSide))"
    }
    
    /// Форматирует арифметическое выражение в LaTeX
    private static func formatRuleAsLatex(_ rule: String) -> String {
        rule.replacingOccurrences(of: "*", with: " \\cdot ")
            .replacingOccurrences(of: "/", with: " \\div ")
    }
}

// MARK: - Variable

public struct Variable: Codable, Identifiable, Hashable {
    public var id: String { symbol }
    public let symbol: String
    public let name_ru: String
    public let name_en: String
    public let unit_si: String
    
    public init(symbol: String, name_ru: String, name_en: String, unit_si: String) {
        self.symbol = symbol
        self.name_ru = name_ru
        self.name_en = name_en
        self.unit_si = unit_si
    }

    public func localizedName(for languageCode: String) -> String {
        switch languageCode {
        case "ru": return name_ru
        case "en": return name_en
        default: return name_en
        }
    }

    public var localizedName: String {
        localizedName(for: AppSettings.shared.currentLanguageCode)
    }
}

// MARK: - Загрузка данных

/// Загрузка данных из JSON (с кешированием, для превью и обратной совместимости)
private var _cachedPhysicsData: PhysicsData?
private var _physicsDataLoaded = false

func loadPhysicsData() -> PhysicsData? {
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
