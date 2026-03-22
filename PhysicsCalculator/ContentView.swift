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
                        Label("Разделы", systemImage: "list.bullet")
                    }
                    
                    NavigationStack {
                        FavoritesView()
                    }
                    .tabItem {
                        Label("Избранное", systemImage: "star")
                    }
                    
                    NavigationStack {
                        SettingsView()
                    }
                    .tabItem {
                        Label("Настройки", systemImage: "gear")
                    }
                }
                .preferredColorScheme(settings.theme.colorScheme)
            } else if viewModel.isLoading {
                ProgressView("Загрузка данных...")
            } else if let error = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 40))
                        .foregroundColor(.orange)
                    Text(error)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    Button("Повторить") {
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
