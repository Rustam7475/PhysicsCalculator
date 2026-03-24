import XCTest
@testable import PhysicsCalculator

final class DataServiceTests: XCTestCase {
    
    private lazy var data: PhysicsData = DataService.fallbackData
    private lazy var fullData: PhysicsData? = loadPhysicsData()
    
    func testFallbackData_HasSections() {
        XCTAssertFalse(data.sections.isEmpty)
    }
    
    func testFallbackData_HasSubsections() {
        XCTAssertFalse(data.subsections.isEmpty)
    }
    
    func testFallbackData_HasFormulas() {
        XCTAssertFalse(data.formulas.isEmpty)
    }
    
    func testFallbackData_FormulaHasCalculationRules() {
        guard let formula = data.formulas.first else {
            XCTFail("No formulas in fallback data")
            return
        }
        XCTAssertFalse(formula.calculation_rules.isEmpty)
    }
    
    func testFallbackData_FormulaHasVariables() {
        guard let formula = data.formulas.first else {
            XCTFail("No formulas in fallback data")
            return
        }
        XCTAssertFalse(formula.variables.isEmpty)
    }
    
    func testFallbackData_SubsectionLinksToSection() {
        guard let subsection = data.subsections.first else {
            XCTFail("Missing subsection")
            return
        }
        let sectionIds = Set(data.sections.map(\.id))
        XCTAssertTrue(sectionIds.contains(subsection.sectionId),
            "Subsection \(subsection.id) links to non-existent section \(subsection.sectionId)")
    }
    
    // MARK: - Expanded Data Integrity Tests
    
    func testFormulaCount_AtLeast126() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        XCTAssertGreaterThanOrEqual(d.formulas.count, 126, "Expected at least 126 formulas")
    }
    
    func testSubsectionCount_AtLeast28() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        XCTAssertGreaterThanOrEqual(d.subsections.count, 28, "Expected at least 28 subsections")
    }
    
    func testSectionCount_AtLeast6() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        XCTAssertGreaterThanOrEqual(d.sections.count, 6, "Expected at least 6 sections")
    }
    
    func testAllFormulas_HaveUniqueIds() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        let ids = d.formulas.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "Formula IDs should be unique")
    }
    
    func testAllSubsections_HaveUniqueIds() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        let ids = d.subsections.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "Subsection IDs should be unique")
    }
    
    func testAllFormulas_LinkToValidSubsection() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        let subsectionIds = Set(d.subsections.map(\.id))
        for formula in d.formulas {
            XCTAssertTrue(subsectionIds.contains(formula.subsectionId),
                "Formula \(formula.id) links to non-existent subsection \(formula.subsectionId)")
        }
    }
    
    func testAllSubsections_LinkToValidSection() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        let sectionIds = Set(d.sections.map(\.id))
        for sub in d.subsections {
            XCTAssertTrue(sectionIds.contains(sub.sectionId),
                "Subsection \(sub.id) links to non-existent section \(sub.sectionId)")
        }
    }
    
    func testAllFormulas_HaveNames() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        for formula in d.formulas {
            XCTAssertFalse(formula.name_ru.isEmpty, "\(formula.id) missing name_ru")
            XCTAssertFalse(formula.name_en.isEmpty, "\(formula.id) missing name_en")
        }
    }
    
    func testAllFormulas_HaveEquationLatex() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        for formula in d.formulas {
            XCTAssertFalse(formula.equation_latex.isEmpty, "\(formula.id) missing equation_latex")
        }
    }
    
    func testAllFormulas_HaveAtLeastTwoVariables() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        for formula in d.formulas {
            XCTAssertGreaterThanOrEqual(formula.variables.count, 2,
                "\(formula.id) should have at least 2 variables")
        }
    }
    
    func testAllFormulas_HaveRulesForEachVariable() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        for formula in d.formulas {
            for variable in formula.variables {
                XCTAssertNotNil(formula.calculation_rules[variable.symbol],
                    "\(formula.id) missing calculation_rule for \(variable.symbol)")
            }
        }
    }
    
    func testAllFormulas_VariablesHaveUnits() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        for formula in d.formulas {
            for variable in formula.variables {
                XCTAssertFalse(variable.unit_si.isEmpty,
                    "\(formula.id).\(variable.symbol) missing unit_si")
            }
        }
    }
    
    func testAllFormulas_HaveLevels() {
        guard let d = fullData else { XCTFail("loadPhysicsData() returned nil"); return }
        let validLevels: Set<String> = ["school", "university"]
        for formula in d.formulas {
            XCTAssertFalse(formula.levels.isEmpty, "\(formula.id) missing levels")
            for level in formula.levels {
                XCTAssertTrue(validLevels.contains(level),
                    "\(formula.id) has invalid level '\(level)'")
            }
        }
    }
    
    func testLoadPhysicsData_ReturnsData() {
        let data = loadPhysicsData()
        XCTAssertNotNil(data)
    }
    
    func testLoadPhysicsData_ConsistentWithFallback() {
        guard let loaded = fullData else {
            XCTFail("loadPhysicsData() returned nil")
            return
        }
        // Loaded data should contain at least what fallback has
        XCTAssertGreaterThanOrEqual(loaded.formulas.count, data.formulas.count)
        XCTAssertGreaterThanOrEqual(loaded.sections.count, data.sections.count)
        XCTAssertGreaterThanOrEqual(loaded.subsections.count, data.subsections.count)
    }
}
