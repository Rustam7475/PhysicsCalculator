import SwiftUI

// Определяем возможные темы
public enum AppTheme: String, CaseIterable, Identifiable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    public var id: String { self.rawValue }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
    
    public var localizedName: String {
        switch self {
        case .light: return "Светлая"
        case .dark: return "Темная"
        case .system: return "Системная"
        }
    }
}

// Класс для управления настройками приложения
public class AppSettings: ObservableObject {
    // Ключи для UserDefaults
    private enum Keys {
        static let theme = "appTheme"
        static let languageCode = "languageCode"
    }
    
    // Текущая тема (с сохранением в UserDefaults)
    @Published public var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme)
        }
    }
    
    // Код языка (с сохранением в UserDefaults)
    @Published public var languageCode: String {
        didSet {
            UserDefaults.standard.set(languageCode, forKey: Keys.languageCode)
            currentLanguageCode = Self.resolveLanguageCode(languageCode)
        }
    }
    
    // Актуальный код языка ("system" преобразуется в реальный код)
    @Published public var currentLanguageCode: String
    
    // Синглтон для доступа из моделей данных
    public static let shared = AppSettings()
    
    public init() {
        let savedTheme = UserDefaults.standard.string(forKey: Keys.theme)
        theme = AppTheme(rawValue: savedTheme ?? AppTheme.system.rawValue) ?? .system
        
        let savedLang = UserDefaults.standard.string(forKey: Keys.languageCode) ?? "system"
        languageCode = savedLang
        currentLanguageCode = Self.resolveLanguageCode(savedLang)
    }
    
    /// Преобразует выбор языка в реальный код ("system" → код системы)
    private static func resolveLanguageCode(_ code: String) -> String {
        if code == "system" {
            let preferred = Locale.preferredLanguages.first ?? "en"
            let langCode = Locale(identifier: preferred).language.languageCode?.identifier ?? "en"
            return AppConfiguration.supportedLanguages.contains(langCode) ? langCode : "en"
        }
        return code
    }
}
