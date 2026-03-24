import Foundation

/// Конфигурация приложения. Заменяет .env файлы.
enum AppConfiguration {
    static let appName = "PhysicsCalculator"
    static let appVersion = "1.0"
    
    static let defaultLanguage = "ru"
    static let supportedLanguages = ["ru", "en", "de", "es", "fr", "zh"]
    
    static let cacheEnabled = true
    static let cacheDuration: TimeInterval = 3600
    
    static let databaseName = "PhysicsCalculatorModel"
}
