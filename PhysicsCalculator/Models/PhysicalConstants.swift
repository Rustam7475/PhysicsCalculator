import Foundation

/// Справочник физических констант.
/// Используется для автоматической подстановки значений в формулы.
struct PhysicalConstants {
    
    /// Одна физическая константа
    struct Constant {
        let symbol: String
        let value: Double
        let unit: String
        let name_ru: String
        let name_en: String
    }
    
    /// Все известные константы
    static let all: [Constant] = [
        Constant(symbol: "g",   value: 9.81,          unit: "м/с²",        name_ru: "Ускорение свободного падения", name_en: "Gravitational acceleration"),
        Constant(symbol: "R",   value: 8.314,          unit: "Дж/(моль·К)", name_ru: "Газовая постоянная",           name_en: "Gas Constant"),
        Constant(symbol: "c",   value: 299_792_458,    unit: "м/с",         name_ru: "Скорость света",              name_en: "Speed of light"),
        Constant(symbol: "k_B", value: 1.380649e-23,   unit: "Дж/К",        name_ru: "Постоянная Больцмана",        name_en: "Boltzmann constant"),
        Constant(symbol: "N_A", value: 6.02214076e23,  unit: "1/моль",      name_ru: "Число Авогадро",              name_en: "Avogadro's number"),
        Constant(symbol: "e",   value: 1.602176634e-19,unit: "Кл",          name_ru: "Элементарный заряд",          name_en: "Elementary charge"),
        Constant(symbol: "h",   value: 6.62607015e-34, unit: "Дж·с",        name_ru: "Постоянная Планка",           name_en: "Planck constant"),
        Constant(symbol: "ε0",  value: 8.8541878128e-12, unit: "Ф/м",      name_ru: "Электрическая постоянная",    name_en: "Vacuum permittivity"),
        Constant(symbol: "μ0",  value: 1.25663706212e-6, unit: "Гн/м",     name_ru: "Магнитная постоянная",         name_en: "Vacuum permeability"),
        Constant(symbol: "σ",   value: 5.670374419e-8, unit: "Вт/(м²·К⁴)", name_ru: "Постоянная Стефана-Больцмана", name_en: "Stefan-Boltzmann constant"),
        Constant(symbol: "G",   value: 6.674e-11,      unit: "Н·м²/кг²",    name_ru: "Гравитационная постоянная",   name_en: "Gravitational constant"),
        Constant(symbol: "k",   value: 8.9875517923e9,  unit: "Н·м²/Кл²",    name_ru: "Коэффициент Кулона",         name_en: "Coulomb constant"),
        Constant(symbol: "a0",  value: 5.29177e-11,    unit: "м",           name_ru: "Боровский радиус",            name_en: "Bohr radius"),
        Constant(symbol: "R∞",  value: 1.097373e7,     unit: "1/м",         name_ru: "Постоянная Ридберга",         name_en: "Rydberg constant"),
        Constant(symbol: "b_W", value: 2.8978e-3,      unit: "м·К",         name_ru: "Постоянная Вина",             name_en: "Wien constant"),
    ]
    
    /// Алиасы символов (например, "eps0" → "ε0", "mu0" → "μ0")
    private static let symbolAliases: [String: String] = [
        "eps0": "ε0",
        "mu0": "μ0",
        "Rinf": "R∞",
        "sigma": "σ",
        "bw": "b_W",
        "k_B": "k_B",
    ]
    
    /// Найти константу для переменной формулы.
    /// Матчинг по символу И единице измерения — чтобы не перепутать
    /// R (газовая постоянная) с R (сопротивление), g (ускорение) с g (другое).
    static func match(for variable: Variable) -> Constant? {
        let sym = symbolAliases[variable.symbol] ?? variable.symbol
        return all.first { $0.symbol == sym && $0.unit == variable.unit_si }
    }
    
    /// Форматирование значения константы для отображения в текстовом поле
    static func formattedValue(_ constant: Constant) -> String {
        if constant.value < 1e6 && constant.value > -1e6 && constant.value == Double(Int(constant.value)) {
            return String(format: "%.0f", constant.value)
        }
        if constant.value >= 0.001 && constant.value < 1e6 {
            let s = String(constant.value)
            return s
        }
        // Научная нотация — формат совместимый с полем ввода (точка, без локализации)
        return String(format: "%.6g", constant.value)
    }
}
