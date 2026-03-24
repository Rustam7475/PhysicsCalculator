import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            Section(header: Text(L10n.appearance)) {
                Picker(L10n.themeLabel, selection: $settings.theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.localizedName)
                            .tag(theme)
                    }
                }
            }
            
            Section(header: Text(L10n.languageLabel)) {
                Picker(L10n.languageLabel, selection: $settings.languageCode) {
                    Text(L10n.langSystem).tag("system")
                    Text("Русский").tag("ru")
                    Text("English").tag("en")
                    Text("Deutsch").tag("de")
                    Text("Español").tag("es")
                    Text("Français").tag("fr")
                    Text("中文").tag("zh")
                }
            }
            
            Section(header: Text(L10n.aboutApp)) {
                HStack(spacing: 14) {
                    Image(systemName: "atom")
                        .font(.system(size: 32))
                        .foregroundColor(.accentColor)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PhysicsCalculator")
                            .font(.headline)
                        Text("\(L10n.version) 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .id(settings.currentLanguageCode)
        .navigationTitle(L10n.settingsTitle)
        .oledBackground()
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(AppSettings.shared)
    }
}
