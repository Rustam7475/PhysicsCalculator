import Foundation

/// Centralized localization for all UI strings.
/// Supported languages: ru, en, de, es, fr, zh
/// Note: This file contains the base logic. Categorized strings are in L10n+ Extensions.
enum L10n {
    
    // MARK: - Core Logic
    
    static var code: String { 
        AppSettings.shared.currentLanguageCode 
    }
    
    static func t(_ dict: [String: String]) -> String {
        dict[code] ?? dict["en"] ?? ""
    }
    
    // MARK: - Legacy / Unclassified
    
    // If any strings are not yet moved to extensions, they can stay here temporarily.
    // However, for a clean architecture, we aim to have all strings in category extensions.
}
