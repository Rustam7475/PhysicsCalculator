import SwiftUI
import CoreData

@main
struct PhysicsCalculatorApp: App {
    @StateObject private var settings = AppSettings.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
                .environmentObject(settings)
                .preferredColorScheme(settings.theme.colorScheme)
        }
    }
}
