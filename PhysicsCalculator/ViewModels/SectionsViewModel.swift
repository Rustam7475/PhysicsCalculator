import SwiftUI

/// ViewModel для `SectionsView`. Инкапсулирует состояние выбора раздела/подраздела/уровня и поиск.
@MainActor
final class SectionsViewModel: ObservableObject {
    let allData: PhysicsData

    @Published var selectedSection: PhysicsSection?
    @Published var selectedSubsection: PhysicsSubsection?
    @Published var selectedLevel: String = "school"
    @Published var searchText: String = ""
    @Published var showingPaywall = false

    let levels = ["school", "university"]

    init(allData: PhysicsData) {
        self.allData = allData
    }

    // MARK: - Вычисляемые свойства

    var isSearching: Bool { !searchText.isEmpty }

    var availableSections: [PhysicsSection] {
        allData.sections.filter { $0.levels.contains(selectedLevel) }
    }

    var availableSubsections: [PhysicsSubsection] {
        guard let sectionId = selectedSection?.id else { return [] }
        return allData.subsections.filter { $0.sectionId == sectionId && $0.levels.contains(selectedLevel) }
    }

    var filteredFormulas: [Formula] {
        if isSearching {
            let query = searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            if query.isEmpty { return [] }
            return allData.formulas.filter { formula in
                let nameMatch = formula.localizedName.lowercased().contains(query)
                let descMatch = formula.localizedDescription.lowercased().contains(query)
                let varMatch = formula.variables.contains(where: { $0.symbol.lowercased() == query || $0.localizedName.lowercased().contains(query) })
                let subsectionMatch = allData.subsections.first(where: { $0.id == formula.subsectionId })
                    .map { $0.localizedName.lowercased().contains(query) } ?? false
                return nameMatch || descMatch || varMatch || subsectionMatch
            }
        } else {
            guard let subsectionId = selectedSubsection?.id else { return [] }
            return allData.formulas.filter { $0.subsectionId == subsectionId && $0.levels.contains(selectedLevel) }
        }
    }

    var emptyListMessage: String {
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

    // MARK: - Действия

    func resetSelection() {
        selectedSection = nil
        selectedSubsection = nil
    }

    func selectSection(_ section: PhysicsSection) {
        if selectedSection != section {
            selectedSection = section
            selectedSubsection = nil
        }
    }

    func selectSubsection(_ subsection: PhysicsSubsection) {
        selectedSubsection = subsection
    }

    func isFormulaAccessible(_ formula: Formula) -> Bool {
        return true
    }

    func levelDisplayName(_ levelKey: String) -> String {
        switch levelKey {
        case "school": return L10n.levelSchool
        case "university": return L10n.levelUniversity
        default: return levelKey
        }
    }
}
