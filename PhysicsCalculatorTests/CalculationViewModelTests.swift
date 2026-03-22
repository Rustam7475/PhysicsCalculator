import XCTest
@testable import PhysicsCalculator

final class CalculationViewModelTests: XCTestCase {
    
    // MARK: - Мок-сервис для тестов
    
    class MockCalculationService: CalculationServiceProtocol {
        var shouldThrowError = false
        var lastRule: String?
        var lastVariables: [String: Double]?
        var mockResult: Double = 42.0
        
        func calculate(rule: String, variables: [String: Double]) throws -> Double {
            lastRule = rule
            lastVariables = variables
            if shouldThrowError {
                throw CalculationError.invalidResult
            }
            return mockResult
        }
        
        func validateInput(_ input: String) -> Bool {
            let cleaned = input.replacingOccurrences(of: ",", with: ".")
            return Double(cleaned) != nil
        }
        
        func formatResult(_ result: Double) -> String {
            String(format: "%.4g", result)
        }
    }
    
    // MARK: - Тестовые данные
    
    let testFormula = Formula(
        id: "test_velocity",
        subsectionId: "kinematics",
        name_ru: "Скорость",
        name_en: "Velocity",
        levels: ["school"],
        equation_latex: "v = \\frac{s}{t}",
        description_ru: "Скорость — отношение пути ко времени",
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
    
    // MARK: - Тесты выбора неизвестной переменной
    
    @MainActor
    func testSelectUnknown_SetsSymbol() {
        let mockService = MockCalculationService()
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        
        vm.selectUnknown(symbol: "v")
        
        XCTAssertEqual(vm.selectedUnknownSymbol, "v")
    }
    
    @MainActor
    func testSelectUnknown_ToggleDeselectsSameSymbol() {
        let mockService = MockCalculationService()
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        
        vm.selectUnknown(symbol: "v")
        vm.selectUnknown(symbol: "v")
        
        XCTAssertNil(vm.selectedUnknownSymbol)
    }
    
    @MainActor
    func testSelectUnknown_SwitchesToNewSymbol() {
        let mockService = MockCalculationService()
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        
        vm.selectUnknown(symbol: "v")
        vm.selectUnknown(symbol: "s")
        
        XCTAssertEqual(vm.selectedUnknownSymbol, "s")
    }
    
    @MainActor
    func testSelectUnknown_ClearsResultAndError() {
        let mockService = MockCalculationService()
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        vm.calculatedResult = 42.0
        vm.errorMessage = "Some error"
        
        vm.selectUnknown(symbol: "v")
        
        XCTAssertNil(vm.calculatedResult)
        XCTAssertNil(vm.errorMessage)
    }
    
    // MARK: - Тесты canCalculate
    
    @MainActor
    func testCanCalculate_FalseWhenNoUnknown() {
        let vm = CalculationViewModel(formula: testFormula)
        
        XCTAssertFalse(vm.canCalculate)
    }
    
    @MainActor
    func testCanCalculate_FalseWhenInputsMissing() {
        let vm = CalculationViewModel(formula: testFormula)
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "100", "t": ""]
        
        XCTAssertFalse(vm.canCalculate)
    }
    
    @MainActor
    func testCanCalculate_TrueWhenAllInputsFilled() {
        let vm = CalculationViewModel(formula: testFormula)
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "100", "t": "5"]
        
        XCTAssertTrue(vm.canCalculate)
    }
    
    // MARK: - Тесты calculate
    
    @MainActor
    func testCalculate_SuccessfulCalculation() {
        let mockService = MockCalculationService()
        mockService.mockResult = 20.0
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "100", "t": "5"]
        
        vm.calculate()
        
        XCTAssertEqual(vm.calculatedResult, 20.0)
        XCTAssertTrue(vm.showingResult)
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(mockService.lastRule, "s / t")
    }
    
    @MainActor
    func testCalculate_ErrorWhenNoUnknown() {
        let vm = CalculationViewModel(formula: testFormula)
        
        vm.calculate()
        
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertNil(vm.calculatedResult)
    }
    
    @MainActor
    func testCalculate_ErrorWhenInvalidInput() {
        let vm = CalculationViewModel(formula: testFormula)
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "abc", "t": "5"]
        
        vm.calculate()
        
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertNil(vm.calculatedResult)
    }
    
    @MainActor
    func testCalculate_ErrorWhenServiceThrows() {
        let mockService = MockCalculationService()
        mockService.shouldThrowError = true
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "100", "t": "5"]
        
        vm.calculate()
        
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertNil(vm.calculatedResult)
        XCTAssertFalse(vm.showingResult)
    }
    
    @MainActor
    func testCalculate_HandlesCommaAsDecimalSeparator() {
        let mockService = MockCalculationService()
        mockService.mockResult = 50.0
        let vm = CalculationViewModel(formula: testFormula, calculationService: mockService)
        
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "100,5", "t": "2"]
        
        vm.calculate()
        
        XCTAssertEqual(vm.calculatedResult, 50.0)
        XCTAssertEqual(mockService.lastVariables?["s"], 100.5)
    }
    
    // MARK: - Тесты reset
    
    @MainActor
    func testReset_ClearsAllState() {
        let vm = CalculationViewModel(formula: testFormula)
        vm.selectedUnknownSymbol = "v"
        vm.inputValues = ["s": "100", "t": "5"]
        vm.calculatedResult = 20.0
        vm.errorMessage = "Error"
        vm.showingResult = true
        
        vm.reset()
        
        XCTAssertTrue(vm.inputValues.isEmpty)
        XCTAssertNil(vm.selectedUnknownSymbol)
        XCTAssertNil(vm.calculatedResult)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.showingResult)
    }
}
