import XCTest
import CoreData
@testable import PhysicsCalculator

// MARK: - Core Data Persistence Tests

final class CoreDataPersistenceTests: XCTestCase {
    
    var sut: PersistenceController!
    
    private let testFormula = Formula(
        id: "test_formula",
        subsectionId: "test_sub",
        name_ru: "Тестовая формула",
        name_en: "Test Formula",
        levels: ["school"],
        equation_latex: "F = m \\cdot a",
        description_ru: "Описание",
        description_en: "Description",
        variables: [
            Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
            Variable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
            Variable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
        ],
        calculation_rules: ["F": "m * a", "m": "F / a", "a": "F / m"]
    )
    
    override func setUp() {
        super.setUp()
        sut = PersistenceController(inMemory: true)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Save Calculation (Favorites)
    
    func testSaveCalculation_CreatesEntityWithIsFavoriteTrue() {
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 98.0,
            inputValues: ["m": "10", "a": "9.8"]
        )
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        let results = try? sut.viewContext.fetch(request)
        
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.formulaId, "test_formula")
        XCTAssertEqual(results?.first?.calculatedSymbol, "F")
        XCTAssertEqual(results?.first?.calculatedValue, 98.0)
        XCTAssertEqual(results?.first?.isFavorite, true)
    }
    
    func testSaveCalculation_StoresInputValuesAsJSON() {
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 98.0,
            inputValues: ["m": "10", "a": "9.8"]
        )
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        guard let saved = try? sut.viewContext.fetch(request).first else {
            XCTFail("No saved calculation found"); return
        }
        
        let decoded = sut.decodeInputValues(from: saved.inputValuesData)
        XCTAssertEqual(decoded?["m"], "10")
        XCTAssertEqual(decoded?["a"], "9.8")
    }
    
    func testSaveCalculation_StoresVariablesAsJSON() {
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 98.0,
            inputValues: ["m": "10", "a": "9.8"]
        )
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        guard let saved = try? sut.viewContext.fetch(request).first else {
            XCTFail("No saved calculation found"); return
        }
        
        let decoded = sut.decodeVariables(from: saved.variablesData)
        XCTAssertEqual(decoded?.count, 3)
        XCTAssertTrue(decoded?.contains(where: { $0.symbol == "F" }) ?? false)
    }
    
    func testSaveCalculation_SetsTimestamp() {
        let before = Date()
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 98.0,
            inputValues: ["m": "10", "a": "9.8"]
        )
        let after = Date()
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        guard let saved = try? sut.viewContext.fetch(request).first,
              let timestamp = saved.timestamp else {
            XCTFail("No saved calculation found"); return
        }
        
        XCTAssertGreaterThanOrEqual(timestamp, before)
        XCTAssertLessThanOrEqual(timestamp, after)
    }
    
    func testSaveCalculation_StoresEquationLatex() {
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 98.0,
            inputValues: ["m": "10", "a": "9.8"]
        )
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        let saved = try? sut.viewContext.fetch(request).first
        XCTAssertEqual(saved?.equationLatex, "F = m \\cdot a")
    }
    
    // MARK: - Save to History
    
    func testSaveToHistory_CreatesEntityWithIsFavoriteFalse() {
        sut.saveToHistory(
            formula: testFormula,
            calculatedSymbol: "m",
            calculatedValue: 10.0,
            inputValues: ["F": "98", "a": "9.8"]
        )
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        let results = try? sut.viewContext.fetch(request)
        
        XCTAssertEqual(results?.count, 1)
        XCTAssertEqual(results?.first?.isFavorite, false)
        XCTAssertEqual(results?.first?.calculatedSymbol, "m")
    }
    
    func testSaveToHistory_MultipleSaves() {
        for i in 1...5 {
            sut.saveToHistory(
                formula: testFormula,
                calculatedSymbol: "F",
                calculatedValue: Double(i) * 10,
                inputValues: ["m": "\(i)", "a": "10"]
            )
        }
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == NO")
        let count = try? sut.viewContext.count(for: request)
        XCTAssertEqual(count, 5)
    }
    
    // MARK: - Trim History
    
    func testTrimHistory_KeepsOnlyLast50() {
        // Save 55 history entries
        for i in 1...55 {
            sut.saveToHistory(
                formula: testFormula,
                calculatedSymbol: "F",
                calculatedValue: Double(i),
                inputValues: ["m": "1", "a": "\(i)"]
            )
        }
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == NO")
        let count = try? sut.viewContext.count(for: request)
        XCTAssertEqual(count, 50, "History should be trimmed to 50 entries")
    }
    
    func testTrimHistory_DoesNotAffectFavorites() {
        // Save 55 history entries
        for i in 1...55 {
            sut.saveToHistory(
                formula: testFormula,
                calculatedSymbol: "F",
                calculatedValue: Double(i),
                inputValues: ["m": "1", "a": "\(i)"]
            )
        }
        
        // Add a favorite
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 999.0,
            inputValues: ["m": "99", "a": "10.1"]
        )
        
        let favRequest: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        favRequest.predicate = NSPredicate(format: "isFavorite == YES")
        let favCount = try? sut.viewContext.count(for: favRequest)
        XCTAssertEqual(favCount, 1, "Favorites should not be affected by trim")
        
        let histRequest: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        histRequest.predicate = NSPredicate(format: "isFavorite == NO")
        let histCount = try? sut.viewContext.count(for: histRequest)
        XCTAssertEqual(histCount, 50)
    }
    
    func testTrimHistory_Under50DoesNotDelete() {
        for i in 1...10 {
            sut.saveToHistory(
                formula: testFormula,
                calculatedSymbol: "F",
                calculatedValue: Double(i),
                inputValues: ["m": "1", "a": "\(i)"]
            )
        }
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == NO")
        let count = try? sut.viewContext.count(for: request)
        XCTAssertEqual(count, 10, "Under 50 entries should not be trimmed")
    }
    
    // MARK: - Clear History
    
    func testClearHistory_DeletesAllNonFavorites() {
        for i in 1...5 {
            sut.saveToHistory(
                formula: testFormula,
                calculatedSymbol: "F",
                calculatedValue: Double(i),
                inputValues: ["m": "1", "a": "\(i)"]
            )
        }
        
        sut.clearHistory()
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == NO")
        let count = try? sut.viewContext.count(for: request)
        XCTAssertEqual(count, 0, "All history should be cleared")
    }
    
    func testClearHistory_PreservesFavorites() {
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 100.0,
            inputValues: ["m": "10", "a": "10"]
        )
        
        for i in 1...5 {
            sut.saveToHistory(
                formula: testFormula,
                calculatedSymbol: "F",
                calculatedValue: Double(i),
                inputValues: ["m": "1", "a": "\(i)"]
            )
        }
        
        sut.clearHistory()
        
        let favRequest: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        favRequest.predicate = NSPredicate(format: "isFavorite == YES")
        let favCount = try? sut.viewContext.count(for: favRequest)
        XCTAssertEqual(favCount, 1, "Favorites should be preserved")
    }
    
    // MARK: - Delete Calculation
    
    func testDeleteCalculation_RemovesFromStore() {
        sut.saveCalculation(
            formula: testFormula,
            calculatedSymbol: "F",
            calculatedValue: 98.0,
            inputValues: ["m": "10", "a": "9.8"]
        )
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        guard let saved = try? sut.viewContext.fetch(request).first else {
            XCTFail("Expected saved calculation"); return
        }
        
        sut.deleteCalculation(saved)
        
        let countAfter = try? sut.viewContext.count(for: request)
        XCTAssertEqual(countAfter, 0)
    }
    
    func testDeleteCalculation_OnlyDeletesTargeted() {
        sut.saveCalculation(formula: testFormula, calculatedSymbol: "F", calculatedValue: 10, inputValues: ["m": "1", "a": "10"])
        sut.saveCalculation(formula: testFormula, calculatedSymbol: "m", calculatedValue: 5, inputValues: ["F": "50", "a": "10"])
        
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: true)]
        guard let all = try? sut.viewContext.fetch(request), all.count == 2 else {
            XCTFail("Expected 2 calculations"); return
        }
        
        sut.deleteCalculation(all[0])
        
        let remaining = try? sut.viewContext.fetch(request)
        XCTAssertEqual(remaining?.count, 1)
        XCTAssertEqual(remaining?.first?.calculatedSymbol, "m")
    }
    
    // MARK: - Decode Helpers
    
    func testDecodeInputValues_NilData() {
        XCTAssertNil(sut.decodeInputValues(from: nil))
    }
    
    func testDecodeInputValues_InvalidData() {
        let invalidData = "not json".data(using: .utf8)!
        XCTAssertNil(sut.decodeInputValues(from: invalidData))
    }
    
    func testDecodeInputValues_ValidData() {
        let dict = ["m": "10", "a": "9.8"]
        let data = try! JSONEncoder().encode(dict)
        let decoded = sut.decodeInputValues(from: data)
        XCTAssertEqual(decoded, dict)
    }
    
    func testDecodeVariables_NilData() {
        XCTAssertNil(sut.decodeVariables(from: nil))
    }
    
    func testDecodeVariables_ValidData() {
        let vars = [Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н")]
        let data = try! JSONEncoder().encode(vars)
        let decoded = sut.decodeVariables(from: data)
        XCTAssertEqual(decoded?.count, 1)
        XCTAssertEqual(decoded?.first?.symbol, "F")
    }
    
    // MARK: - Multiple Operations
    
    func testFavoriteAndHistorySeparation() {
        // Save favorites and history mixed
        sut.saveCalculation(formula: testFormula, calculatedSymbol: "F", calculatedValue: 100, inputValues: ["m": "10", "a": "10"])
        sut.saveToHistory(formula: testFormula, calculatedSymbol: "F", calculatedValue: 50, inputValues: ["m": "5", "a": "10"])
        sut.saveCalculation(formula: testFormula, calculatedSymbol: "m", calculatedValue: 5, inputValues: ["F": "50", "a": "10"])
        sut.saveToHistory(formula: testFormula, calculatedSymbol: "a", calculatedValue: 10, inputValues: ["F": "50", "m": "5"])
        
        let favRequest: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        favRequest.predicate = NSPredicate(format: "isFavorite == YES")
        let favCount = try? sut.viewContext.count(for: favRequest)
        XCTAssertEqual(favCount, 2)
        
        let histRequest: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        histRequest.predicate = NSPredicate(format: "isFavorite == NO")
        let histCount = try? sut.viewContext.count(for: histRequest)
        XCTAssertEqual(histCount, 2)
    }
    
    func testSaveContext_NoChanges_NoError() {
        // Should not crash when saving with no changes
        sut.saveContext()
    }
    
    func testInMemoryStore_DataNotPersistedAcrossInstances() {
        sut.saveCalculation(formula: testFormula, calculatedSymbol: "F", calculatedValue: 98.0, inputValues: ["m": "10", "a": "9.8"])
        
        let newController = PersistenceController(inMemory: true)
        let request: NSFetchRequest<SavedCalculation> = SavedCalculation.fetchRequest()
        let count = try? newController.viewContext.count(for: request)
        XCTAssertEqual(count, 0, "In-memory store should not persist data across instances")
    }
}
