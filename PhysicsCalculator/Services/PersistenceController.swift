import CoreData

struct PersistenceController {
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
                print("Core Data ошибка загрузки: \(error), \(error.userInfo)")
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
                print("Core Data ошибка сохранения: \(error)")
            }
        }
    }

    // --- Добавим методы для работы с SavedCalculation ---

    // Сохранение нового расчета
    func saveCalculation(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String]) {
        let context = viewContext
        let newCalculation = SavedCalculation(context: context) // Создаем новый объект

        newCalculation.formulaId = formula.id
        newCalculation.formulaName = formula.localizedName // Сохраняем текущее локализованное имя
        newCalculation.equationLatex = formula.equation_latex
        newCalculation.calculatedSymbol = calculatedSymbol
        newCalculation.calculatedValue = calculatedValue
        newCalculation.timestamp = Date() // Текущее время

        // Кодируем словари/массивы в Data
        if let inputData = try? JSONEncoder().encode(inputValues) {
            newCalculation.inputValuesData = inputData
        }
        if let variablesData = try? JSONEncoder().encode(formula.variables) {
            newCalculation.variablesData = variablesData
        }

        saveContext() // Сохраняем изменения
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
