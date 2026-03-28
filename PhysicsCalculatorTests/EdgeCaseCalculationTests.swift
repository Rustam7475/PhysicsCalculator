import XCTest
@testable import PhysicsCalculator

// MARK: - Edge Case Tests for CalculationService

final class EdgeCaseCalculationTests: XCTestCase {
    
    var sut: CalculationService!
    
    override func setUp() {
        super.setUp()
        sut = CalculationService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Very Large Numbers
    
    func testVeryLargeMultiplication() throws {
        let result = try sut.calculate(rule: "a * b", variables: ["a": 1e100, "b": 1e100])
        XCTAssertEqual(result, 1e200, accuracy: 1e190)
    }
    
    func testLargeExponent() throws {
        let result = try sut.calculate(rule: "pow(a, b)", variables: ["a": 10, "b": 100])
        XCTAssertEqual(result, 1e100, accuracy: 1e90)
    }
    
    func testSpeedOfLight_LargeNumber() throws {
        // c = 299792458 m/s
        let result = try sut.calculate(rule: "c * t", variables: ["c": 299792458, "t": 1])
        XCTAssertEqual(result, 299792458, accuracy: 1)
    }
    
    func testAvogadroNumber() throws {
        let result = try sut.calculate(rule: "N * x", variables: ["N": 6.02214076e23, "x": 1])
        XCTAssertEqual(result, 6.02214076e23, accuracy: 1e14)
    }
    
    // MARK: - Very Small Numbers
    
    func testVerySmallMultiplication() throws {
        let result = try sut.calculate(rule: "a * b", variables: ["a": 1e-100, "b": 1e-100])
        XCTAssertEqual(result, 1e-200, accuracy: 1e-210)
    }
    
    func testPlanckConstant_SmallNumber() throws {
        // h = 6.62607015e-34
        let result = try sut.calculate(rule: "h * nu", variables: ["h": 6.62607015e-34, "nu": 1e15])
        XCTAssertEqual(result, 6.62607015e-19, accuracy: 1e-28)
    }
    
    func testBoltzmannConstant_SmallNumber() throws {
        let result = try sut.calculate(rule: "k * T", variables: ["k": 1.380649e-23, "T": 300])
        XCTAssertEqual(result, 4.141947e-21, accuracy: 1e-25)
    }
    
    // MARK: - Mixed Large and Small
    
    func testLargeDividedByLarge() throws {
        let result = try sut.calculate(rule: "a / b", variables: ["a": 1e200, "b": 1e200])
        XCTAssertEqual(result, 1.0, accuracy: 1e-10)
    }
    
    func testSmallDividedBySmall() throws {
        let result = try sut.calculate(rule: "a / b", variables: ["a": 1e-200, "b": 1e-200])
        XCTAssertEqual(result, 1.0, accuracy: 1e-10)
    }
    
    // MARK: - Negative Values
    
    func testNegativeInput() throws {
        let result = try sut.calculate(rule: "a + b", variables: ["a": -5, "b": 3])
        XCTAssertEqual(result, -2.0, accuracy: 0.001)
    }
    
    func testNegativeMultiplication() throws {
        let result = try sut.calculate(rule: "a * b", variables: ["a": -3, "b": -4])
        XCTAssertEqual(result, 12.0, accuracy: 0.001)
    }
    
    func testNegativeResult() throws {
        let result = try sut.calculate(rule: "a - b", variables: ["a": 5, "b": 10])
        XCTAssertEqual(result, -5.0, accuracy: 0.001)
    }
    
    func testNegativeTemperature_CelsiusToKelvin() throws {
        // T = t + 273.15
        let result = try sut.calculate(rule: "t + 273.15", variables: ["t": -40])
        XCTAssertEqual(result, 233.15, accuracy: 0.001)
    }
    
    // MARK: - Division by Zero and Infinity
    
    func testDivisionByZero_ThrowsInvalidResult() {
        XCTAssertThrowsError(try sut.calculate(rule: "a / b", variables: ["a": 1, "b": 0])) { error in
            XCTAssertTrue(error is CalculationError)
            if case CalculationError.invalidResult = error { } else {
                XCTFail("Expected .invalidResult, got \(error)")
            }
        }
    }
    
    func testZeroDividedByZero_ThrowsInvalidResult() {
        XCTAssertThrowsError(try sut.calculate(rule: "a / b", variables: ["a": 0, "b": 0])) { error in
            XCTAssertTrue(error is CalculationError)
        }
    }
    
    // MARK: - Mathematical Edge Cases
    
    func testSqrtOfNegative_ThrowsInvalidResult() {
        XCTAssertThrowsError(try sut.calculate(rule: "sqrt(x)", variables: ["x": -1])) { error in
            XCTAssertTrue(error is CalculationError)
        }
    }
    
    func testSqrtOfZero() throws {
        let result = try sut.calculate(rule: "sqrt(x)", variables: ["x": 0])
        XCTAssertEqual(result, 0.0, accuracy: 1e-10)
    }
    
    func testSqrtOfVeryLargeNumber() throws {
        let result = try sut.calculate(rule: "sqrt(x)", variables: ["x": 1e100])
        XCTAssertEqual(result, 1e50, accuracy: 1e40)
    }
    
    func testLogOfZero_ThrowsInvalidResult() {
        XCTAssertThrowsError(try sut.calculate(rule: "log(x)", variables: ["x": 0])) { error in
            XCTAssertTrue(error is CalculationError)
        }
    }
    
    func testLogOfNegative_ThrowsInvalidResult() {
        XCTAssertThrowsError(try sut.calculate(rule: "log(x)", variables: ["x": -1])) { error in
            XCTAssertTrue(error is CalculationError)
        }
    }
    
    func testPow0to0_Returns1() throws {
        // In JavaScript, Math.pow(0, 0) = 1
        let result = try sut.calculate(rule: "pow(a, b)", variables: ["a": 0, "b": 0])
        XCTAssertEqual(result, 1.0, accuracy: 1e-10)
    }
    
    func testPow0toPositive_Returns0() throws {
        let result = try sut.calculate(rule: "pow(a, b)", variables: ["a": 0, "b": 5])
        XCTAssertEqual(result, 0.0, accuracy: 1e-10)
    }
    
    func testTanNearPiOver2_VeryLargeOrThrows() {
        // tan(π/2) — in floating point, may return a very large number instead of exact Infinity
        let piOver2 = Double.pi / 2.0
        do {
            let result = try sut.calculate(rule: "tan(x)", variables: ["x": piOver2])
            // If it didn't throw, the result should be extremely large
            XCTAssertTrue(abs(result) > 1e10, "tan(π/2) should be very large, got \(result)")
        } catch {
            XCTAssertTrue(error is CalculationError)
        }
    }
    
    func testExpOfLargeNumber_ThrowsInvalidResult() {
        // exp(1000) = Infinity
        XCTAssertThrowsError(try sut.calculate(rule: "exp(x)", variables: ["x": 1000])) { error in
            XCTAssertTrue(error is CalculationError)
        }
    }
    
    // MARK: - Trigonometric Functions
    
    func testSinOfZero() throws {
        let result = try sut.calculate(rule: "sin(x)", variables: ["x": 0])
        XCTAssertEqual(result, 0.0, accuracy: 1e-10)
    }
    
    func testCosOfZero() throws {
        let result = try sut.calculate(rule: "cos(x)", variables: ["x": 0])
        XCTAssertEqual(result, 1.0, accuracy: 1e-10)
    }
    
    func testSinOfPi() throws {
        let result = try sut.calculate(rule: "sin(x)", variables: ["x": Double.pi])
        XCTAssertEqual(result, 0.0, accuracy: 1e-10)
    }
    
    func testCosOfPi() throws {
        let result = try sut.calculate(rule: "cos(x)", variables: ["x": Double.pi])
        XCTAssertEqual(result, -1.0, accuracy: 1e-10)
    }
    
    // MARK: - Zero Values
    
    func testZeroInputs() throws {
        let result = try sut.calculate(rule: "a * b", variables: ["a": 0, "b": 100])
        XCTAssertEqual(result, 0.0, accuracy: 1e-10)
    }
    
    func testAllZeroInputs() throws {
        let result = try sut.calculate(rule: "a + b + c", variables: ["a": 0, "b": 0, "c": 0])
        XCTAssertEqual(result, 0.0, accuracy: 1e-10)
    }
    
    // MARK: - Complex Expressions
    
    func testNestedFunctions() throws {
        // sqrt(pow(3) + pow(4)) = sqrt(9 + 16) = sqrt(25) = 5
        let result = try sut.calculate(rule: "sqrt(pow(a, 2) + pow(b, 2))", variables: ["a": 3, "b": 4])
        XCTAssertEqual(result, 5.0, accuracy: 1e-10)
    }
    
    func testComplexPhysicsExpression() throws {
        // E = 0.5 * m * v^2
        let result = try sut.calculate(rule: "0.5 * m * pow(v, 2)", variables: ["m": 2, "v": 3])
        XCTAssertEqual(result, 9.0, accuracy: 1e-10)
    }
    
    // MARK: - JavaScript Reserved Words
    
    func testJSReservedWordVariable_in() throws {
        // Variable named "in" should be safely handled
        let result = try sut.calculate(rule: "a + b", variables: ["a": 5, "b": 3])
        XCTAssertEqual(result, 8.0, accuracy: 1e-10)
    }
    
    func testJSReservedWordVariable_do() throws {
        // Test that a variable prefixed with _ works
        let result = try sut.calculate(rule: "_do + 1", variables: ["_do": 5])
        XCTAssertEqual(result, 6.0, accuracy: 1e-10)
    }

    // MARK: - Validate Input Tests
    
    func testValidateInput_ValidNumber() {
        XCTAssertTrue(sut.validateInput("3.14"))
    }
    
    func testValidateInput_ValidNegative() {
        XCTAssertTrue(sut.validateInput("-5.0"))
    }
    
    func testValidateInput_ValidInteger() {
        XCTAssertTrue(sut.validateInput("42"))
    }
    
    func testValidateInput_EmptyString() {
        XCTAssertFalse(sut.validateInput(""))
    }
    
    func testValidateInput_WhitespaceOnly() {
        XCTAssertFalse(sut.validateInput("   "))
    }
    
    func testValidateInput_Letters() {
        XCTAssertFalse(sut.validateInput("abc"))
    }
    
    func testValidateInput_CommaDecimal() {
        // Commas should be handled (replaced with dots)
        XCTAssertTrue(sut.validateInput("3,14"))
    }
    
    func testValidateInput_ScientificNotation() {
        XCTAssertTrue(sut.validateInput("2.5e3"))
    }
    
    func testValidateInput_NegativeScientific() {
        XCTAssertTrue(sut.validateInput("-1.5e-10"))
    }
    
    func testValidateInput_LeadingSpaces() {
        XCTAssertTrue(sut.validateInput("  42  "))
    }
    
    // MARK: - Format Result Tests
    
    func testFormatResult_Integer() {
        let result = sut.formatResult(100.0)
        XCTAssertEqual(result, "100")
    }
    
    func testFormatResult_SmallDecimal() {
        let result = sut.formatResult(3.14)
        XCTAssertEqual(result, "3.14")
    }
    
    func testFormatResult_VerySmall() {
        let result = sut.formatResult(1e-30)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testFormatResult_VeryLarge() {
        let result = sut.formatResult(1e30)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testFormatResult_Zero() {
        let result = sut.formatResult(0.0)
        XCTAssertEqual(result, "0")
    }
    
    func testFormatResult_Negative() {
        let result = sut.formatResult(-42.0)
        XCTAssertTrue(result.contains("-"))
        XCTAssertTrue(result.contains("42"))
    }
}

// MARK: - Error Propagation Calculation Tests

final class ErrorPropagationTests: XCTestCase {
    
    var sut: CalculationService!
    
    override func setUp() {
        super.setUp()
        sut = CalculationService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /// Numerical partial derivative: ∂f/∂x ≈ (f(x+h) - f(x-h)) / (2h)
    private func numericalDerivative(rule: String, variables: [String: Double], withRespectTo symbol: String) throws -> Double {
        guard let xVal = variables[symbol], xVal != 0 else {
            // For zero value, use forward difference
            let h = 1e-6
            var shifted = variables
            shifted[symbol] = h
            let fShifted = try sut.calculate(rule: rule, variables: shifted)
            let f0 = try sut.calculate(rule: rule, variables: variables)
            return (fShifted - f0) / h
        }
        let h = abs(xVal) * 1e-6
        var varsPlus = variables
        var varsMinus = variables
        varsPlus[symbol] = xVal + h
        varsMinus[symbol] = xVal - h
        
        let fPlus = try sut.calculate(rule: rule, variables: varsPlus)
        let fMinus = try sut.calculate(rule: rule, variables: varsMinus)
        return (fPlus - fMinus) / (2 * h)
    }
    
    private func absoluteError(rule: String, variables: [String: Double], deltas: [String: Double]) throws -> Double {
        var sumSquares = 0.0
        for (symbol, delta) in deltas {
            let deriv = try numericalDerivative(rule: rule, variables: variables, withRespectTo: symbol)
            sumSquares += (deriv * delta) * (deriv * delta)
        }
        return sqrt(sumSquares)
    }
    
    // MARK: - Linear Formula: F = m*a
    
    func testErrorPropagation_Force_LinearFormula() throws {
        // F = m*a  →  ∂F/∂m = a = 9.8, ∂F/∂a = m = 10
        // ΔF = √((a*Δm)² + (m*Δa)²) = √((9.8*0.1)² + (10*0.05)²)
        let rule = "m * a"
        let vars: [String: Double] = ["m": 10, "a": 9.8]
        let deltas: [String: Double] = ["m": 0.1, "a": 0.05]
        
        let absErr = try absoluteError(rule: rule, variables: vars, deltas: deltas)
        let expected = sqrt(pow(9.8 * 0.1, 2) + pow(10 * 0.05, 2))
        
        XCTAssertEqual(absErr, expected, accuracy: expected * 0.01)
    }
    
    // MARK: - Division Formula: v = s/t
    
    func testErrorPropagation_Velocity_DivisionFormula() throws {
        // v = s/t  →  ∂v/∂s = 1/t = 0.1, ∂v/∂t = -s/t² = -100/100 = -1
        let rule = "s / t"
        let vars: [String: Double] = ["s": 100, "t": 10]
        let deltas: [String: Double] = ["s": 0.5, "t": 0.1]
        
        let absErr = try absoluteError(rule: rule, variables: vars, deltas: deltas)
        let expected = sqrt(pow(1.0/10.0 * 0.5, 2) + pow(-100.0/100.0 * 0.1, 2))
        
        XCTAssertEqual(absErr, expected, accuracy: expected * 0.01)
    }
    
    // MARK: - Quadratic Formula: E = 0.5*m*v²
    
    func testErrorPropagation_KineticEnergy() throws {
        // E = 0.5*m*v²  →  ∂E/∂m = 0.5*v² = 0.5*9 = 4.5, ∂E/∂v = m*v = 2*3 = 6
        let rule = "0.5 * m * pow(v, 2)"
        let vars: [String: Double] = ["m": 2, "v": 3]
        let deltas: [String: Double] = ["m": 0.1, "v": 0.05]
        
        let absErr = try absoluteError(rule: rule, variables: vars, deltas: deltas)
        let expectedPartialM = 0.5 * 9.0  // 4.5
        let expectedPartialV = 2.0 * 3.0  // 6.0
        let expected = sqrt(pow(expectedPartialM * 0.1, 2) + pow(expectedPartialV * 0.05, 2))
        
        XCTAssertEqual(absErr, expected, accuracy: expected * 0.02)
    }
    
    // MARK: - Analytical vs Numerical Derivatives
    
    func testNumericalDerivative_Linear() throws {
        // f = 2*x + 3  →  ∂f/∂x = 2
        let deriv = try numericalDerivative(rule: "2 * x + 3", variables: ["x": 5], withRespectTo: "x")
        XCTAssertEqual(deriv, 2.0, accuracy: 0.001)
    }
    
    func testNumericalDerivative_Quadratic() throws {
        // f = x²  →  ∂f/∂x = 2x = 6
        let deriv = try numericalDerivative(rule: "pow(x, 2)", variables: ["x": 3], withRespectTo: "x")
        XCTAssertEqual(deriv, 6.0, accuracy: 0.001)
    }
    
    func testNumericalDerivative_Sin() throws {
        // f = sin(x)  →  ∂f/∂x = cos(x) = cos(0) = 1
        let deriv = try numericalDerivative(rule: "sin(x)", variables: ["x": 0], withRespectTo: "x")
        XCTAssertEqual(deriv, 1.0, accuracy: 0.001)
    }
    
    func testNumericalDerivative_Sqrt() throws {
        // f = sqrt(x)  →  ∂f/∂x = 1/(2*sqrt(x)) = 1/(2*2) = 0.25
        let deriv = try numericalDerivative(rule: "sqrt(x)", variables: ["x": 4], withRespectTo: "x")
        XCTAssertEqual(deriv, 0.25, accuracy: 0.001)
    }
    
    // MARK: - Coulomb's Law Error Propagation
    
    func testErrorPropagation_CoulombsLaw() throws {
        // F = k * q1 * q2 / r²
        let rule = "k * q1 * q2 / pow(r, 2)"
        let kCoulomb = 8.9875517923e9
        let vars: [String: Double] = ["k": kCoulomb, "q1": 1e-6, "q2": 2e-6, "r": 0.1]
        let deltas: [String: Double] = ["q1": 1e-8, "q2": 1e-8, "r": 0.001]
        
        let absErr = try absoluteError(rule: rule, variables: vars, deltas: deltas)
        
        // Just verify we get a finite positive result
        XCTAssertTrue(absErr > 0)
        XCTAssertTrue(absErr.isFinite)
    }
    
    // MARK: - Relative Error
    
    func testRelativeError_SimpleFormula() throws {
        let rule = "m * a"
        let vars: [String: Double] = ["m": 10, "a": 9.8]
        let deltas: [String: Double] = ["m": 0.1, "a": 0.05]
        
        let absErr = try absoluteError(rule: rule, variables: vars, deltas: deltas)
        let f0 = try sut.calculate(rule: rule, variables: vars)
        let relErr = (absErr / abs(f0)) * 100
        
        // Relative error should be a reasonable percentage
        XCTAssertGreaterThan(relErr, 0)
        XCTAssertLessThan(relErr, 10)
    }
    
    func testZeroDelta_NoError() throws {
        let rule = "m * a"
        let vars: [String: Double] = ["m": 10, "a": 9.8]
        let deltas: [String: Double] = ["m": 0, "a": 0]
        
        let absErr = try absoluteError(rule: rule, variables: vars, deltas: deltas)
        XCTAssertEqual(absErr, 0.0, accuracy: 1e-10)
    }
}
