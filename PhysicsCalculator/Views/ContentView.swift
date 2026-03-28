import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var settings: AppSettings
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if let data = viewModel.physicsData {
                TabView {
                    NavigationStack {
                        SectionsView(allData: data)
                    }
                    .tabItem {
                        Label(L10n.tabSections, systemImage: "list.bullet")
                    }
                    
                    NavigationStack {
                        FavoritesView()
                    }
                    .tabItem {
                        Label(L10n.tabFavorites, systemImage: "star")
                    }
                    
                    NavigationStack {
                        HistoryView()
                    }
                    .tabItem {
                        Label(L10n.tabHistory, systemImage: "clock.arrow.circlepath")
                    }
                    
                    NavigationStack {
                        SettingsView()
                    }
                    .tabItem {
                        Label(L10n.tabSettings, systemImage: "gear")
                    }
                    
                    NavigationStack {
                        UnitConverterView()
                    }
                    .tabItem {
                        Label(L10n.tabConverter, systemImage: "arrow.left.arrow.right")
                    }
                    
                    NavigationStack {
                        ConstantsView()
                    }
                    .tabItem {
                        Label(L10n.tabConstants, systemImage: "textformat.123")
                    }
                }
                .id(settings.currentLanguageCode)
                .tint(.accentColor)
                .preferredColorScheme(settings.theme.colorScheme)
                .environment(\.oledBackground, settings.theme.isOLED)
            } else if viewModel.isLoading {
                ProgressView(L10n.loading)
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                        .accessibilityHidden(true)
                    Text(error)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button(L10n.retry) {
                        Task { await viewModel.loadData() }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
        }
        .task {
            await viewModel.loadData()
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(AppSettings.shared)
}
