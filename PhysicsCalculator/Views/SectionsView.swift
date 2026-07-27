import SwiftUI
import CoreData
import Foundation

struct SectionsView: View {
    @StateObject private var viewModel: SectionsViewModel
    @EnvironmentObject private var settings: AppSettings
    @FocusState private var isSearchFocused: Bool

    init(allData: PhysicsData) {
        _viewModel = StateObject(wrappedValue: SectionsViewModel(allData: allData))
    }

    var body: some View {
        VStack(spacing: 12) {
            // Поиск
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField(L10n.searchPlaceholder, text: $viewModel.searchText)
                        .focused($isSearchFocused)
                        .autocorrectionDisabled()
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
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
                        viewModel.searchText = ""
                        isSearchFocused = false
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isSearchFocused)

            // Picker уровня
            HStack(spacing: 8) {
                ForEach(viewModel.levels, id: \.self) { level in
                    Button {
                        viewModel.selectedLevel = level
                    } label: {
                        Text(viewModel.levelDisplayName(level))
                            .font(.subheadline.weight(viewModel.selectedLevel == level ? .semibold : .regular))
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(viewModel.selectedLevel == level ? Color.accentColor : Color(.secondarySystemBackground))
                            .foregroundColor(viewModel.selectedLevel == level ? .white : .primary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.bottom, 4)
            .onAppear {
                viewModel.resetSelection()
            }
            .onChange(of: viewModel.selectedLevel) { _ in
                viewModel.resetSelection()
            }

            if !viewModel.isSearching {
                // Меню Разделов
                Menu {
                     Button(L10n.reset, role: .destructive) { viewModel.resetSelection() }
                     ForEach(viewModel.availableSections) { section in
                         Button(section.localizedName) {
                             viewModel.selectSection(section)
                         }
                     }
                 } label: {
                     HStack {
                         Image(systemName: "folder")
                             .foregroundColor(.accentColor)
                         Text(viewModel.selectedSection?.localizedName ?? L10n.selectSection)
                             .foregroundColor(viewModel.selectedSection != nil ? .primary : .secondary)
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
                .disabled(viewModel.availableSections.isEmpty)
                .id("section_menu_" + settings.currentLanguageCode)

                // Меню Подразделов
                Menu {
                     Button(L10n.reset, role: .destructive) { viewModel.selectedSubsection = nil }
                     ForEach(viewModel.availableSubsections) { subsection in
                         Button(subsection.localizedName) { viewModel.selectSubsection(subsection) }
                     }
                 } label: {
                     HStack {
                         Image(systemName: "doc.text")
                             .foregroundColor(.accentColor)
                         Text(viewModel.selectedSubsection?.localizedName ?? L10n.selectSubsection)
                             .foregroundColor(viewModel.selectedSubsection != nil ? .primary : .secondary)
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
                .disabled(viewModel.selectedSection == nil || viewModel.availableSubsections.isEmpty)
                .id("subsection_menu_" + settings.currentLanguageCode)
            }

            // Список Формул
            List {
                if !viewModel.filteredFormulas.isEmpty && viewModel.isSearching {
                    Text(L10n.searchResults)
                        .font(.headline)
                        .padding(.vertical, 4)
                        .listRowBackground(Color.clear)
                }

                if viewModel.filteredFormulas.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: viewModel.isSearching ? "magnifyingglass" : "atom")
                            .font(.system(size: 44))
                            .foregroundColor(.secondary)
                        Text(viewModel.emptyListMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.filteredFormulas) { formula in
                        NavigationLink(destination: CalculationView(formula: formula)) {
                            HStack(spacing: 12) {
                                Image(systemName: "function")
                                    .font(.system(size: 14))
                                    .foregroundColor(.accentColor)
                                    .frame(width: 28, height: 28)
                                    .background(Color.accentColor.opacity(0.12))
                                    .cornerRadius(6)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(formula.localizedName)
                                        .font(.body)
                                    if viewModel.isSearching {
                                        if let subsection = viewModel.allData.subsections.first(where: { $0.id == formula.subsectionId }) {
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
                            }
                            .padding(.vertical, 4)
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
    }

}

// --- Предпросмотр ---
#Preview {
    if let previewData = DataLoader.loadPhysicsData() {
        SectionsView(allData: previewData)
            .environment(\.managedObjectContext, PersistenceController(inMemory: true).container.viewContext)
    } else {
        Text("Ошибка загрузки данных для превью")
    }
}
