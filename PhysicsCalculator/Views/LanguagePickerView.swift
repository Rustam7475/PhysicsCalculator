import SwiftUI

struct LanguagePickerView: View {
    @Binding var hasChosenLanguage: Bool
    @EnvironmentObject private var settings: AppSettings
    @State private var selectedCode: String = "system"
    
    private let languages: [(code: String, flag: String, name: String, native: String)] = [
        ("system", "🌐", "System", "Как в системе"),
        ("ru", "🇷🇺", "Russian", "Русский"),
        ("en", "🇬🇧", "English", "English"),
        ("de", "🇩🇪", "German", "Deutsch"),
        ("es", "🇪🇸", "Spanish", "Español"),
        ("fr", "🇫🇷", "French", "Français"),
        ("zh", "🇨🇳", "Chinese", "中文"),
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "globe")
                .font(.system(size: 64))
                .foregroundColor(.accentColor)
            
            Text("Choose Language")
                .font(.title.weight(.bold))
            
            Text("Выберите язык / Select language")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                ForEach(languages, id: \.code) { lang in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedCode = lang.code
                        }
                    } label: {
                        HStack(spacing: 14) {
                            Text(lang.flag)
                                .font(.title2)
                            
                            Text(lang.native)
                                .font(.body.weight(.medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if selectedCode == lang.code {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedCode == lang.code
                                      ? Color.accentColor.opacity(0.1)
                                      : Color(.secondarySystemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedCode == lang.code
                                        ? Color.accentColor
                                        : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button {
                settings.languageCode = selectedCode
                hasChosenLanguage = true
            } label: {
                Text("Continue / Продолжить")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
            }
            .buttonStyle(.borderedProminent)
            .cornerRadius(14)
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
}
