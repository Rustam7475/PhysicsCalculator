import XCTest
@testable import PhysicsCalculator

final class PhysicsModelsTests: XCTestCase {
    
    // MARK: - Тесты PhysicsSection
    
    func testPhysicsSection_LocalizedNameRu() {
        let section = PhysicsSection(
            id: "mech",
            name_ru: "Механика",
            name_en: "Mechanics",
            levels: ["school"]
        )
        XCTAssertEqual(section.localizedName(for: "ru"), "Механика")
    }
    
    func testPhysicsSection_LocalizedNameEn() {
        let section = PhysicsSection(
            id: "mech",
            name_ru: "Механика",
            name_en: "Mechanics",
            levels: ["school"]
        )
        XCTAssertEqual(section.localizedName(for: "en"), "Mechanics")
    }
    
    func testPhysicsSection_LocalizedNameFallbackToEn() {
        let section = PhysicsSection(
            id: "mech",
            name_ru: "Механика",
            name_en: "Mechanics",
            levels: ["school"]
        )
        XCTAssertEqual(section.localizedName(for: "de"), "Mechanics")
    }
    
    // MARK: - Тесты Formula
    
    func testFormula_LocalizedNameRu() {
        let formula = makeTestFormula()
        XCTAssertEqual(formula.localizedName(for: "ru"), "Скорость")
    }
    
    func testFormula_LocalizedDescriptionEn() {
        let formula = makeTestFormula()
        XCTAssertEqual(formula.localizedDescription(for: "en"), "Velocity")
    }
    
    func testFormula_GetRearrangedFormula() {
        let formula = makeTestFormula()
        let rearranged = formula.getRearrangedFormula(for: "v")
        XCTAssertTrue(rearranged.contains("v"))
        XCTAssertTrue(rearranged.contains("="))
    }
    
    func testFormula_GetRearrangedFormula_InvalidSymbol() {
        let formula = makeTestFormula()
        let rearranged = formula.getRearrangedFormula(for: "x")
        XCTAssertEqual(rearranged, formula.equation_latex)
    }
    
    // MARK: - Тесты Variable
    
    func testVariable_Id() {
        let variable = Variable(symbol: "v", name_ru: "Скорость", name_en: "Velocity", unit_si: "м/с")
        XCTAssertEqual(variable.id, "v")
    }
    
    func testVariable_LocalizedName() {
        let variable = Variable(symbol: "v", name_ru: "Скорость", name_en: "Velocity", unit_si: "м/с")
        XCTAssertEqual(variable.localizedName(for: "ru"), "Скорость")
        XCTAssertEqual(variable.localizedName(for: "en"), "Velocity")
    }
    
    // MARK: - Тесты Codable
    
    func testFormula_EncodeDecode() throws {
        let formula = makeTestFormula()
        let data = try JSONEncoder().encode(formula)
        let decoded = try JSONDecoder().decode(Formula.self, from: data)
        
        XCTAssertEqual(decoded.id, formula.id)
        XCTAssertEqual(decoded.name_ru, formula.name_ru)
        XCTAssertEqual(decoded.variables.count, formula.variables.count)
        XCTAssertEqual(decoded.calculation_rules.count, formula.calculation_rules.count)
    }
    
    func testPhysicsData_EncodeDecode() throws {
        let data = PhysicsData(
            sections: [PhysicsSection(id: "mech", name_ru: "Механика", name_en: "Mechanics", levels: ["school"])],
            subsections: [PhysicsSubsection(id: "kin", sectionId: "mech", name_ru: "Кинематика", name_en: "Kinematics", levels: ["school"])],
            formulas: [makeTestFormula()]
        )
        
        let encoded = try JSONEncoder().encode(data)
        let decoded = try JSONDecoder().decode(PhysicsData.self, from: encoded)
        
        XCTAssertEqual(decoded.sections.count, 1)
        XCTAssertEqual(decoded.subsections.count, 1)
        XCTAssertEqual(decoded.formulas.count, 1)
    }
    
    // MARK: - Вспомогательные методы
    
    private func makeTestFormula() -> Formula {
        Formula(
            id: "test_velocity",
            subsectionId: "kinematics",
            name_ru: "Скорость",
            name_en: "Velocity",
            levels: ["school"],
            equation_latex: "v = \\frac{s}{t}",
            description_ru: "Скорость",
            description_en: "Velocity",
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
    }
}
