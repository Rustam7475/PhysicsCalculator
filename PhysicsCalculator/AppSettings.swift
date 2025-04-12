import SwiftUI
import Combine // Для ObservableObject
import Foundation

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

// Структура для представления языка
public struct LanguageSetting: Identifiable, Hashable {
    public let code: String // "en", "ru", "de", "system"
    public let name: String // "English", "Русский", "Deutsch", "Как в системе"
    public var id: String { code }
}

// Класс для управления настройками приложения
// Используем ObservableObject, чтобы интерфейс мог реагировать на изменения
public class AppSettings: ObservableObject {
    // Ключи для UserDefaults
    private enum Keys {
        static let theme = "appTheme"
        static let languageCode = "languageCode"
    }
    
    // --- Настройки Тема ---
    // Текущая тема (с сохранением в UserDefaults)
    @Published public var theme: AppTheme {
        didSet {
            UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme)
        }
    }
    
    // --- Конец Настроек Тема ---
    
    // --- Настройки Языка ---
    // Код языка (с сохранением в UserDefaults)
    @Published public var languageCode: String {
        didSet {
            UserDefaults.standard.set(languageCode, forKey: Keys.languageCode)
        }
    }
    
    // Вычисляемое свойство для получения текущего КОДА языка, который нужно использовать
    // (учитывает "system")
    @Published public var currentLanguageCode: String = "ru"
    
    // --- Конец Настроек Языка ---
    
    // Синглтон для глобального доступа к настройкам (для моделей данных)
    // Убедитесь, что он инициализируется только один раз
    public static let shared = AppSettings()
    
    public init() {
        // Загружаем сохраненные настройки или используем значения по умолчанию
        let savedTheme = UserDefaults.standard.string(forKey: Keys.theme)
        theme = AppTheme(rawValue: savedTheme ?? AppTheme.system.rawValue) ?? .system
        
        languageCode = UserDefaults.standard.string(forKey: Keys.languageCode) ?? "system"
    }
}
