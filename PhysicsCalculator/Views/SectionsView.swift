import SwiftUI
import CoreData
import Foundation

struct SectionsView: View {
    let allData: PhysicsData
    @State private var selectedSection: PhysicsSection? = nil
    @State private var selectedSubsection: PhysicsSubsection? = nil
    @State private var selectedLevel: String = "school"
    private let levels = ["school", "university"]

    // Состояние для поиска
    @State private var searchText: String = ""

    // --- Вычисляемые свойства с фильтрацией по уровню И ПОИСКУ ---

    // Поиск активен, если searchText не пуст
    var isSearching: Bool { !searchText.isEmpty }

    // Разделы: Фильтруются по уровню. Поиск на них пока не влияет.
    var availableSections: [PhysicsSection] {
        allData.sections.filter { $0.levels.contains(selectedLevel) }
    }

    // Подразделы: Фильтруются по разделу и уровню. Поиск не влияет.
    var availableSubsections: [PhysicsSubsection] {
        guard let sectionId = selectedSection?.id else { return [] }
        return allData.subsections.filter { $0.sectionId == sectionId && $0.levels.contains(selectedLevel) }
    }

    // Формулы: Фильтруются по подразделу и уровню ИЛИ по поиску
    var filteredFormulas: [Formula] {
        if isSearching {
            // Если ищем, фильтруем ВСЕ формулы по searchText и selectedLevel
            let T = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) // Убираем пробелы
             if T.isEmpty { return [] } // Если поиск пуст после обрезки, не показываем ничего
            
            return allData.formulas.filter { formula in
                formula.levels.contains(selectedLevel) && // Учитываем уровень
                (formula.localizedName.lowercased().contains(T) || // Ищем в названии
                 formula.localizedDescription.lowercased().contains(T) || // Ищем в описании
                 formula.variables.contains(where: { $0.symbol.lowercased() == T })) // Ищем по символу переменной
            }
        } else {
            // Если не ищем, фильтруем по выбранному подразделу и уровню
            guard let subsectionId = selectedSubsection?.id else { return [] }
            return allData.formulas.filter { $0.subsectionId == subsectionId && $0.levels.contains(selectedLevel) }
        }
    }

    // Отображение имени уровня - ОПРЕДЕЛЕНО В EXTENSION НИЖЕ

    var body: some View {
        VStack(spacing: 15) {
            // Picker уровня
            Picker("Уровень", selection: $selectedLevel) {
                 ForEach(levels, id: \.self) { level in
                     Text(levelDisplayName(level)).tag(level)
                 }
             }
            .pickerStyle(.segmented)
            .padding(.bottom, 5)
            .onChange(of: selectedLevel, initial: true) { oldValue, newValue in
                selectedSection = nil
                selectedSubsection = nil
            }

            if !isSearching {
                // Меню Разделов
                Menu {
                     Button("Сбросить", role: .destructive) { selectedSection = nil; selectedSubsection = nil }
                     ForEach(availableSections) { section in
                         Button(section.localizedName) {
                             if selectedSection != section {
                                 selectedSection = section
                                 selectedSubsection = nil
                             }
                         }
                     }
                 } label: {
                     HStack {
                         Text(selectedSection?.localizedName ?? "Выберите раздел")
                         Spacer()
                         Image(systemName: "chevron.down")
                     }
                     .padding()
                     .frame(maxWidth: .infinity)
                     .background(Color(.secondarySystemBackground))
                     .cornerRadius(8)
                 }
                .disabled(availableSections.isEmpty)

                // Меню Подразделов
                Menu {
                     Button("Сбросить", role: .destructive) { selectedSubsection = nil }
                     ForEach(availableSubsections) { subsection in
                         Button(subsection.localizedName) { selectedSubsection = subsection }
                     }
                 } label: {
                     HStack {
                         Text(selectedSubsection?.localizedName ?? "Выберите подраздел")
                         Spacer()
                         Image(systemName: "chevron.down")
                     }
                     .padding()
                     .frame(maxWidth: .infinity)
                     .background(Color(.secondarySystemBackground))
                     .cornerRadius(8)
                 }
                .disabled(selectedSection == nil || availableSubsections.isEmpty)
            }

            // Список Формул ИЛИ Результатов Поиска
            List {
                if !filteredFormulas.isEmpty || !isSearching {
                    Text(listHeaderTitle)
                        .font(.headline)
                        .padding(.vertical, 8)
                        .listRowBackground(Color.clear)
                }
                
                if filteredFormulas.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                            .padding(.bottom, 5)
                        Text(emptyListMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(filteredFormulas) { formula in
                        NavigationLink(destination: CalculationView(formula: formula)) {
                            VStack(alignment: .leading) {
                                Text(formula.localizedName)
                                if isSearching {
                                    Text(formula.localizedDescription)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal)
        .navigationTitle("Разделы физики")
        .searchable(text: $searchText, prompt: "Поиск по формулам")
    }

     // --- Вспомогательные свойства для текста в списке ---
     private var listHeaderTitle: String {
         if isSearching {
             return filteredFormulas.isEmpty ? "" : "Результаты поиска" // Не показываем заголовок, если поиск ничего не дал
         } else if let subsection = selectedSubsection {
             return subsection.localizedName
         } else if selectedSection != nil {
             return "Выберите подраздел" // Подсказка, если выбран раздел, но не подраздел
         } else {
             return "" // Не показываем заголовок, если ничего не выбрано
         }
     }

     private var emptyListMessage: String {
         if isSearching {
             return "Ничего не найдено"
         } else if selectedSection == nil {
              return "Выберите раздел физики"
         } else if selectedSubsection == nil {
             return "Выберите подраздел физики"
         } else {
              return "В этом разделе пока нет формул"
         }
     }

} // Конец struct SectionsView


// --- Функция для отображения имени уровня (В EXTENSION) ---
extension SectionsView {
    private func levelDisplayName(_ levelKey: String) -> String {
        switch levelKey {
        case "school": return "Школьный"
        case "university": return "Университетский"
        default: return levelKey
        }
    }
}

// --- Предпросмотр ---
#Preview {
    if let previewData = loadPhysicsData() {
        SectionsView(allData: previewData)
            .environment(\.managedObjectContext, PersistenceController(inMemory: true).container.viewContext)
    } else {
        Text("Ошибка загрузки данных для превью")
    }
}
