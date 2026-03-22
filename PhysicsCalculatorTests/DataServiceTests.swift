import XCTest
@testable import PhysicsCalculator

final class DataServiceTests: XCTestCase {
    
    func testFallbackData_HasSections() {
        let data = DataService.fallbackData
        XCTAssertFalse(data.sections.isEmpty)
    }
    
    func testFallbackData_HasSubsections() {
        let data = DataService.fallbackData
        XCTAssertFalse(data.subsections.isEmpty)
    }
    
    func testFallbackData_HasFormulas() {
        let data = DataService.fallbackData
        XCTAssertFalse(data.formulas.isEmpty)
    }
    
    func testFallbackData_FormulaHasCalculationRules() {
        let data = DataService.fallbackData
        guard let formula = data.formulas.first else {
            XCTFail("No formulas in fallback data")
            return
        }
        XCTAssertFalse(formula.calculation_rules.isEmpty)
    }
    
    func testFallbackData_FormulaHasVariables() {
        let data = DataService.fallbackData
        guard let formula = data.formulas.first else {
            XCTFail("No formulas in fallback data")
            return
        }
        XCTAssertFalse(formula.variables.isEmpty)
    }
    
    func testFallbackData_SubsectionLinksToSection() {
        let data = DataService.fallbackData
        guard let subsection = data.subsections.first,
              let section = data.sections.first else {
            XCTFail("Missing data")
            return
        }
        XCTAssertEqual(subsection.sectionId, section.id)
    }
}
