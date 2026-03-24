import SwiftUI
import CoreData

@main
struct PhysicsCalculatorApp: App {
    @StateObject private var settings = AppSettings.shared
    @AppStorage("hasChosenLanguage") private var hasChosenLanguage = false
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if !hasChosenLanguage {
                LanguagePickerView(hasChosenLanguage: $hasChosenLanguage)
                    .environmentObject(settings)
                    .preferredColorScheme(settings.theme.colorScheme)
            } else if !hasSeenOnboarding {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .environmentObject(settings)
                    .preferredColorScheme(settings.theme.colorScheme)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                    .environmentObject(settings)
                    .preferredColorScheme(settings.theme.colorScheme)
            }
        }
    }
}
