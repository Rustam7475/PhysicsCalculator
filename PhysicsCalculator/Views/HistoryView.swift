import SwiftUI
import CoreData

struct HistoryView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: false)],
        predicate: NSPredicate(format: "isFavorite == NO"),
        animation: .default)
    private var historyItems: FetchedResults<SavedCalculation>

    @State private var showClearConfirmation = false
    @State private var searchText = ""

    private var filteredItems: [SavedCalculation] {
        if searchText.isEmpty { return Array(historyItems) }
        let query = searchText.lowercased()
        return historyItems.filter {
            ($0.formulaName ?? "").lowercased().contains(query) ||
            ($0.calculatedSymbol ?? "").lowercased().contains(query)
        }
    }

    private var groupedItems: [(title: String, items: [SavedCalculation])] {
        let calendar = Calendar.current
        let now = Date()
        var today: [SavedCalculation] = []
        var yesterday: [SavedCalculation] = []
        var thisWeek: [SavedCalculation] = []
        var thisMonth: [SavedCalculation] = []
        var earlier: [SavedCalculation] = []

        for item in filteredItems {
            let date = item.timestamp ?? Date.distantPast
            if calendar.isDateInToday(date) {
                today.append(item)
            } else if calendar.isDateInYesterday(date) {
                yesterday.append(item)
            } else if calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear) {
                thisWeek.append(item)
            } else if calendar.isDate(date, equalTo: now, toGranularity: .month) {
                thisMonth.append(item)
            } else {
                earlier.append(item)
            }
        }

        var groups: [(title: String, items: [SavedCalculation])] = []
        if !today.isEmpty { groups.append((L10n.historyToday, today)) }
        if !yesterday.isEmpty { groups.append((L10n.historyYesterday, yesterday)) }
        if !thisWeek.isEmpty { groups.append((L10n.historyThisWeek, thisWeek)) }
        if !thisMonth.isEmpty { groups.append((L10n.historyThisMonth, thisMonth)) }
        if !earlier.isEmpty { groups.append((L10n.historyEarlier, earlier)) }
        return groups
    }

    var body: some View {
        VStack(spacing: 0) {
            if historyItems.isEmpty {
                emptyState
            } else {
                searchBar
                historyList
            }
        }
        .navigationTitle(L10n.historyTitle)
        .oledBackground()
        .toolbar {
            if !historyItems.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(role: .destructive) {
                        showClearConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .alert(L10n.clearHistoryTitle, isPresented: $showClearConfirmation) {
            Button(L10n.clear, role: .destructive) {
                withAnimation {
                    PersistenceController.shared.clearHistory()
                }
            }
            Button(L10n.cancel, role: .cancel) {}
        } message: {
            Text(L10n.clearHistoryMessage)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text(L10n.historyEmpty)
                .font(.title3)
                .foregroundColor(.secondary)
            Text(L10n.historyHint)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(L10n.historySearch, text: $searchText)
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
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .padding(.top, 4)
        .padding(.bottom, 8)
    }

    // MARK: - History List

    private var historyList: some View {
        List {
            ForEach(groupedItems, id: \.title) { group in
                Section {
                    ForEach(group.items) { item in
                        NavigationLink(destination: CalculationDetailView(savedCalculation: item)) {
                            HistoryRow(item: item)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                withAnimation {
                                    PersistenceController.shared.deleteCalculation(item)
                                }
                            } label: {
                                Label(L10n.delete, systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                withAnimation {
                                    item.isFavorite = true
                                    PersistenceController.shared.saveContext()
                                }
                            } label: {
                                Label(L10n.addToFavorites, systemImage: "star.fill")
                            }
                            .tint(.yellow)
                        }
                    }
                } header: {
                    Text(group.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.secondary)
                        .textCase(nil)
                }
            }
        }
        .listStyle(.plain)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { historyItems[$0] }.forEach(PersistenceController.shared.deleteCalculation)
        }
    }
}

// MARK: - History Row

struct HistoryRow: View {
    @ObservedObject var item: SavedCalculation

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    private var sectionName: String? {
        guard let formulaId = item.formulaId,
              let data = loadPhysicsData() else { return nil }
        guard let formula = data.formulas.first(where: { $0.id == formulaId }),
              let subsection = data.subsections.first(where: { $0.id == formula.subsectionId })
        else { return nil }
        return subsection.localizedName
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "clock")
                .font(.system(size: 14))
                .foregroundColor(.orange)
                .frame(width: 32, height: 32)
                .background(Color.orange.opacity(0.12))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.formulaName ?? L10n.noName)
                    .font(.body.weight(.medium))
                    .lineLimit(1)
                HStack(spacing: 6) {
                    Text("\(item.calculatedSymbol ?? "?") = \(String(format: "%.4g", item.calculatedValue))")
                        .font(.subheadline)
                        .foregroundColor(.orange)
                    if let section = sectionName {
                        Text("·")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(section)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer()
            Text(item.timestamp ?? Date(), formatter: Self.timeFormatter)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
