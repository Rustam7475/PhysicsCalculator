import Foundation

// --- Доступ к настройкам через синглтон AppSettings.shared ---
// (Убедитесь, что AppSettings определен ДО этого файла или импортирован)
// Если вы создали @StateObject в App, используйте другой механизм доступа (например, передачу)

// Структура для хранения всех данных
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

// Раздел физики
public struct PhysicsSection: Codable, Identifiable, Hashable {
    public let id: String
    public let name_ru: String
    public let name_en: String
    // Добавьте name_de, name_es и т.д., если они есть в JSON
    // let name_de: String? // Опционально, если не для всех есть перевод
    public let levels: [String]
    
    public init(id: String, name_ru: String, name_en: String, levels: [String]) {
        self.id = id
        self.name_ru = name_ru
        self.name_en = name_en
        self.levels = levels
    }

    // Используем AppSettings.shared для выбора языка
    public var localizedName: String {
        let langCode = AppSettings.shared.currentLanguageCode
        switch langCode {
        case "ru": return name_ru
        case "en": return name_en
        // Добавьте другие языки
        // case "de": return name_de ?? name_en // Фоллбэк на английский, если нет перевода
        default: return name_en // Язык по умолчанию, если выбранный не найден
        }
    }
}

// Подраздел физики
public struct PhysicsSubsection: Codable, Identifiable, Hashable {
    public let id: String
    public let sectionId: String // К какому разделу относится
    public let name_ru: String
    public let name_en: String
    // Добавьте name_de, name_es и т.д.
    public let levels: [String]
    
    public init(id: String, sectionId: String, name_ru: String, name_en: String, levels: [String]) {
        self.id = id
        self.sectionId = sectionId
        self.name_ru = name_ru
        self.name_en = name_en
        self.levels = levels
    }

    public var localizedName: String {
        let langCode = AppSettings.shared.currentLanguageCode
        switch langCode {
        case "ru": return name_ru
        case "en": return name_en
        // ... другие языки ...
        default: return name_en
        }
    }
}

// Формула
public struct Formula: Codable, Identifiable, Hashable {
    public let id: String
    public let subsectionId: String // К какому подразделу относится
    public let name_ru: String
    public let name_en: String
    public let levels: [String]
    public let equation_latex: String
    public let description_ru: String
    public let description_en: String
    // Добавьте description_de, name_de и т.д.
    public let variables: [Variable]
    public let calculation_rules: [String: String] // Словарь [СимволНеизвестной : ПравилоРасчета]
    
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

    public var localizedName: String {
        let langCode = AppSettings.shared.currentLanguageCode
        switch langCode {
        case "ru": return name_ru
        case "en": return name_en
        // ... другие языки ...
        default: return name_en
        }
    }
    public var localizedDescription: String {
         let langCode = AppSettings.shared.currentLanguageCode
        switch langCode {
        case "ru": return description_ru
        case "en": return description_en
         // ... другие языки ...
        default: return description_en
        }
    }
}

// Переменная в формуле
public struct Variable: Codable, Identifiable, Hashable {
    // Сделаем symbol идентификатором, т.к. он уникален в рамках формулы
    public var id: String { symbol }
    public let symbol: String
    public let name_ru: String
    public let name_en: String
    // Добавьте name_de и т.д.
    public let unit_si: String
    
    public init(symbol: String, name_ru: String, name_en: String, unit_si: String) {
        self.symbol = symbol
        self.name_ru = name_ru
        self.name_en = name_en
        self.unit_si = unit_si
    }

    public var localizedName: String {
        let langCode = AppSettings.shared.currentLanguageCode
        switch langCode {
        case "ru": return name_ru
        case "en": return name_en
        // ... другие языки ...
        default: return name_en
        }
    }
}

// Функция-загрузчик JSON (без изменений)
func loadPhysicsData() -> PhysicsData? {
    guard let url = Bundle.main.url(forResource: "formulas_data", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        print("Error: Could not find or load formulas_data.json")
        return nil
    }
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(PhysicsData.self, from: data)
        return jsonData
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
