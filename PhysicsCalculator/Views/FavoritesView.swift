import SwiftUI
import CoreData

struct FavoritesView: View {
    // Доступ к контексту Core Data
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    // Запрос для получения ВСЕХ сохраненных расчетов,
    // отсортированных по убыванию даты (сначала новые)
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: false)],
        animation: .default) // Используем анимацию по умолчанию для добавления/удаления
    private var savedItems: FetchedResults<SavedCalculation>

    var body: some View {
        VStack {
            if savedItems.isEmpty {
                // Отображаем сообщение, если избранного нет
                Text("Нет сохраненных расчетов.")
                    .foregroundColor(.secondary)
                    .padding()
                Spacer() // Занимает оставшееся место
            } else {
                // Список сохраненных расчетов
                List {
                    ForEach(savedItems) { item in
                        // Оборачиваем в NavigationLink для перехода к деталям
                        NavigationLink(destination: CalculationDetailView(savedCalculation: item)) {
                            FavoriteRow(item: item) // Используем вспомогательное View для строки
                        }
                    }
                    .onDelete(perform: deleteItems) // Добавляем возможность удаления свайпом
                }
                .listStyle(.plain) // Убираем стиль по умолчанию для List
            }
        }
        .navigationTitle("Избранное")
    }

    // Функция для удаления элементов
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // Получаем объекты для удаления по индексам из FetchRequest
            offsets.map { savedItems[$0] }.forEach(PersistenceController.shared.deleteCalculation)
            // Сохранение контекста происходит внутри deleteCalculation в PersistenceController
        }
    }
} // Конец struct FavoritesView

// --- Вспомогательное View для отображения одной строки в списке избранного ---
struct FavoriteRow: View {
    @ObservedObject var item: SavedCalculation // Используем @ObservedObject для обновления

    // Форматтер для даты
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.formulaName ?? "Без имени") // Название формулы
                    .font(.headline)
                // Отображаем основной результат
                // Убедимся, что calculatedSymbol не nil перед использованием
                Text("\(item.calculatedSymbol ?? "?") = \(String(format: "%.4g", item.calculatedValue))")
                    .font(.subheadline)
            }
            Spacer() // Отодвигает дату вправо
            // Отображаем дату сохранения
            // Убедимся, что timestamp не nil перед использованием
            Text(item.timestamp ?? Date(), formatter: Self.dateFormatter)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4) // Небольшой вертикальный отступ
    }
} // Конец struct FavoriteRow


// --- Предпросмотр для FavoritesView ---
#Preview {
    // Создаем моковый контекст с несколькими записями для превью
    let controller = PersistenceController(inMemory: true)
    let context = controller.container.viewContext

    // Добавим пару примеров
    // Нужна структура Formula, определенная в PhysicsModels.swift
    // Создадим временные моки, если файл недоступен здесь
    // ВАЖНО: Убедитесь, что структуры Variable/Formula для превью соответствуют реальным
     struct MockVariable: Codable, Identifiable, Hashable { var id: String { symbol }; let symbol: String; let name_ru: String; let name_en: String; let unit_si: String; var localizedName: String { name_ru }}
     struct MockFormula: Codable, Identifiable, Hashable { var id: String; let subsectionId: String; let name_ru: String; let name_en: String; let levels: [String]; let equation_latex: String; let description_ru: String; let description_en: String; let variables: [MockVariable]; let calculation_rules: [String: String]; var localizedName: String { name_ru } }


     let mockVars1 = [ MockVariable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"), MockVariable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"), MockVariable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")]
     let mockFormula1 = MockFormula(id: "f1", subsectionId: "s1", name_ru: "Формула 1 (Ньютон)", name_en: "F1", levels: ["s"], equation_latex: "F=ma", description_ru: "", description_en: "", variables: mockVars1, calculation_rules: [:])

     let mockVars2 = [ MockVariable(symbol: "v", name_ru: "Скорость", name_en: "V", unit_si: "м/с"), MockVariable(symbol: "s", name_ru: "Путь", name_en: "S", unit_si: "м"), MockVariable(symbol: "t", name_ru: "Время", name_en: "T", unit_si: "с")]
     let mockFormula2 = MockFormula(id: "f2", subsectionId: "s2", name_ru: "Формула 2 (Скорость)", name_en: "F2", levels: ["s"], equation_latex: "v=s/t", description_ru: "", description_en: "", variables: mockVars2, calculation_rules: [:])


     // Создаем и сохраняем моковые SavedCalculation
     let newCalc1 = SavedCalculation(context: context)
     newCalc1.formulaId = mockFormula1.id
     newCalc1.formulaName = mockFormula1.localizedName
     newCalc1.equationLatex = mockFormula1.equation_latex
     newCalc1.calculatedSymbol = "F"
     newCalc1.calculatedValue = 10.5
     newCalc1.timestamp = Date().addingTimeInterval(-600) // 10 минут назад
     newCalc1.inputValuesData = try? JSONEncoder().encode(["m": "5", "a": "2.1"])
     newCalc1.variablesData = try? JSONEncoder().encode(mockVars1)

     let newCalc2 = SavedCalculation(context: context)
     newCalc2.formulaId = mockFormula2.id
     newCalc2.formulaName = mockFormula2.localizedName
     newCalc2.equationLatex = mockFormula2.equation_latex
     newCalc2.calculatedSymbol = "v"
     newCalc2.calculatedValue = 99
     newCalc2.timestamp = Date() // Сейчас
     newCalc2.inputValuesData = try? JSONEncoder().encode(["s": "198", "t": "2"])
     newCalc2.variablesData = try? JSONEncoder().encode(mockVars2)

    do {
        try context.save()
    } catch {
        // Обработка ошибки сохранения для превью
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)") // Прерываем выполнение превью при ошибке
    }

    // Возвращаем FavoritesView с предзаполненным контекстом
    return FavoritesView()
        .environment(\.managedObjectContext, context) // Передаем контекст в окружение
}
