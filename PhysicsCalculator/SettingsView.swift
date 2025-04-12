import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Form {
            // Секция "Внешний вид"
            Section(header: Text("Внешний вид")) {
                Picker("Тема", selection: $settings.theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.localizedName)
                            .tag(theme)
                    }
                }
            }
            
            // Секция "Язык"
            Section(header: Text("Язык")) {
                Picker("Язык", selection: $settings.languageCode) {
                    Text("Как в системе").tag("system")
                    Text("Русский").tag("ru")
                    Text("English").tag("en")
                    Text("Deutsch").tag("de")
                    Text("Español").tag("es")
                    Text("Français").tag("fr")
                    Text("中文").tag("zh")
                }
            }
            
            // Секция "О приложении"
            Section(header: Text("О приложении")) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("PhysicsCalculator")
                        .font(.headline)
                    Text("Версия 1.0.0")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("© 2024 Your Company")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Настройки")
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(AppSettings.shared)
    }
}
