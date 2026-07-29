import Foundation

extension L10n {
    // MARK: - UnitConverter names
    
    static func unitName(_ id: String) -> String {
        let map: [String: [String: String]] = [
            // Length
            "m": ["ru": "Метры", "en": "Meters", "de": "Meter", "es": "Metros", "fr": "Mètres", "zh": "米"],
            "km": ["ru": "Километры", "en": "Kilometers", "de": "Kilometer", "es": "Kilómetros", "fr": "Kilomètres", "zh": "千米"],
            "cm": ["ru": "Сантиметры", "en": "Centimeters", "de": "Zentimeter", "es": "Centímetros", "fr": "Centimètres", "zh": "厘米"],
            "mm": ["ru": "Миллиметры", "en": "Millimeters", "de": "Millimeter", "es": "Milímetros", "fr": "Millimètres", "zh": "毫米"],
            "mi": ["ru": "Мили", "en": "Miles", "de": "Meilen", "es": "Millas", "fr": "Miles", "zh": "英里"],
            "ft": ["ru": "Футы", "en": "Feet", "de": "Fuß", "es": "Pies", "fr": "Pieds", "zh": "英尺"],
            // Time
            "s": ["ru": "Секунды", "en": "Seconds", "de": "Sekunden", "es": "Segundos", "fr": "Secondes", "zh": "秒"],
            "ms_time": ["ru": "Миллисекунды", "en": "Milliseconds", "de": "Millisekunden", "es": "Milisegundos", "fr": "Millisecondes", "zh": "毫秒"],
            "min": ["ru": "Минуты", "en": "Minutes", "de": "Minuten", "es": "Minutos", "fr": "Minutes", "zh": "分钟"],
            "h_time": ["ru": "Часы", "en": "Hours", "de": "Stunden", "es": "Horas", "fr": "Heures", "zh": "小时"],
            // Mass
            "kg": ["ru": "Килограммы", "en": "Kilograms", "de": "Kilogramm", "es": "Kilogramos", "fr": "Kilogrammes", "zh": "千克"],
            "g_mass": ["ru": "Граммы", "en": "Grams", "de": "Gramm", "es": "Gramos", "fr": "Grammes", "zh": "克"],
            "mg": ["ru": "Миллиграммы", "en": "Milligrams", "de": "Milligramm", "es": "Miligramos", "fr": "Milligrammes", "zh": "毫克"],
            "t": ["ru": "Тонны", "en": "Tons", "de": "Tonnen", "es": "Toneladas", "fr": "Tonnes", "zh": "吨"],
            "lb": ["ru": "Фунты", "en": "Pounds", "de": "Pfund", "es": "Libras", "fr": "Livres", "zh": "磅"],
            // Speed
            "ms_speed": ["ru": "м/с", "en": "m/s", "de": "m/s", "es": "m/s", "fr": "m/s", "zh": "m/s"],
            "kmh": ["ru": "км/ч", "en": "km/h", "de": "km/h", "es": "km/h", "fr": "km/h", "zh": "km/h"],
            "mph": ["ru": "мили/ч", "en": "mph", "de": "mph", "es": "mph", "fr": "mph", "zh": "mph"],
            // Force
            "N": ["ru": "Ньютоны", "en": "Newtons", "de": "Newton", "es": "Newtons", "fr": "Newtons", "zh": "牛顿"],
            "kN": ["ru": "Килоньютоны", "en": "Kilonewtons", "de": "Kilonewton", "es": "Kilonewtons", "fr": "Kilonewtons", "zh": "千牛顿"],
            "dyn": ["ru": "Дины", "en": "Dynes", "de": "Dyn", "es": "Dinas", "fr": "Dynes", "zh": "达因"],
            // Pressure
            "Pa": ["ru": "Паскали", "en": "Pascals", "de": "Pascal", "es": "Pascales", "fr": "Pascals", "zh": "帕斯卡"],
            "kPa": ["ru": "Килопаскали", "en": "Kilopascals", "de": "Kilopascal", "es": "Kilopascales", "fr": "Kilopascals", "zh": "千帕"],
            "atm": ["ru": "Атмосферы", "en": "Atmospheres", "de": "Atmosphären", "es": "Atmósferas", "fr": "Atmosphères", "zh": "大气压"],
            "mmHg": ["ru": "мм рт. ст.", "en": "mmHg", "de": "mmHg", "es": "mmHg", "fr": "mmHg", "zh": "mmHg"],
            "bar": ["ru": "Бары", "en": "Bars", "de": "Bar", "es": "Bares", "fr": "Bars", "zh": "巴"],
            // Energy
            "J": ["ru": "Джоули", "en": "Joules", "de": "Joule", "es": "Julios", "fr": "Joules", "zh": "焦耳"],
            "kJ": ["ru": "Килоджоули", "en": "Kilojoules", "de": "Kilojoule", "es": "Kilojulios", "fr": "Kilojoules", "zh": "千焦"],
            "cal": ["ru": "Калории", "en": "Calories", "de": "Kalorien", "es": "Calorías", "fr": "Calories", "zh": "卡路里"],
            "kcal": ["ru": "Килокалории", "en": "Kilocalories", "de": "Kilokalorien", "es": "Kilocalorías", "fr": "Kilocalories", "zh": "千卡"],
            "eV": ["ru": "Электронвольты", "en": "Electronvolts", "de": "Elektronenvolt", "es": "Electronvoltios", "fr": "Électronvolts", "zh": "电子伏特"],
            // Power
            "W": ["ru": "Ватты", "en": "Watts", "de": "Watt", "es": "Vatios", "fr": "Watts", "zh": "瓦特"],
            "kW": ["ru": "Киловатты", "en": "Kilowatts", "de": "Kilowatt", "es": "Kilovatios", "fr": "Kilowatts", "zh": "千瓦"],
            "hp": ["ru": "Лошадиные силы", "en": "Horsepower", "de": "Pferdestärken", "es": "Caballos de fuerza", "fr": "Chevaux", "zh": "马力"],
            // Temperature
            "K": ["ru": "Кельвины", "en": "Kelvin", "de": "Kelvin", "es": "Kelvin", "fr": "Kelvin", "zh": "开尔文"],
            "C_temp": ["ru": "Цельсий", "en": "Celsius", "de": "Celsius", "es": "Celsius", "fr": "Celsius", "zh": "摄氏度"],
            "F_temp": ["ru": "Фаренгейт", "en": "Fahrenheit", "de": "Fahrenheit", "es": "Fahrenheit", "fr": "Fahrenheit", "zh": "华氏度"],
            // Frequency
            "Hz": ["ru": "Герцы", "en": "Hertz", "de": "Hertz", "es": "Hercios", "fr": "Hertz", "zh": "赫兹"],
            "kHz": ["ru": "Килогерцы", "en": "Kilohertz", "de": "Kilohertz", "es": "Kilohercios", "fr": "Kilohertz", "zh": "千赫兹"],
            "MHz": ["ru": "Мегагерцы", "en": "Megahertz", "de": "Megahertz", "es": "Megahercios", "fr": "Mégahertz", "zh": "兆赫兹"],
            // Current
            "A": ["ru": "Амперы", "en": "Amperes", "de": "Ampere", "es": "Amperios", "fr": "Ampères", "zh": "安培"],
            "mA": ["ru": "Миллиамперы", "en": "Milliamperes", "de": "Milliampere", "es": "Miliamperios", "fr": "Milliampères", "zh": "毫安"],
            "uA": ["ru": "Микроамперы", "en": "Microamperes", "de": "Mikroampere", "es": "Microamperios", "fr": "Microampères", "zh": "微安"],
            // Voltage
            "V": ["ru": "Вольты", "en": "Volts", "de": "Volt", "es": "Voltios", "fr": "Volts", "zh": "伏特"],
            "kV": ["ru": "Киловольты", "en": "Kilovolts", "de": "Kilovolt", "es": "Kilovoltios", "fr": "Kilovolts", "zh": "千伏"],
            "mV": ["ru": "Милливольты", "en": "Millivolts", "de": "Millivolt", "es": "Milivoltios", "fr": "Millivolts", "zh": "毫伏"],
            // Resistance
            "Ohm": ["ru": "Омы", "en": "Ohms", "de": "Ohm", "es": "Ohmios", "fr": "Ohms", "zh": "欧姆"],
            "kOhm": ["ru": "Килоомы", "en": "Kilohms", "de": "Kilohm", "es": "Kiloohmios", "fr": "Kilohms", "zh": "千欧"],
            "MOhm": ["ru": "Мегаомы", "en": "Megohms", "de": "Megohm", "es": "Megaohmios", "fr": "Mégohms", "zh": "兆欧"],
            // Charge
            "C_charge": ["ru": "Кулоны", "en": "Coulombs", "de": "Coulomb", "es": "Culombios", "fr": "Coulombs", "zh": "库仑"],
            "mC": ["ru": "Милликулоны", "en": "Millicoulombs", "de": "Millicoulomb", "es": "Miliculombios", "fr": "Millicoulombs", "zh": "毫库仑"],
            "uC": ["ru": "Микрокулоны", "en": "Microcoulombs", "de": "Mikrocoulomb", "es": "Microculombios", "fr": "Microcoulombs", "zh": "微库仑"],
            // Area
            "m2": ["ru": "м²", "en": "m²", "de": "m²", "es": "m²", "fr": "m²", "zh": "m²"],
            "cm2": ["ru": "см²", "en": "cm²", "de": "cm²", "es": "cm²", "fr": "cm²", "zh": "cm²"],
            "km2": ["ru": "км²", "en": "km²", "de": "km²", "es": "km²", "fr": "km²", "zh": "km²"],
            // Volume
            "m3": ["ru": "м³", "en": "m³", "de": "m³", "es": "m³", "fr": "m³", "zh": "m³"],
            "L": ["ru": "Литры", "en": "Liters", "de": "Liter", "es": "Litros", "fr": "Litres", "zh": "升"],
            "cm3": ["ru": "см³", "en": "cm³", "de": "cm³", "es": "cm³", "fr": "cm³", "zh": "cm³"],
            // Acceleration
            "ms2": ["ru": "м/с²", "en": "m/s²", "de": "m/s²", "es": "m/s²", "fr": "m/s²", "zh": "m/s²"],
            "g_acc": ["ru": "g (9.81)", "en": "g (9.81)", "de": "g (9,81)", "es": "g (9,81)", "fr": "g (9,81)", "zh": "g (9.81)"],
            // Angle
            "rad": ["ru": "Радианы", "en": "Radians", "de": "Radiant", "es": "Radianes", "fr": "Radians", "zh": "弧度"],
            "deg": ["ru": "Градусы", "en": "Degrees", "de": "Grad", "es": "Grados", "fr": "Degrés", "zh": "度"],
        ]
        return t(map[id] ?? ["en": id])
    }
}
