import XCTest
@testable import PhysicsCalculator

final class CalculationServiceTests: XCTestCase {
    
    var sut: CalculationService!
    
    override func setUp() {
        super.setUp()
        sut = CalculationService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Тесты вычислений
    
    func testSimpleAddition() throws {
        let result = try sut.calculate(rule: "a + b", variables: ["a": 2, "b": 3])
        XCTAssertEqual(result, 5.0, accuracy: 0.001)
    }
    
    func testSimpleSubtraction() throws {
        let result = try sut.calculate(rule: "a - b", variables: ["a": 10, "b": 3])
        XCTAssertEqual(result, 7.0, accuracy: 0.001)
    }
    
    func testMultiplication() throws {
        let result = try sut.calculate(rule: "m * a", variables: ["m": 10, "a": 9.8])
        XCTAssertEqual(result, 98.0, accuracy: 0.001)
    }
    
    func testDivision() throws {
        let result = try sut.calculate(rule: "s / t", variables: ["s": 100, "t": 10])
        XCTAssertEqual(result, 10.0, accuracy: 0.001)
    }
    
    func testDivisionByZeroThrowsError() {
        XCTAssertThrowsError(try sut.calculate(rule: "s / t", variables: ["s": 100, "t": 0])) { error in
            guard let calcError = error as? CalculationError else {
                XCTFail("Expected CalculationError, got \(error)")
                return
            }
            if case .invalidResult = calcError {
                // Ожидаемая ошибка
            } else {
                XCTFail("Expected .invalidResult, got \(calcError)")
            }
        }
    }
    
    // MARK: - Тесты физических формул
    
    func testNewtonSecondLaw() throws {
        // F = m * a
        let result = try sut.calculate(rule: "m * a", variables: ["m": 5.0, "a": 3.0])
        XCTAssertEqual(result, 15.0, accuracy: 0.001)
    }
    
    func testVelocityCalculation() throws {
        // v = s / t
        let result = try sut.calculate(rule: "s / t", variables: ["s": 150.0, "t": 3.0])
        XCTAssertEqual(result, 50.0, accuracy: 0.001)
    }
    
    func testDistanceCalculation() throws {
        // s = v * t
        let result = try sut.calculate(rule: "v * t", variables: ["v": 60.0, "t": 2.5])
        XCTAssertEqual(result, 150.0, accuracy: 0.001)
    }
    
    func testKineticEnergy() throws {
        // E = 0.5 * m * v * v
        let result = try sut.calculate(rule: "0.5 * m * v * v", variables: ["m": 2.0, "v": 3.0])
        XCTAssertEqual(result, 9.0, accuracy: 0.001)
    }
    
    func testAcceleration() throws {
        // a = (v - u) / t
        let result = try sut.calculate(rule: "(v - u) / t", variables: ["v": 20.0, "u": 5.0, "t": 3.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.001)
    }
    
    // MARK: - Тесты валидации ввода
    
    func testValidateInput_ValidInteger() {
        XCTAssertTrue(sut.validateInput("123"))
    }
    
    func testValidateInput_ValidDecimalWithDot() {
        XCTAssertTrue(sut.validateInput("123.45"))
    }
    
    func testValidateInput_ValidDecimalWithComma() {
        XCTAssertTrue(sut.validateInput("123,45"))
    }
    
    func testValidateInput_ValidNegativeNumber() {
        XCTAssertTrue(sut.validateInput("-5.3"))
    }
    
    func testValidateInput_InvalidText() {
        XCTAssertFalse(sut.validateInput("abc"))
    }
    
    func testValidateInput_EmptyString() {
        XCTAssertFalse(sut.validateInput(""))
    }
    
    func testValidateInput_WhitespaceOnly() {
        XCTAssertFalse(sut.validateInput("   "))
    }
    
    func testValidateInput_ValidWithSpaces() {
        XCTAssertTrue(sut.validateInput(" 42 "))
    }
    
    // MARK: - Тесты форматирования
    
    func testFormatResult_Integer() {
        XCTAssertEqual(sut.formatResult(100.0), "100")
    }
    
    func testFormatResult_SmallDecimal() {
        XCTAssertEqual(sut.formatResult(0.001234), "0.001234")
    }
    
    func testFormatResult_LargeNumber() {
        let formatted = sut.formatResult(123456.789)
        XCTAssertFalse(formatted.isEmpty)
    }
}
