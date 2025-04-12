import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var settings: AppSettings
    @State private var physicsData: PhysicsData?
    
    var body: some View {
        Group {
            if let data = physicsData {
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
            } else {
                ProgressView("Загрузка данных...")
            }
        }
        .task {
            await loadData()
        }
    }
    
    private func loadData() async {
        // Загрузка данных из JSON
        if let url = Bundle.main.url(forResource: "formulas_data", withExtension: "json"),
           let data = try? Data(contentsOf: url) {
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(PhysicsData.self, from: data)
                physicsData = jsonData
            } catch {
                print("Ошибка декодирования JSON: \(error)")
                // В случае ошибки используем тестовые данные
                let testData = PhysicsData(
                    sections: [
                        PhysicsSection(
                            id: "mechanics",
                            name_ru: "Механика",
                            name_en: "Mechanics",
                            levels: ["basic"]
                        )
                    ],
                    subsections: [
                        PhysicsSubsection(
                            id: "kinematics",
                            sectionId: "mechanics",
                            name_ru: "Кинематика",
                            name_en: "Kinematics",
                            levels: ["basic"]
                        )
                    ],
                    formulas: [
                        Formula(
                            id: "velocity",
                            subsectionId: "kinematics",
                            name_ru: "Скорость",
                            name_en: "Velocity",
                            levels: ["basic"],
                            equation_latex: "v = \\frac{s}{t}",
                            description_ru: "Скорость - это отношение пройденного пути ко времени",
                            description_en: "Velocity is the ratio of distance to time",
                            variables: [
                                Variable(symbol: "v", name_ru: "Скорость", name_en: "Velocity", unit_si: "м/с"),
                                Variable(symbol: "s", name_ru: "Путь", name_en: "Distance", unit_si: "м"),
                                Variable(symbol: "t", name_ru: "Время", name_en: "Time", unit_si: "с")
                            ],
                            calculation_rules: [
                                "v": "s / t",
                                "s": "v * t",
                                "t": "s / v"
                            ]
                        )
                    ]
                )
                physicsData = testData
            }
        } else {
            print("Не удалось найти или загрузить файл formulas_data.json")
            // В случае ошибки используем тестовые данные
            let testData = PhysicsData(
                sections: [
                    PhysicsSection(
                        id: "mechanics",
                        name_ru: "Механика",
                        name_en: "Mechanics",
                        levels: ["basic"]
                    )
                ],
                subsections: [
                    PhysicsSubsection(
                        id: "kinematics",
                        sectionId: "mechanics",
                        name_ru: "Кинематика",
                        name_en: "Kinematics",
                        levels: ["basic"]
                    )
                ],
                formulas: [
                    Formula(
                        id: "velocity",
                        subsectionId: "kinematics",
                        name_ru: "Скорость",
                        name_en: "Velocity",
                        levels: ["basic"],
                        equation_latex: "v = \\frac{s}{t}",
                        description_ru: "Скорость - это отношение пройденного пути ко времени",
                        description_en: "Velocity is the ratio of distance to time",
                        variables: [
                            Variable(symbol: "v", name_ru: "Скорость", name_en: "Velocity", unit_si: "м/с"),
                            Variable(symbol: "s", name_ru: "Путь", name_en: "Distance", unit_si: "м"),
                            Variable(symbol: "t", name_ru: "Время", name_en: "Time", unit_si: "с")
                        ],
                        calculation_rules: [
                            "v": "s / t",
                            "s": "v * t",
                            "t": "s / v"
                        ]
                    )
                ]
            )
            physicsData = testData
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        .environmentObject(AppSettings.shared)
}
