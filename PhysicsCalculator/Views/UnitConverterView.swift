import SwiftUI

struct UnitConverterView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var selectedCategory = 0
    @State private var inputValue = ""
    @State private var fromUnitIndex = 0
    @State private var toUnitIndex = 1
    @FocusState private var isInputFocused: Bool
    
    private let categories: [UnitCategory] = UnitCategory.all
    
    private var currentCategory: UnitCategory { categories[selectedCategory] }
    
    private var convertedValue: Double? {
        guard let input = Double(inputValue.replacingOccurrences(of: ",", with: ".")) else { return nil }
        if currentCategory.id == "temperature" {
            return convertTemperature(input, from: fromUnitIndex, to: toUnitIndex)
        }
        let fromUnit = currentCategory.units[fromUnitIndex]
        let toUnit = currentCategory.units[toUnitIndex]
        let siValue = input * fromUnit.toSI
        return siValue / toUnit.toSI
    }
    
    private func convertTemperature(_ value: Double, from: Int, to: Int) -> Double {
        // Convert to Kelvin first
        let kelvin: Double
        switch from {
        case 0: kelvin = value          // K
        case 1: kelvin = value + 273.15 // °C
        case 2: kelvin = (value - 32) * 5.0/9.0 + 273.15 // °F
        default: return value
        }
        // Convert from Kelvin to target
        switch to {
        case 0: return kelvin
        case 1: return kelvin - 273.15
        case 2: return (kelvin - 273.15) * 9.0/5.0 + 32
        default: return value
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                categoryPicker
                conversionPanel
                quickReferenceTable
            }
            .padding(.vertical)
        }
        .navigationTitle(L10n.converterTitle)
        .oledBackground()
        .onTapGesture { isInputFocused = false }
    }
    
    // MARK: - Category Picker
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categories.indices, id: \.self) { index in
                    Button {
                        selectedCategory = index
                        fromUnitIndex = 0
                        toUnitIndex = min(1, categories[index].units.count - 1)
                        inputValue = ""
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: categories[index].icon)
                                .font(.caption)
                            Text(categories[index].localizedName)
                                .font(.subheadline)
                        }
                        .padding(.horizontal, 14)
                        .frame(height: 38)
                        .background(selectedCategory == index ? Color.accentColor : Color(.secondarySystemBackground))
                        .foregroundColor(selectedCategory == index ? .white : .primary)
                        .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Conversion Panel
    
    private var conversionPanel: some View {
        VStack(spacing: 12) {
            inputSection
            swapButton
            resultSection
        }
        .padding(.horizontal)
    }
    
    private var inputSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.converterFrom)
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                TextField("0", text: $inputValue)
                    .keyboardType(.decimalPad)
                    .focused($isInputFocused)
                    .font(.title2.monospacedDigit())
                
                unitMenu(selectedIndex: $fromUnitIndex)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
    
    private var swapButton: some View {
        Button {
            let temp = fromUnitIndex
            fromUnitIndex = toUnitIndex
            toUnitIndex = temp
        } label: {
            Image(systemName: "arrow.up.arrow.down")
                .font(.title3)
                .frame(width: 44, height: 44)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(22)
        }
        .buttonStyle(.plain)
    }
    
    private var resultSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.converterTo)
                .font(.caption)
                .foregroundColor(.secondary)
            HStack {
                Text(formattedResult)
                    .font(.title2.monospacedDigit())
                    .foregroundColor(convertedValue != nil ? .primary : .secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                
                unitMenu(selectedIndex: $toUnitIndex)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }
    
    private func unitMenu(selectedIndex: Binding<Int>) -> some View {
        Menu {
            ForEach(currentCategory.units.indices, id: \.self) { i in
                let u = currentCategory.units[i]
                Button("\(u.localizedName) (\(u.symbol))") {
                    selectedIndex.wrappedValue = i
                }
            }
        } label: {
            HStack(spacing: 4) {
                Text(currentCategory.units[selectedIndex.wrappedValue].symbol)
                    .font(.headline)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.caption2)
            }
            .padding(.horizontal, 12)
            .frame(height: 40)
            .background(Color(.tertiarySystemFill))
            .cornerRadius(8)
        }
    }
    
    // MARK: - Quick Reference Table
    
    @ViewBuilder
    private var quickReferenceTable: some View {
        if !inputValue.isEmpty, let input = Double(inputValue.replacingOccurrences(of: ",", with: ".")) {
            VStack(alignment: .leading, spacing: 8) {
                Text(L10n.converterAllUnits)
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(currentCategory.units.indices, id: \.self) { i in
                    let unit = currentCategory.units[i]
                    let result = convertValue(input, fromIndex: fromUnitIndex, toIndex: i)
                    
                    HStack {
                        Text(unit.localizedName)
                            .font(.subheadline)
                        Spacer()
                        Text(formatNumber(result) + " " + unit.symbol)
                            .font(.subheadline.monospacedDigit())
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    if i < currentCategory.units.count - 1 {
                        Divider().padding(.horizontal)
                    }
                }
            }
            .padding(.vertical, 12)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
    
    private func convertValue(_ input: Double, fromIndex: Int, toIndex: Int) -> Double {
        if currentCategory.id == "temperature" {
            return convertTemperature(input, from: fromIndex, to: toIndex)
        }
        let fromUnit = currentCategory.units[fromIndex]
        let toUnit = currentCategory.units[toIndex]
        return (input * fromUnit.toSI) / toUnit.toSI
    }
    
    private var formattedResult: String {
        guard let value = convertedValue else { return "—" }
        return formatNumber(value)
    }
    
    private func formatNumber(_ value: Double) -> String {
        if value == 0 { return "0" }
        let absVal = abs(value)
        if absVal >= 1e6 || absVal < 0.001 {
            return String(format: "%g", value)
        }
        if value == Double(Int(value)) && absVal < 1e6 {
            return String(format: "%.0f", value)
        }
        // Remove trailing zeros
        let s = String(format: "%.6f", value)
        var result = s
        while result.hasSuffix("0") { result = String(result.dropLast()) }
        if result.hasSuffix(".") { result = String(result.dropLast()) }
        return result
    }
}

// MARK: - Data Model

struct ConvertibleUnit {
    let symbol: String
    let nameRu: String
    let nameEn: String
    let nameDe: String
    let nameEs: String
    let nameFr: String
    let nameZh: String
    let toSI: Double // multiplication factor to convert to SI base unit
    
    var localizedName: String {
        let lang = AppSettings.shared.currentLanguageCode
        switch lang {
        case "de": return nameDe
        case "es": return nameEs
        case "fr": return nameFr
        case "zh": return nameZh
        case "en": return nameEn
        default: return nameRu
        }
    }
}

struct UnitCategory: Identifiable {
    let id: String
    let icon: String
    let nameRu: String
    let nameEn: String
    let nameDe: String
    let nameEs: String
    let nameFr: String
    let nameZh: String
    let units: [ConvertibleUnit]
    
    var localizedName: String {
        let lang = AppSettings.shared.currentLanguageCode
        switch lang {
        case "de": return nameDe
        case "es": return nameEs
        case "fr": return nameFr
        case "zh": return nameZh
        case "en": return nameEn
        default: return nameRu
        }
    }
}

extension UnitCategory {
    static var all: [UnitCategory] {
        [length, mass, time, speed, force, energy, power, pressure, temperature, electricCurrent, frequency, area, volume]
    }
    
    static var length: UnitCategory {
        UnitCategory(id: "length", icon: "ruler", nameRu: "Длина", nameEn: "Length", nameDe: "Länge", nameEs: "Longitud", nameFr: "Longueur", nameZh: "长度", units: [
            ConvertibleUnit(symbol: "м", nameRu: "Метр", nameEn: "Meter", nameDe: "Meter", nameEs: "Metro", nameFr: "Mètre", nameZh: "米", toSI: 1),
            ConvertibleUnit(symbol: "км", nameRu: "Километр", nameEn: "Kilometer", nameDe: "Kilometer", nameEs: "Kilómetro", nameFr: "Kilomètre", nameZh: "千米", toSI: 1000),
            ConvertibleUnit(symbol: "см", nameRu: "Сантиметр", nameEn: "Centimeter", nameDe: "Zentimeter", nameEs: "Centímetro", nameFr: "Centimètre", nameZh: "厘米", toSI: 0.01),
            ConvertibleUnit(symbol: "мм", nameRu: "Миллиметр", nameEn: "Millimeter", nameDe: "Millimeter", nameEs: "Milímetro", nameFr: "Millimètre", nameZh: "毫米", toSI: 0.001),
            ConvertibleUnit(symbol: "мкм", nameRu: "Микрометр", nameEn: "Micrometer", nameDe: "Mikrometer", nameEs: "Micrómetro", nameFr: "Micromètre", nameZh: "微米", toSI: 1e-6),
            ConvertibleUnit(symbol: "нм", nameRu: "Нанометр", nameEn: "Nanometer", nameDe: "Nanometer", nameEs: "Nanómetro", nameFr: "Nanomètre", nameZh: "纳米", toSI: 1e-9),
            ConvertibleUnit(symbol: "mi", nameRu: "Миля", nameEn: "Mile", nameDe: "Meile", nameEs: "Milla", nameFr: "Mile", nameZh: "英里", toSI: 1609.344),
            ConvertibleUnit(symbol: "ft", nameRu: "Фут", nameEn: "Foot", nameDe: "Fuß", nameEs: "Pie", nameFr: "Pied", nameZh: "英尺", toSI: 0.3048),
            ConvertibleUnit(symbol: "in", nameRu: "Дюйм", nameEn: "Inch", nameDe: "Zoll", nameEs: "Pulgada", nameFr: "Pouce", nameZh: "英寸", toSI: 0.0254),
            ConvertibleUnit(symbol: "Å", nameRu: "Ангстрем", nameEn: "Angstrom", nameDe: "Ångström", nameEs: "Ångström", nameFr: "Ångström", nameZh: "埃", toSI: 1e-10),
        ])
    }
    
    static var mass: UnitCategory {
        UnitCategory(id: "mass", icon: "scalemass", nameRu: "Масса", nameEn: "Mass", nameDe: "Masse", nameEs: "Masa", nameFr: "Masse", nameZh: "质量", units: [
            ConvertibleUnit(symbol: "кг", nameRu: "Килограмм", nameEn: "Kilogram", nameDe: "Kilogramm", nameEs: "Kilogramo", nameFr: "Kilogramme", nameZh: "千克", toSI: 1),
            ConvertibleUnit(symbol: "г", nameRu: "Грамм", nameEn: "Gram", nameDe: "Gramm", nameEs: "Gramo", nameFr: "Gramme", nameZh: "克", toSI: 0.001),
            ConvertibleUnit(symbol: "мг", nameRu: "Миллиграмм", nameEn: "Milligram", nameDe: "Milligramm", nameEs: "Miligramo", nameFr: "Milligramme", nameZh: "毫克", toSI: 1e-6),
            ConvertibleUnit(symbol: "т", nameRu: "Тонна", nameEn: "Tonne", nameDe: "Tonne", nameEs: "Tonelada", nameFr: "Tonne", nameZh: "吨", toSI: 1000),
            ConvertibleUnit(symbol: "а.е.м.", nameRu: "Атомная единица массы", nameEn: "Atomic mass unit", nameDe: "Atomare Masseneinheit", nameEs: "Unidad de masa atómica", nameFr: "Unité de masse atomique", nameZh: "原子质量单位", toSI: 1.66054e-27),
            ConvertibleUnit(symbol: "lb", nameRu: "Фунт", nameEn: "Pound", nameDe: "Pfund", nameEs: "Libra", nameFr: "Livre", nameZh: "磅", toSI: 0.453592),
        ])
    }
    
    static var time: UnitCategory {
        UnitCategory(id: "time", icon: "clock", nameRu: "Время", nameEn: "Time", nameDe: "Zeit", nameEs: "Tiempo", nameFr: "Temps", nameZh: "时间", units: [
            ConvertibleUnit(symbol: "с", nameRu: "Секунда", nameEn: "Second", nameDe: "Sekunde", nameEs: "Segundo", nameFr: "Seconde", nameZh: "秒", toSI: 1),
            ConvertibleUnit(symbol: "мс", nameRu: "Миллисекунда", nameEn: "Millisecond", nameDe: "Millisekunde", nameEs: "Milisegundo", nameFr: "Milliseconde", nameZh: "毫秒", toSI: 0.001),
            ConvertibleUnit(symbol: "мкс", nameRu: "Микросекунда", nameEn: "Microsecond", nameDe: "Mikrosekunde", nameEs: "Microsegundo", nameFr: "Microseconde", nameZh: "微秒", toSI: 1e-6),
            ConvertibleUnit(symbol: "мин", nameRu: "Минута", nameEn: "Minute", nameDe: "Minute", nameEs: "Minuto", nameFr: "Minute", nameZh: "分钟", toSI: 60),
            ConvertibleUnit(symbol: "ч", nameRu: "Час", nameEn: "Hour", nameDe: "Stunde", nameEs: "Hora", nameFr: "Heure", nameZh: "小时", toSI: 3600),
            ConvertibleUnit(symbol: "сут", nameRu: "Сутки", nameEn: "Day", nameDe: "Tag", nameEs: "Día", nameFr: "Jour", nameZh: "天", toSI: 86400),
        ])
    }
    
    static var speed: UnitCategory {
        UnitCategory(id: "speed", icon: "speedometer", nameRu: "Скорость", nameEn: "Speed", nameDe: "Geschwindigkeit", nameEs: "Velocidad", nameFr: "Vitesse", nameZh: "速度", units: [
            ConvertibleUnit(symbol: "м/с", nameRu: "Метр в секунду", nameEn: "Meter/second", nameDe: "Meter/Sekunde", nameEs: "Metro/segundo", nameFr: "Mètre/seconde", nameZh: "米/秒", toSI: 1),
            ConvertibleUnit(symbol: "км/ч", nameRu: "Километр в час", nameEn: "Kilometer/hour", nameDe: "Kilometer/Stunde", nameEs: "Kilómetro/hora", nameFr: "Kilomètre/heure", nameZh: "千米/小时", toSI: 1.0/3.6),
            ConvertibleUnit(symbol: "mph", nameRu: "Миля в час", nameEn: "Mile/hour", nameDe: "Meile/Stunde", nameEs: "Milla/hora", nameFr: "Mile/heure", nameZh: "英里/小时", toSI: 0.44704),
            ConvertibleUnit(symbol: "c", nameRu: "Скорость света", nameEn: "Speed of light", nameDe: "Lichtgeschwindigkeit", nameEs: "Velocidad de la luz", nameFr: "Vitesse de la lumière", nameZh: "光速", toSI: 299792458),
        ])
    }
    
    static var force: UnitCategory {
        UnitCategory(id: "force", icon: "arrow.right", nameRu: "Сила", nameEn: "Force", nameDe: "Kraft", nameEs: "Fuerza", nameFr: "Force", nameZh: "力", units: [
            ConvertibleUnit(symbol: "Н", nameRu: "Ньютон", nameEn: "Newton", nameDe: "Newton", nameEs: "Newton", nameFr: "Newton", nameZh: "牛顿", toSI: 1),
            ConvertibleUnit(symbol: "кН", nameRu: "Килоньютон", nameEn: "Kilonewton", nameDe: "Kilonewton", nameEs: "Kilonewton", nameFr: "Kilonewton", nameZh: "千牛", toSI: 1000),
            ConvertibleUnit(symbol: "дин", nameRu: "Дина", nameEn: "Dyne", nameDe: "Dyn", nameEs: "Dina", nameFr: "Dyne", nameZh: "达因", toSI: 1e-5),
            ConvertibleUnit(symbol: "кгс", nameRu: "Килограмм-сила", nameEn: "Kilogram-force", nameDe: "Kilopond", nameEs: "Kilogramo-fuerza", nameFr: "Kilogramme-force", nameZh: "千克力", toSI: 9.80665),
        ])
    }
    
    static var energy: UnitCategory {
        UnitCategory(id: "energy", icon: "bolt.fill", nameRu: "Энергия", nameEn: "Energy", nameDe: "Energie", nameEs: "Energía", nameFr: "Énergie", nameZh: "能量", units: [
            ConvertibleUnit(symbol: "Дж", nameRu: "Джоуль", nameEn: "Joule", nameDe: "Joule", nameEs: "Julio", nameFr: "Joule", nameZh: "焦耳", toSI: 1),
            ConvertibleUnit(symbol: "кДж", nameRu: "Килоджоуль", nameEn: "Kilojoule", nameDe: "Kilojoule", nameEs: "Kilojulio", nameFr: "Kilojoule", nameZh: "千焦", toSI: 1000),
            ConvertibleUnit(symbol: "кал", nameRu: "Калория", nameEn: "Calorie", nameDe: "Kalorie", nameEs: "Caloría", nameFr: "Calorie", nameZh: "卡路里", toSI: 4.184),
            ConvertibleUnit(symbol: "ккал", nameRu: "Килокалория", nameEn: "Kilocalorie", nameDe: "Kilokalorie", nameEs: "Kilocaloría", nameFr: "Kilocalorie", nameZh: "千卡", toSI: 4184),
            ConvertibleUnit(symbol: "эВ", nameRu: "Электронвольт", nameEn: "Electronvolt", nameDe: "Elektronenvolt", nameEs: "Electronvoltio", nameFr: "Électronvolt", nameZh: "电子伏特", toSI: 1.602176634e-19),
            ConvertibleUnit(symbol: "МэВ", nameRu: "Мегаэлектронвольт", nameEn: "MeV", nameDe: "MeV", nameEs: "MeV", nameFr: "MeV", nameZh: "兆电子伏特", toSI: 1.602176634e-13),
            ConvertibleUnit(symbol: "кВт·ч", nameRu: "Киловатт-час", nameEn: "Kilowatt-hour", nameDe: "Kilowattstunde", nameEs: "Kilovatio-hora", nameFr: "Kilowatt-heure", nameZh: "千瓦时", toSI: 3.6e6),
            ConvertibleUnit(symbol: "эрг", nameRu: "Эрг", nameEn: "Erg", nameDe: "Erg", nameEs: "Ergio", nameFr: "Erg", nameZh: "尔格", toSI: 1e-7),
        ])
    }
    
    static var power: UnitCategory {
        UnitCategory(id: "power", icon: "flame", nameRu: "Мощность", nameEn: "Power", nameDe: "Leistung", nameEs: "Potencia", nameFr: "Puissance", nameZh: "功率", units: [
            ConvertibleUnit(symbol: "Вт", nameRu: "Ватт", nameEn: "Watt", nameDe: "Watt", nameEs: "Vatio", nameFr: "Watt", nameZh: "瓦特", toSI: 1),
            ConvertibleUnit(symbol: "кВт", nameRu: "Киловатт", nameEn: "Kilowatt", nameDe: "Kilowatt", nameEs: "Kilovatio", nameFr: "Kilowatt", nameZh: "千瓦", toSI: 1000),
            ConvertibleUnit(symbol: "МВт", nameRu: "Мегаватт", nameEn: "Megawatt", nameDe: "Megawatt", nameEs: "Megavatio", nameFr: "Mégawatt", nameZh: "兆瓦", toSI: 1e6),
            ConvertibleUnit(symbol: "л.с.", nameRu: "Лошадиная сила", nameEn: "Horsepower", nameDe: "Pferdestärke", nameEs: "Caballo de fuerza", nameFr: "Cheval-vapeur", nameZh: "马力", toSI: 745.7),
        ])
    }
    
    static var pressure: UnitCategory {
        UnitCategory(id: "pressure", icon: "gauge.with.dots.needle.bottom.50percent", nameRu: "Давление", nameEn: "Pressure", nameDe: "Druck", nameEs: "Presión", nameFr: "Pression", nameZh: "压强", units: [
            ConvertibleUnit(symbol: "Па", nameRu: "Паскаль", nameEn: "Pascal", nameDe: "Pascal", nameEs: "Pascal", nameFr: "Pascal", nameZh: "帕斯卡", toSI: 1),
            ConvertibleUnit(symbol: "кПа", nameRu: "Килопаскаль", nameEn: "Kilopascal", nameDe: "Kilopascal", nameEs: "Kilopascal", nameFr: "Kilopascal", nameZh: "千帕", toSI: 1000),
            ConvertibleUnit(symbol: "МПа", nameRu: "Мегапаскаль", nameEn: "Megapascal", nameDe: "Megapascal", nameEs: "Megapascal", nameFr: "Mégapascal", nameZh: "兆帕", toSI: 1e6),
            ConvertibleUnit(symbol: "атм", nameRu: "Атмосфера", nameEn: "Atmosphere", nameDe: "Atmosphäre", nameEs: "Atmósfera", nameFr: "Atmosphère", nameZh: "大气压", toSI: 101325),
            ConvertibleUnit(symbol: "бар", nameRu: "Бар", nameEn: "Bar", nameDe: "Bar", nameEs: "Bar", nameFr: "Bar", nameZh: "巴", toSI: 1e5),
            ConvertibleUnit(symbol: "мм рт.ст.", nameRu: "Миллиметр ртутного столба", nameEn: "mmHg", nameDe: "mmHg", nameEs: "mmHg", nameFr: "mmHg", nameZh: "毫米汞柱", toSI: 133.322),
            ConvertibleUnit(symbol: "psi", nameRu: "Фунт на кв. дюйм", nameEn: "Pound/sq inch", nameDe: "Pfund/Quadratzoll", nameEs: "Libra/pulgada²", nameFr: "Livre/pouce²", nameZh: "磅/平方英寸", toSI: 6894.76),
        ])
    }
    
    static var temperature: UnitCategory {
        UnitCategory(id: "temperature", icon: "thermometer.medium", nameRu: "Температура", nameEn: "Temperature", nameDe: "Temperatur", nameEs: "Temperatura", nameFr: "Température", nameZh: "温度", units: [
            // For temperature we use special handling: toSI stores offset info
            // K is base: toSI = 1, offset = 0
            // °C: K = °C + 273.15 → toSI = 1, but we need offset
            // °F: K = (°F - 32) × 5/9 + 273.15
            // We'll use a different approach for temperature - override in converter
            ConvertibleUnit(symbol: "К", nameRu: "Кельвин", nameEn: "Kelvin", nameDe: "Kelvin", nameEs: "Kelvin", nameFr: "Kelvin", nameZh: "开尔文", toSI: 1),
            ConvertibleUnit(symbol: "°C", nameRu: "Градус Цельсия", nameEn: "Celsius", nameDe: "Celsius", nameEs: "Celsius", nameFr: "Celsius", nameZh: "摄氏度", toSI: 1), // special
            ConvertibleUnit(symbol: "°F", nameRu: "Градус Фаренгейта", nameEn: "Fahrenheit", nameDe: "Fahrenheit", nameEs: "Fahrenheit", nameFr: "Fahrenheit", nameZh: "华氏度", toSI: 1), // special
        ])
    }
    
    static var electricCurrent: UnitCategory {
        UnitCategory(id: "electric", icon: "bolt", nameRu: "Электричество", nameEn: "Electricity", nameDe: "Elektrizität", nameEs: "Electricidad", nameFr: "Électricité", nameZh: "电学", units: [
            ConvertibleUnit(symbol: "А", nameRu: "Ампер", nameEn: "Ampere", nameDe: "Ampere", nameEs: "Amperio", nameFr: "Ampère", nameZh: "安培", toSI: 1),
            ConvertibleUnit(symbol: "мА", nameRu: "Миллиампер", nameEn: "Milliampere", nameDe: "Milliampere", nameEs: "Miliamperio", nameFr: "Milliampère", nameZh: "毫安", toSI: 0.001),
            ConvertibleUnit(symbol: "мкА", nameRu: "Микроампер", nameEn: "Microampere", nameDe: "Mikroampere", nameEs: "Microamperio", nameFr: "Microampère", nameZh: "微安", toSI: 1e-6),
            ConvertibleUnit(symbol: "В", nameRu: "Вольт", nameEn: "Volt", nameDe: "Volt", nameEs: "Voltio", nameFr: "Volt", nameZh: "伏特", toSI: 1),
            ConvertibleUnit(symbol: "кВ", nameRu: "Киловольт", nameEn: "Kilovolt", nameDe: "Kilovolt", nameEs: "Kilovoltio", nameFr: "Kilovolt", nameZh: "千伏", toSI: 1000),
            ConvertibleUnit(symbol: "мВ", nameRu: "Милливольт", nameEn: "Millivolt", nameDe: "Millivolt", nameEs: "Milivoltio", nameFr: "Millivolt", nameZh: "毫伏", toSI: 0.001),
            ConvertibleUnit(symbol: "Ом", nameRu: "Ом", nameEn: "Ohm", nameDe: "Ohm", nameEs: "Ohmio", nameFr: "Ohm", nameZh: "欧姆", toSI: 1),
            ConvertibleUnit(symbol: "кОм", nameRu: "Килоом", nameEn: "Kilohm", nameDe: "Kiloohm", nameEs: "Kiloohmio", nameFr: "Kilohm", nameZh: "千欧", toSI: 1000),
            ConvertibleUnit(symbol: "МОм", nameRu: "Мегаом", nameEn: "Megohm", nameDe: "Megaohm", nameEs: "Megaohmio", nameFr: "Mégohm", nameZh: "兆欧", toSI: 1e6),
        ])
    }
    
    static var frequency: UnitCategory {
        UnitCategory(id: "frequency", icon: "waveform", nameRu: "Частота", nameEn: "Frequency", nameDe: "Frequenz", nameEs: "Frecuencia", nameFr: "Fréquence", nameZh: "频率", units: [
            ConvertibleUnit(symbol: "Гц", nameRu: "Герц", nameEn: "Hertz", nameDe: "Hertz", nameEs: "Hercio", nameFr: "Hertz", nameZh: "赫兹", toSI: 1),
            ConvertibleUnit(symbol: "кГц", nameRu: "Килогерц", nameEn: "Kilohertz", nameDe: "Kilohertz", nameEs: "Kilohercio", nameFr: "Kilohertz", nameZh: "千赫", toSI: 1000),
            ConvertibleUnit(symbol: "МГц", nameRu: "Мегагерц", nameEn: "Megahertz", nameDe: "Megahertz", nameEs: "Megahercio", nameFr: "Mégahertz", nameZh: "兆赫", toSI: 1e6),
            ConvertibleUnit(symbol: "ГГц", nameRu: "Гигагерц", nameEn: "Gigahertz", nameDe: "Gigahertz", nameEs: "Gigahercio", nameFr: "Gigahertz", nameZh: "吉赫", toSI: 1e9),
        ])
    }
    
    static var area: UnitCategory {
        UnitCategory(id: "area", icon: "square", nameRu: "Площадь", nameEn: "Area", nameDe: "Fläche", nameEs: "Área", nameFr: "Aire", nameZh: "面积", units: [
            ConvertibleUnit(symbol: "м²", nameRu: "Кв. метр", nameEn: "Square meter", nameDe: "Quadratmeter", nameEs: "Metro cuadrado", nameFr: "Mètre carré", nameZh: "平方米", toSI: 1),
            ConvertibleUnit(symbol: "см²", nameRu: "Кв. сантиметр", nameEn: "Square centimeter", nameDe: "Quadratzentimeter", nameEs: "Centímetro cuadrado", nameFr: "Centimètre carré", nameZh: "平方厘米", toSI: 1e-4),
            ConvertibleUnit(symbol: "мм²", nameRu: "Кв. миллиметр", nameEn: "Square millimeter", nameDe: "Quadratmillimeter", nameEs: "Milímetro cuadrado", nameFr: "Millimètre carré", nameZh: "平方毫米", toSI: 1e-6),
            ConvertibleUnit(symbol: "км²", nameRu: "Кв. километр", nameEn: "Square kilometer", nameDe: "Quadratkilometer", nameEs: "Kilómetro cuadrado", nameFr: "Kilomètre carré", nameZh: "平方千米", toSI: 1e6),
            ConvertibleUnit(symbol: "га", nameRu: "Гектар", nameEn: "Hectare", nameDe: "Hektar", nameEs: "Hectárea", nameFr: "Hectare", nameZh: "公顷", toSI: 1e4),
        ])
    }
    
    static var volume: UnitCategory {
        UnitCategory(id: "volume", icon: "cube", nameRu: "Объём", nameEn: "Volume", nameDe: "Volumen", nameEs: "Volumen", nameFr: "Volume", nameZh: "体积", units: [
            ConvertibleUnit(symbol: "м³", nameRu: "Куб. метр", nameEn: "Cubic meter", nameDe: "Kubikmeter", nameEs: "Metro cúbico", nameFr: "Mètre cube", nameZh: "立方米", toSI: 1),
            ConvertibleUnit(symbol: "л", nameRu: "Литр", nameEn: "Liter", nameDe: "Liter", nameEs: "Litro", nameFr: "Litre", nameZh: "升", toSI: 0.001),
            ConvertibleUnit(symbol: "мл", nameRu: "Миллилитр", nameEn: "Milliliter", nameDe: "Milliliter", nameEs: "Mililitro", nameFr: "Millilitre", nameZh: "毫升", toSI: 1e-6),
            ConvertibleUnit(symbol: "см³", nameRu: "Куб. сантиметр", nameEn: "Cubic centimeter", nameDe: "Kubikzentimeter", nameEs: "Centímetro cúbico", nameFr: "Centimètre cube", nameZh: "立方厘米", toSI: 1e-6),
        ])
    }
}
