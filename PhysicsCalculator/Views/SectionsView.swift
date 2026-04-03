import SwiftUI
import CoreData
import Foundation

struct SectionsView: View {
    let allData: PhysicsData
    @EnvironmentObject private var settings: AppSettings
    private let premium = PremiumManager.shared
    @State private var selectedSection: PhysicsSection? = nil
    @State private var selectedSubsection: PhysicsSubsection? = nil
    @State private var selectedLevel: String = "school"
    private let levels = ["school", "university"]

    // Состояние для поиска
    @State private var searchText: String = ""
    @State private var showingPaywall = false

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
            // При поиске ищем по ВСЕМ формулам без фильтра по уровню
            let T = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
             if T.isEmpty { return [] }
            
            return allData.formulas.filter { formula in
                let nameMatch = formula.localizedName.lowercased().contains(T)
                let descMatch = formula.localizedDescription.lowercased().contains(T)
                let varMatch = formula.variables.contains(where: { $0.symbol.lowercased() == T || $0.localizedName.lowercased().contains(T) })
                let subsectionMatch = allData.subsections.first(where: { $0.id == formula.subsectionId })
                    .map { $0.localizedName.lowercased().contains(T) } ?? false
                return nameMatch || descMatch || varMatch || subsectionMatch
            }
        } else {
            // Если не ищем, фильтруем по выбранному подразделу и уровню
            guard let subsectionId = selectedSubsection?.id else { return [] }
            return allData.formulas.filter { $0.subsectionId == subsectionId && $0.levels.contains(selectedLevel) }
        }
    }

    // Отображение имени уровня - ОПРЕДЕЛЕНО В EXTENSION НИЖЕ

    @FocusState private var isSearchFocused: Bool

    var body: some View {
        VStack(spacing: 12) {
            // Поиск
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField(L10n.searchPlaceholder, text: $searchText)
                        .focused($isSearchFocused)
                        .autocorrectionDisabled()
                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 12)
                .frame(height: 44)
                .background(Color(.tertiarySystemFill))
                .cornerRadius(10)

                if isSearchFocused {
                    Button(L10n.cancel) {
                        searchText = ""
                        isSearchFocused = false
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSearchFocused)

            // Picker уровня
            HStack(spacing: 8) {
                ForEach(levels, id: \.self) { level in
                    Button {
                        selectedLevel = level
                    } label: {
                        Text(levelDisplayName(level))
                            .font(.subheadline.weight(selectedLevel == level ? .semibold : .regular))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(selectedLevel == level ? Color.accentColor : Color(.secondarySystemBackground))
                            .foregroundColor(selectedLevel == level ? .white : .primary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 4)
            .onAppear {
                selectedSection = nil
                selectedSubsection = nil
            }
            .onChange(of: selectedLevel) { _ in
                selectedSection = nil
                selectedSubsection = nil
            }

            if !isSearching {
                // Меню Разделов
                Menu {
                     Button(L10n.reset, role: .destructive) { selectedSection = nil; selectedSubsection = nil }
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
                         Image(systemName: "folder")
                             .foregroundColor(.accentColor)
                         Text(selectedSection?.localizedName ?? L10n.selectSection)
                             .foregroundColor(selectedSection != nil ? .primary : .secondary)
                         Spacer()
                         Image(systemName: "chevron.up.chevron.down")
                             .font(.caption)
                             .foregroundColor(.secondary)
                     }
                     .padding()
                     .frame(maxWidth: .infinity)
                     .background(Color(.secondarySystemBackground))
                     .cornerRadius(12)
                 }
                .disabled(availableSections.isEmpty)
                .id("section_menu_" + settings.currentLanguageCode)

                // Меню Подразделов
                Menu {
                     Button(L10n.reset, role: .destructive) { selectedSubsection = nil }
                     ForEach(availableSubsections) { subsection in
                         Button(subsection.localizedName) { selectedSubsection = subsection }
                     }
                 } label: {
                     HStack {
                         Image(systemName: "doc.text")
                             .foregroundColor(.accentColor)
                         Text(selectedSubsection?.localizedName ?? L10n.selectSubsection)
                             .foregroundColor(selectedSubsection != nil ? .primary : .secondary)
                         Spacer()
                         Image(systemName: "chevron.up.chevron.down")
                             .font(.caption)
                             .foregroundColor(.secondary)
                     }
                     .padding()
                     .frame(maxWidth: .infinity)
                     .background(Color(.secondarySystemBackground))
                     .cornerRadius(12)
                 }
                .disabled(selectedSection == nil || availableSubsections.isEmpty)
                .id("subsection_menu_" + settings.currentLanguageCode)
            }

            // Список Формул
            List {
                if !filteredFormulas.isEmpty && isSearching {
                    Text(L10n.searchResults)
                        .font(.headline)
                        .padding(.vertical, 4)
                        .listRowBackground(Color.clear)
                }
                
                if filteredFormulas.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: isSearching ? "magnifyingglass" : "atom")
                            .font(.system(size: 44))
                            .foregroundColor(.secondary)
                        Text(emptyListMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(filteredFormulas) { formula in
                        let isAccessible = premium.isFormulaAccessible(formula, allFormulas: allData.formulas)
                        
                        if isAccessible {
                            NavigationLink(destination: CalculationView(formula: formula)) {
                                formulaRow(formula: formula, locked: false)
                            }
                        } else {
                            Button {
                                showingPaywall = true
                            } label: {
                                formulaRow(formula: formula, locked: true)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.top, 4)
        .id(settings.currentLanguageCode)
        .navigationTitle(L10n.sectionsTitle)
        .oledBackground()
        .sheet(isPresented: $showingPaywall) {
            PaywallView()
        }
    }
    
    @ViewBuilder
    private func formulaRow(formula: Formula, locked: Bool) -> some View {
        HStack(spacing: 12) {
            Image(systemName: locked ? "lock.fill" : "function")
                .font(.system(size: 14))
                .foregroundColor(locked ? .secondary : .accentColor)
                .frame(width: 28, height: 28)
                .background((locked ? Color.secondary : Color.accentColor).opacity(0.12))
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(formula.localizedName)
                    .font(.body)
                    .foregroundColor(locked ? .secondary : .primary)
                if isSearching {
                    if let subsection = allData.subsections.first(where: { $0.id == formula.subsectionId }) {
                        Text(subsection.localizedName)
                            .font(.caption)
                            .foregroundColor(.accentColor)
                    }
                    Text(formula.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            if locked {
                Spacer()
                Text("Premium")
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(6)
            }
        }
        .padding(.vertical, 4)
    }

     // --- Вспомогательные свойства для текста в списке ---
     private var listHeaderTitle: String {
         if isSearching {
             return filteredFormulas.isEmpty ? "" : L10n.searchResults
         } else if let subsection = selectedSubsection {
             return subsection.localizedName
         } else if selectedSection != nil {
             return L10n.selectSubsection
         } else {
             return "" // Не показываем заголовок, если ничего не выбрано
         }
     }

     private var emptyListMessage: String {
         if isSearching {
             return L10n.nothingFound
         } else if selectedSection == nil {
              return L10n.selectPhysicsSection
         } else if selectedSubsection == nil {
             return L10n.selectPhysicsSubsection
         } else {
              return L10n.noFormulasInSection
         }
     }

} // Конец struct SectionsView


// --- Функция для отображения имени уровня (В EXTENSION) ---
extension SectionsView {
    private func levelDisplayName(_ levelKey: String) -> String {
        switch levelKey {
        case "school": return L10n.levelSchool
        case "university": return L10n.levelUniversity
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
