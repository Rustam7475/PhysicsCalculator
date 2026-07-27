import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    private let premium = PremiumManager.shared
    @State private var showingPaywall = false
    
    var body: some View {
        Form {
            // Premium секция
            Section {
                if premium.isPremium {
                    HStack(spacing: 12) {
                        Image(systemName: "crown.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Premium")
                                .font(.headline)
                            Text(L10n.premiumAlreadyActive)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                } else {
                    Button {
                        showingPaywall = true
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "crown.fill")
                                .font(.title2)
                                .foregroundStyle(.linearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(L10n.premiumUnlock)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Text(L10n.premiumBuyOnce)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
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
            
            #if DEBUG
            Section(header: Text("Debug")) {
                Toggle("Premium (тест)", isOn: Binding(
                    get: { UserDefaults.standard.bool(forKey: "isPremiumPurchased") },
                    set: { UserDefaults.standard.set($0, forKey: "isPremiumPurchased") }
                ))
            }
            #endif
        }
        .id(settings.currentLanguageCode)
        .navigationTitle(L10n.settingsTitle)
        .oledBackground()
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
}

#Preview {
    NavigationView {
        SettingsView()
            .environmentObject(AppSettings.shared)
    }
}
