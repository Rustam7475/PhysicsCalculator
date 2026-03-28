import CoreData
import os

private let logger = Logger(subsystem: AppConfiguration.appName, category: "CoreData")

// MARK: - Протокол для тестируемости
protocol PersistenceControllerProtocol {
    func saveToHistory(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String])
}

struct PersistenceController: PersistenceControllerProtocol {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: AppConfiguration.databaseName)

        if inMemory {
            if let description = container.persistentStoreDescriptions.first {
                description.url = URL(fileURLWithPath: "/dev/null")
            }
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                logger.error("Core Data ошибка загрузки: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // Удобный доступ к контексту для основного потока
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    // Функция для сохранения изменений
    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                logger.error("Core Data ошибка сохранения: \(error.localizedDescription)")
            }
        }
    }

    // --- Добавим методы для работы с SavedCalculation ---

    // Сохранение нового расчета (в избранное)
    func saveCalculation(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String]) {
        let context = viewContext
        let newCalculation = SavedCalculation(context: context)

        newCalculation.formulaId = formula.id
        newCalculation.formulaName = formula.localizedName
        newCalculation.equationLatex = formula.equation_latex
        newCalculation.calculatedSymbol = calculatedSymbol
        newCalculation.calculatedValue = calculatedValue
        newCalculation.timestamp = Date()
        newCalculation.isFavorite = true

        if let inputData = try? JSONEncoder().encode(inputValues) {
            newCalculation.inputValuesData = inputData
        }
        if let variablesData = try? JSONEncoder().encode(formula.variables) {
            newCalculation.variablesData = variablesData
        }

        saveContext()
    }

    // Сохранение в историю (автоматически при каждом расчёте)
    func saveToHistory(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String]) {
        let context = viewContext
        let newCalculation = SavedCalculation(context: context)

        newCalculation.formulaId = formula.id
        newCalculation.formulaName = formula.localizedName
        newCalculation.equationLatex = formula.equation_latex
        newCalculation.calculatedSymbol = calculatedSymbol
        newCalculation.calculatedValue = calculatedValue
        newCalculation.timestamp = Date()
        newCalculation.isFavorite = false

        if let inputData = try? JSONEncoder().encode(inputValues) {
            newCalculation.inputValuesData = inputData
        }
        if let variablesData = try? JSONEncoder().encode(formula.variables) {
            newCalculation.variablesData = variablesData
        }

        saveContext()
        trimHistory()
    }

    // Оставляем только последние 50 записей истории
    private func trimHistory() {
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == NO")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: false)]
        
        guard let all = try? viewContext.fetch(request), all.count > 50 else { return }
        for item in all.dropFirst(50) {
            viewContext.delete(item)
        }
        saveContext()
    }

    // Очистка всей истории
    func clearHistory() {
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == NO")
        guard let items = try? viewContext.fetch(request) else { return }
        for item in items {
            viewContext.delete(item)
        }
        saveContext()
    }

    // Удаление расчета
    func deleteCalculation(_ calculation: SavedCalculation) {
        let context = viewContext
        context.delete(calculation)
        saveContext()
    }

     // --- Вспомогательные функции для декодирования Data ---
     // (Можно вынести их в расширение для SavedCalculation)

     func decodeInputValues(from data: Data?) -> [String: String]? {
         guard let data = data else { return nil }
         return try? JSONDecoder().decode([String: String].self, from: data)
     }

     func decodeVariables(from data: Data?) -> [Variable]? {
         guard let data = data else { return nil }
         return try? JSONDecoder().decode([Variable].self, from: data)
     }
}

// Добавим расширение для удобного доступа к декодированным данным
extension SavedCalculation {
    var inputValues: [String: String]? {
        PersistenceController.shared.decodeInputValues(from: inputValuesData)
    }
    var formulaVariables: [Variable]? {
         PersistenceController.shared.decodeVariables(from: variablesData)
     }
}
