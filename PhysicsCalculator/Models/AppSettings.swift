import SwiftUI

// Определяем возможные темы
public enum AppTheme: String, CaseIterable, Identifiable {
    case light = "light"
    case dark = "dark"
    case oled = "oled"
    case system = "system"
    
    public var id: String { self.rawValue }
    
    public var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark, .oled: return .dark
        case .system: return nil
        }
    }
    
    public var isOLED: Bool { self == .oled }
    
    public var localizedName: String {
        switch self {
        case .light: return L10n.themeLight
        case .dark: return L10n.themeDark
        case .oled: return L10n.themeOLED
        case .system: return L10n.themeSystem
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
            let resolved = Self.resolveLanguageCode(languageCode)
            if currentLanguageCode != resolved {
                currentLanguageCode = resolved
                objectWillChange.send()
            }
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

// MARK: - OLED Environment Key

private struct OLEDBackgroundKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var oledBackground: Bool {
        get { self[OLEDBackgroundKey.self] }
        set { self[OLEDBackgroundKey.self] = newValue }
    }
}

extension View {
    func oledBackground() -> some View {
        modifier(OLEDBackgroundModifier())
    }
}

struct OLEDBackgroundModifier: ViewModifier {
    @Environment(\.oledBackground) private var isOLED
    
    func body(content: Content) -> some View {
        if isOLED {
            if #available(iOS 16.1, *) {
                content
                    .scrollContentBackground(.hidden)
                    .background(Color.black.ignoresSafeArea())
            } else {
                content
                    .background(Color.black.ignoresSafeArea())
            }
        } else {
            content
        }
    }
}
