import Foundation

extension L10n {
    // MARK: - Calculation Errors
    
    static var selectUnknownVariable: String { t(["ru": "Выберите неизвестную величину", "en": "Select the unknown variable", "de": "Wählen Sie die unbekannte Variable", "es": "Seleccione la variable desconocida", "fr": "Sélectionnez la variable inconnue", "zh": "选择未知变量"]) }
    
    static func enterCorrectValue(_ name: String) -> String {
        t(["ru": "Введите корректное значение для \(name)",
           "en": "Enter a valid value for \(name)",
           "de": "Geben Sie einen gültigen Wert für \(name) ein",
           "es": "Ingrese un valor válido para \(name)",
           "fr": "Entrez une valeur valide pour \(name)",
           "zh": "请为 \(name) 输入有效值"])
    }
    
    static func noRuleFor(_ symbol: String) -> String {
        t(["ru": "Не найдено правило расчета для \(symbol)",
           "en": "No calculation rule found for \(symbol)",
           "de": "Keine Berechnungsregel für \(symbol) gefunden",
           "es": "No se encontró regla de cálculo para \(symbol)",
           "fr": "Aucune règle de calcul trouvée pour \(symbol)",
           "zh": "未找到 \(symbol) 的计算规则"])
    }
    
    static var invalidResult: String { t(["ru": "Результат не определен (деление на ноль или переполнение)", "en": "Result undefined (division by zero or overflow)", "de": "Ergebnis undefiniert (Division durch Null oder Überlauf)", "es": "Resultado indefinido (división por cero o desbordamiento)", "fr": "Résultat indéfini (division par zéro ou dépassement)", "zh": "结果未定义（除以零或溢出）"]) }
    
    static func evaluationError(_ msg: String) -> String {
        t(["ru": "Ошибка при вычислении: \(msg)",
           "en": "Calculation error: \(msg)",
           "de": "Berechnungsfehler: \(msg)",
           "es": "Error de cálculo: \(msg)",
           "fr": "Erreur de calcul : \(msg)",
           "zh": "计算错误：\(msg)"])
    }
    
    // MARK: - Data Service Errors

    static var fileNotFound: String { t(["ru": "Файл с данными не найден", "en": "Data file not found", "de": "Datendatei nicht gefunden", "es": "Archivo de datos no encontrado", "fr": "Fichier de données introuvable", "zh": "未找到数据文件"]) }
    
    static func decodingError(_ err: String) -> String {
        t(["ru": "Ошибка декодирования: \(err)",
           "en": "Decoding error: \(err)",
           "de": "Dekodierungsfehler: \(err)",
           "es": "Error de decodificación: \(err)",
           "fr": "Erreur de décodage : \(err)",
           "zh": "解码错误：\(err)"])
    }
}
