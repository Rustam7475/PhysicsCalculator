import Foundation

/// Конвертер единиц измерения для физических величин
struct UnitConverter {
    
    struct UnitOption: Identifiable, Hashable {
        let id: String
        let symbol: String
        let toSI: (Double) -> Double
        let fromSI: (Double) -> Double
        
        var name: String { L10n.unitName(id) }
        
        static func == (lhs: UnitOption, rhs: UnitOption) -> Bool { lhs.id == rhs.id }
        func hash(into hasher: inout Hasher) { hasher.combine(id) }
    }
    
    /// Возвращает доступные единицы для данной СИ-единицы
    static func units(forSI siUnit: String) -> [UnitOption]? {
        return unitMap[siUnit]
    }
    
    private static let unitMap: [String: [UnitOption]] = [
        // Длина
        "м": [
            UnitOption(id: "m", symbol: "м", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "km", symbol: "км", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "cm", symbol: "см", toSI: { $0 / 100 }, fromSI: { $0 * 100 }),
            UnitOption(id: "mm", symbol: "мм", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
            UnitOption(id: "mi", symbol: "mi", toSI: { $0 * 1609.344 }, fromSI: { $0 / 1609.344 }),
            UnitOption(id: "ft", symbol: "ft", toSI: { $0 * 0.3048 }, fromSI: { $0 / 0.3048 }),
        ],
        // Время
        "с": [
            UnitOption(id: "s", symbol: "с", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "ms_time", symbol: "мс", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
            UnitOption(id: "min", symbol: "мин", toSI: { $0 * 60 }, fromSI: { $0 / 60 }),
            UnitOption(id: "h_time", symbol: "ч", toSI: { $0 * 3600 }, fromSI: { $0 / 3600 }),
        ],
        // Масса
        "кг": [
            UnitOption(id: "kg", symbol: "кг", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "g_mass", symbol: "г", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
            UnitOption(id: "mg", symbol: "мг", toSI: { $0 / 1_000_000 }, fromSI: { $0 * 1_000_000 }),
            UnitOption(id: "t", symbol: "т", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "lb", symbol: "lb", toSI: { $0 * 0.453592 }, fromSI: { $0 / 0.453592 }),
        ],
        // Скорость
        "м/с": [
            UnitOption(id: "ms_speed", symbol: "м/с", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kmh", symbol: "км/ч", toSI: { $0 / 3.6 }, fromSI: { $0 * 3.6 }),
            UnitOption(id: "mph", symbol: "mph", toSI: { $0 * 0.44704 }, fromSI: { $0 / 0.44704 }),
        ],
        // Сила
        "Н": [
            UnitOption(id: "N", symbol: "Н", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kN", symbol: "кН", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "dyn", symbol: "дин", toSI: { $0 * 1e-5 }, fromSI: { $0 * 1e5 }),
        ],
        // Давление
        "Па": [
            UnitOption(id: "Pa", symbol: "Па", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kPa", symbol: "кПа", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "atm", symbol: "атм", toSI: { $0 * 101325 }, fromSI: { $0 / 101325 }),
            UnitOption(id: "mmHg", symbol: "мм рт.ст.", toSI: { $0 * 133.322 }, fromSI: { $0 / 133.322 }),
            UnitOption(id: "bar", symbol: "бар", toSI: { $0 * 100000 }, fromSI: { $0 / 100000 }),
        ],
        // Энергия
        "Дж": [
            UnitOption(id: "J", symbol: "Дж", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kJ", symbol: "кДж", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "cal", symbol: "кал", toSI: { $0 * 4.184 }, fromSI: { $0 / 4.184 }),
            UnitOption(id: "kcal", symbol: "ккал", toSI: { $0 * 4184 }, fromSI: { $0 / 4184 }),
            UnitOption(id: "eV", symbol: "эВ", toSI: { $0 * 1.602176634e-19 }, fromSI: { $0 / 1.602176634e-19 }),
        ],
        // Мощность
        "Вт": [
            UnitOption(id: "W", symbol: "Вт", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kW", symbol: "кВт", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "hp", symbol: "л.с.", toSI: { $0 * 745.7 }, fromSI: { $0 / 745.7 }),
        ],
        // Температура
        "К": [
            UnitOption(id: "K", symbol: "К", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "C_temp", symbol: "°C", toSI: { $0 + 273.15 }, fromSI: { $0 - 273.15 }),
            UnitOption(id: "F_temp", symbol: "°F", toSI: { ($0 - 32) * 5/9 + 273.15 }, fromSI: { ($0 - 273.15) * 9/5 + 32 }),
        ],
        // Частота
        "Гц": [
            UnitOption(id: "Hz", symbol: "Гц", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kHz", symbol: "кГц", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "MHz", symbol: "МГц", toSI: { $0 * 1_000_000 }, fromSI: { $0 / 1_000_000 }),
        ],
        // Ток
        "А": [
            UnitOption(id: "A", symbol: "А", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "mA", symbol: "мА", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
            UnitOption(id: "uA", symbol: "мкА", toSI: { $0 / 1_000_000 }, fromSI: { $0 * 1_000_000 }),
        ],
        // Напряжение
        "В": [
            UnitOption(id: "V", symbol: "В", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kV", symbol: "кВ", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "mV", symbol: "мВ", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
        ],
        // Сопротивление
        "Ом": [
            UnitOption(id: "Ohm", symbol: "Ом", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "kOhm", symbol: "кОм", toSI: { $0 * 1000 }, fromSI: { $0 / 1000 }),
            UnitOption(id: "MOhm", symbol: "МОм", toSI: { $0 * 1_000_000 }, fromSI: { $0 / 1_000_000 }),
        ],
        // Заряд
        "Кл": [
            UnitOption(id: "C_charge", symbol: "Кл", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "mC", symbol: "мКл", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
            UnitOption(id: "uC", symbol: "мкКл", toSI: { $0 / 1_000_000 }, fromSI: { $0 * 1_000_000 }),
        ],
        // Площадь
        "м²": [
            UnitOption(id: "m2", symbol: "м²", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "cm2", symbol: "см²", toSI: { $0 / 10000 }, fromSI: { $0 * 10000 }),
            UnitOption(id: "km2", symbol: "км²", toSI: { $0 * 1_000_000 }, fromSI: { $0 / 1_000_000 }),
        ],
        // Объём
        "м³": [
            UnitOption(id: "m3", symbol: "м³", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "L", symbol: "л", toSI: { $0 / 1000 }, fromSI: { $0 * 1000 }),
            UnitOption(id: "cm3", symbol: "см³", toSI: { $0 / 1_000_000 }, fromSI: { $0 * 1_000_000 }),
        ],
        // Ускорение
        "м/с²": [
            UnitOption(id: "ms2", symbol: "м/с²", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "g_acc", symbol: "g", toSI: { $0 * 9.80665 }, fromSI: { $0 / 9.80665 }),
        ],
        // Угол
        "рад": [
            UnitOption(id: "rad", symbol: "рад", toSI: { $0 }, fromSI: { $0 }),
            UnitOption(id: "deg", symbol: "°", toSI: { $0 * .pi / 180 }, fromSI: { $0 * 180 / .pi }),
        ],
    ]
}
