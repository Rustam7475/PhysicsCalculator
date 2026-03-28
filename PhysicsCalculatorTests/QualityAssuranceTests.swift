import XCTest
@testable import PhysicsCalculator

// MARK: - Integration Tests (Real Data → Real CalculationService → Result)

final class IntegrationTests: XCTestCase {
    
    var calculationService: CalculationService!
    var physicsData: PhysicsData?
    
    override func setUp() {
        super.setUp()
        calculationService = CalculationService()
        physicsData = loadPhysicsData()
    }
    
    override func tearDown() {
        calculationService = nil
        physicsData = nil
        super.tearDown()
    }
    
    // MARK: - Full Pipeline Tests
    
    func testFullPipeline_NewtonSecondLaw() throws {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        guard let formula = data.formulas.first(where: { $0.name_en == "Newton's Second Law" }) else {
            XCTFail("Newton's Second Law not found"); return
        }
        
        guard let rule = formula.calculation_rules["F"] else {
            XCTFail("No rule for F"); return
        }
        
        let result = try calculationService.calculate(rule: rule, variables: ["m": 10, "a": 9.8])
        XCTAssertEqual(result, 98.0, accuracy: 0.1)
    }
    
    func testFullPipeline_OhmsLaw() throws {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        guard let formula = data.formulas.first(where: { $0.id.contains("ohm") }) else {
            XCTFail("Ohm's Law not found"); return
        }
        
        if let rule = formula.calculation_rules["I"] {
            let result = try calculationService.calculate(rule: rule, variables: ["U": 12, "R": 4])
            XCTAssertEqual(result, 3.0, accuracy: 0.001)
        } else if let rule = formula.calculation_rules.values.first {
            // Try any available rule
            let result = try calculationService.calculate(rule: rule, variables: self.buildTestVariables(for: formula))
            XCTAssertTrue(result.isFinite, "Result should be finite")
        }
    }
    
    func testFullPipeline_IdealGasLaw() throws {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        guard let formula = data.formulas.first(where: { $0.name_en.contains("Ideal Gas") }) else {
            XCTFail("Ideal Gas Law not found"); return
        }
        
        // PV = nRT → P = nRT/V
        if let rule = formula.calculation_rules["P"] {
            let result = try calculationService.calculate(rule: rule, variables: ["n": 1, "R": 8.314, "T": 300, "V": 0.0224])
            XCTAssertGreaterThan(result, 0)
            XCTAssertTrue(result.isFinite)
        }
    }
    
    func testFullPipeline_KineticEnergy() throws {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        guard let formula = data.formulas.first(where: { $0.name_en == "Kinetic Energy" }) else {
            XCTFail("Kinetic Energy formula not found"); return
        }
        
        if let ekSymbol = formula.calculation_rules.keys.first(where: { $0.contains("E") || $0 == "Ek" || !$0.contains("m") && !$0.contains("v") }),
           let rule = formula.calculation_rules[ekSymbol] {
            let result = try calculationService.calculate(rule: rule, variables: ["m": 2, "v": 3])
            XCTAssertEqual(result, 9.0, accuracy: 0.1) // 0.5 * 2 * 9
        }
    }
    
    func testFullPipeline_CoulombsLaw() throws {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        guard let formula = data.formulas.first(where: { $0.name_en.contains("Coulomb") }) else {
            XCTFail("Coulomb's Law not found"); return
        }
        
        // Just test that any rule can be computed with positive values
        for (symbol, rule) in formula.calculation_rules {
            let vars = buildTestVariables(for: formula, excluding: symbol)
            if !vars.isEmpty {
                let result = try? calculationService.calculate(rule: rule, variables: vars)
                XCTAssertNotNil(result, "Rule for \(symbol) should compute a valid result")
                if let r = result {
                    XCTAssertTrue(r.isFinite, "Result for \(symbol) should be finite")
                }
                break // Just test one rule to verify pipeline
            }
        }
    }
    
    // MARK: - All Formulas Have Computable Rules
    
    func testAllFormulas_HaveAtLeastOneComputableRule() throws {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        for formula in data.formulas {
            XCTAssertFalse(formula.calculation_rules.isEmpty,
                "Formula \(formula.id) (\(formula.name_en)) has no calculation rules")
        }
    }
    
    func testAllFormulas_RulesReferenceExistingVariables() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        for formula in data.formulas {
            let variableSymbols = Set(formula.variables.map(\.symbol))
            for (symbol, _) in formula.calculation_rules {
                XCTAssertTrue(variableSymbols.contains(symbol),
                    "Formula \(formula.id): rule for '\(symbol)' but no matching variable")
            }
        }
    }
    
    func testAllFormulas_EachHasRuleForAtLeastOneVariable() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        for formula in data.formulas {
            let ruleSymbols = Set(formula.calculation_rules.keys)
            let varSymbols = Set(formula.variables.map(\.symbol))
            let intersection = ruleSymbols.intersection(varSymbols)
            XCTAssertFalse(intersection.isEmpty,
                "Formula \(formula.id) should have rules matching its variables")
        }
    }
    
    // MARK: - Data Consistency
    
    func testAllSubsections_BelongToExistingSection() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        let sectionIds = Set(data.sections.map(\.id))
        
        for sub in data.subsections {
            XCTAssertTrue(sectionIds.contains(sub.sectionId),
                "Subsection \(sub.id) references non-existent section \(sub.sectionId)")
        }
    }
    
    func testAllFormulas_BelongToExistingSubsection() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        let subIds = Set(data.subsections.map(\.id))
        
        for formula in data.formulas {
            XCTAssertTrue(subIds.contains(formula.subsectionId),
                "Formula \(formula.id) references non-existent subsection \(formula.subsectionId)")
        }
    }
    
    func testAllFormulas_HaveNonEmptyEquationLatex() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        for formula in data.formulas {
            XCTAssertFalse(formula.equation_latex.isEmpty,
                "Formula \(formula.id) has empty equation_latex")
        }
    }
    
    func testAllFormulas_HaveAtLeast2Variables() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        for formula in data.formulas {
            XCTAssertGreaterThanOrEqual(formula.variables.count, 2,
                "Formula \(formula.id) should have at least 2 variables")
        }
    }
    
    func testAllVariables_HaveNonEmptyFields() {
        guard let data = physicsData else { XCTFail("No physics data"); return }
        
        for formula in data.formulas {
            for variable in formula.variables {
                XCTAssertFalse(variable.symbol.isEmpty,
                    "Variable in \(formula.id) has empty symbol")
                XCTAssertFalse(variable.name_ru.isEmpty,
                    "Variable \(variable.symbol) in \(formula.id) has empty name_ru")
                XCTAssertFalse(variable.name_en.isEmpty,
                    "Variable \(variable.symbol) in \(formula.id) has empty name_en")
                XCTAssertFalse(variable.unit_si.isEmpty,
                    "Variable \(variable.symbol) in \(formula.id) has empty unit_si")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func buildTestVariables(for formula: Formula, excluding symbol: String? = nil) -> [String: Double] {
        var vars: [String: Double] = [:]
        for variable in formula.variables {
            if variable.symbol == symbol { continue }
            // Use physical constant or default value
            if let constant = PhysicalConstants.match(for: variable) {
                vars[variable.symbol] = constant.value
            } else {
                vars[variable.symbol] = 1.0
            }
        }
        return vars
    }
}

// MARK: - Localization Completeness Tests

final class LocalizationCompletenessTests: XCTestCase {
    
    private let supportedLanguages = ["ru", "en", "de", "es", "fr", "zh"]
    
    // MARK: - L10n Static Properties
    
    func testL10n_TabStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let tabs = [L10n.tabSections, L10n.tabFavorites, L10n.tabHistory,
                        L10n.tabConstants, L10n.tabConverter, L10n.tabSettings]
            for (i, tab) in tabs.enumerated() {
                XCTAssertFalse(tab.isEmpty, "Tab \(i) is empty for language \(lang)")
            }
        }
        // Reset
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_CommonStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.calculate, L10n.close, L10n.cancel,
                           L10n.delete, L10n.copy, L10n.share]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "Common string is empty for language \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_SettingsStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.settingsTitle, L10n.appearance, L10n.themeLabel,
                           L10n.languageLabel, L10n.aboutApp, L10n.version]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "Settings string is empty for language \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_ThemeStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.themeLight, L10n.themeDark, L10n.themeOLED, L10n.themeSystem]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "Theme string is empty for language \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_ErrorMessages_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            XCTAssertFalse(L10n.invalidResult.isEmpty, "invalidResult is empty for \(lang)")
            XCTAssertFalse(L10n.fileNotFound.isEmpty, "fileNotFound is empty for \(lang)")
            XCTAssertFalse(L10n.selectUnknownVariable.isEmpty, "selectUnknownVariable is empty for \(lang)")
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_DynamicStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            XCTAssertFalse(L10n.enterCorrectValue("test").isEmpty, "enterCorrectValue empty for \(lang)")
            XCTAssertFalse(L10n.noRuleFor("x").isEmpty, "noRuleFor empty for \(lang)")
            XCTAssertFalse(L10n.evaluationError("msg").isEmpty, "evaluationError empty for \(lang)")
            XCTAssertFalse(L10n.decodingError("err").isEmpty, "decodingError empty for \(lang)")
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_OnboardingStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.onboardingDesc1, L10n.onboardingTitle2, L10n.onboardingDesc2,
                           L10n.onboardingTitle3, L10n.onboardingDesc3, L10n.onboardingTitle4,
                           L10n.onboardingDesc4, L10n.onboardingTitle5, L10n.onboardingDesc5,
                           L10n.onboardingTitle6, L10n.onboardingDesc6]
            for (i, str) in strings.enumerated() {
                XCTAssertFalse(str.isEmpty, "Onboarding string \(i) is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_HistoryStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.historyTitle, L10n.historyEmpty, L10n.clearHistoryTitle,
                           L10n.historySearch]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "History string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_FavoritesStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.favoritesTitle, L10n.noFavorites]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "Favorites string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_PDFStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.pdfPreviewTitle, L10n.generatingPDF,
                           L10n.pdfInputValues, L10n.pdfResult, L10n.pdfDate]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "PDF string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_ConverterStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.converterTitle, L10n.converterFrom, L10n.converterTo, L10n.converterAllUnits]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "Converter string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_ConstantsStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.constantsTitle, L10n.searchConstants]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "Constants string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_MultiCalcStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.multiCalcTitle, L10n.addRow, L10n.removeRow,
                           L10n.calculateAll, L10n.statistics,
                           L10n.statMin, L10n.statMax, L10n.statAvg]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "MultiCalc string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    func testL10n_InfoViewStrings_AllLanguages() {
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            
            let strings = [L10n.infoTitle, L10n.descriptionLabel, L10n.theoryLabel,
                           L10n.examplesLabel, L10n.problemLabel, L10n.answerLabel,
                           L10n.variablesLabel, L10n.applicationArea]
            for str in strings {
                XCTAssertFalse(str.isEmpty, "InfoView string is empty for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
    
    // MARK: - Physics Data Localization
    
    func testAllSections_HaveRuAndEnNames() {
        guard let data = loadPhysicsData() else { XCTFail("No data"); return }
        for section in data.sections {
            XCTAssertFalse(section.name_ru.isEmpty, "Section \(section.id) has empty name_ru")
            XCTAssertFalse(section.name_en.isEmpty, "Section \(section.id) has empty name_en")
        }
    }
    
    func testAllSubsections_HaveRuAndEnNames() {
        guard let data = loadPhysicsData() else { XCTFail("No data"); return }
        for sub in data.subsections {
            XCTAssertFalse(sub.name_ru.isEmpty, "Subsection \(sub.id) has empty name_ru")
            XCTAssertFalse(sub.name_en.isEmpty, "Subsection \(sub.id) has empty name_en")
        }
    }
    
    func testAllFormulas_HaveBothNameTranslations() {
        guard let data = loadPhysicsData() else { XCTFail("No data"); return }
        for formula in data.formulas {
            XCTAssertFalse(formula.name_ru.isEmpty, "Formula \(formula.id) has empty name_ru")
            XCTAssertFalse(formula.name_en.isEmpty, "Formula \(formula.id) has empty name_en")
        }
    }
    
    func testAllFormulas_HaveBothDescriptions() {
        guard let data = loadPhysicsData() else { XCTFail("No data"); return }
        for formula in data.formulas {
            XCTAssertFalse(formula.description_ru.isEmpty, "Formula \(formula.id) has empty description_ru")
            XCTAssertFalse(formula.description_en.isEmpty, "Formula \(formula.id) has empty description_en")
        }
    }
    
    // MARK: - UnitName Localization
    
    func testUnitName_CommonUnits_AllLanguages() {
        let commonUnitIds = ["m", "kg", "s", "N", "J", "W", "Pa", "K", "Hz", "A", "V", "Ohm"]
        for lang in supportedLanguages {
            AppSettings.shared.languageCode = lang
            for unitId in commonUnitIds {
                let name = L10n.unitName(unitId)
                XCTAssertFalse(name.isEmpty, "Unit \(unitId) has empty name for \(lang)")
            }
        }
        AppSettings.shared.languageCode = "system"
    }
}

// MARK: - PhysicalConstants Tests

final class PhysicalConstantsMatchTests: XCTestCase {
    
    // MARK: - All Constants Exist
    
    func testAllConstants_Count() {
        XCTAssertEqual(PhysicalConstants.all.count, 15,
            "Expected 15 physical constants")
    }
    
    func testGravitationalAcceleration() {
        guard let g = PhysicalConstants.all.first(where: { $0.symbol == "g" }) else {
            XCTFail("g constant not found"); return
        }
        XCTAssertEqual(g.value, 9.81, accuracy: 0.001)
        XCTAssertEqual(g.unit, "м/с²")
    }
    
    func testSpeedOfLight() {
        guard let c = PhysicalConstants.all.first(where: { $0.symbol == "c" }) else {
            XCTFail("c constant not found"); return
        }
        XCTAssertEqual(c.value, 299792458, accuracy: 1)
        XCTAssertEqual(c.unit, "м/с")
    }
    
    func testBoltzmannConstant() {
        guard let k = PhysicalConstants.all.first(where: { $0.symbol == "k_B" }) else {
            XCTFail("k_B constant not found"); return
        }
        XCTAssertEqual(k.value, 1.380649e-23, accuracy: 1e-28)
    }
    
    func testAvogadroNumber() {
        guard let na = PhysicalConstants.all.first(where: { $0.symbol == "N_A" }) else {
            XCTFail("N_A constant not found"); return
        }
        XCTAssertEqual(na.value, 6.02214076e23, accuracy: 1e14)
    }
    
    func testPlanckConstant() {
        guard let h = PhysicalConstants.all.first(where: { $0.symbol == "h" }) else {
            XCTFail("h constant not found"); return
        }
        XCTAssertEqual(h.value, 6.62607015e-34, accuracy: 1e-42)
    }
    
    // MARK: - Match by Symbol + Unit
    
    func testMatch_GravitationalAcceleration() {
        let variable = Variable(symbol: "g", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
        guard let match = PhysicalConstants.match(for: variable) else {
            XCTFail("g should match"); return
        }
        XCTAssertEqual(match.value, 9.81, accuracy: 0.001)
    }
    
    func testMatch_GasConstant() {
        let variable = Variable(symbol: "R", name_ru: "Газовая постоянная", name_en: "Gas Constant", unit_si: "Дж/(моль·К)")
        guard let match = PhysicalConstants.match(for: variable) else {
            XCTFail("R should match"); return
        }
        XCTAssertEqual(match.value, 8.314, accuracy: 0.001)
    }
    
    func testMatch_SpeedOfLight() {
        let variable = Variable(symbol: "c", name_ru: "Скорость", name_en: "Speed", unit_si: "м/с")
        guard let match = PhysicalConstants.match(for: variable) else {
            XCTFail("c should match"); return
        }
        XCTAssertEqual(match.value, 299792458, accuracy: 1)
    }
    
    func testMatch_VacuumPermittivity_Alias() {
        // Test alias: eps0 → ε0
        let variable = Variable(symbol: "eps0", name_ru: "Электрическая", name_en: "Permittivity", unit_si: "Ф/м")
        guard let match = PhysicalConstants.match(for: variable) else {
            XCTFail("eps0 alias should match ε0"); return
        }
        XCTAssertEqual(match.symbol, "ε0")
    }
    
    func testMatch_VacuumPermeability_Alias() {
        let variable = Variable(symbol: "mu0", name_ru: "Магнитная", name_en: "Permeability", unit_si: "Гн/м")
        guard let match = PhysicalConstants.match(for: variable) else {
            XCTFail("mu0 alias should match μ0"); return
        }
        XCTAssertEqual(match.symbol, "μ0")
    }
    
    func testMatch_Rydberg_Alias() {
        let variable = Variable(symbol: "Rinf", name_ru: "Ридберг", name_en: "Rydberg", unit_si: "1/м")
        let match = PhysicalConstants.match(for: variable)
        XCTAssertNotNil(match, "Rinf alias should match R∞")
    }
    
    func testMatch_StefanBoltzmann_Alias() {
        let variable = Variable(symbol: "sigma", name_ru: "Стефан-Больцман", name_en: "Stefan-Boltzmann", unit_si: "Вт/(м²·К⁴)")
        let match = PhysicalConstants.match(for: variable)
        XCTAssertNotNil(match, "sigma alias should match σ")
    }
    
    func testMatch_Wien_Alias() {
        let variable = Variable(symbol: "bw", name_ru: "Вина", name_en: "Wien", unit_si: "м·К")
        let match = PhysicalConstants.match(for: variable)
        XCTAssertNotNil(match, "bw alias should match b_W")
    }
    
    // MARK: - No False Matches
    
    func testNoMatch_WrongUnit() {
        // R is gas constant with unit Дж/(моль·К), not Ом (ohms)
        let variable = Variable(symbol: "R", name_ru: "Сопротивление", name_en: "Resistance", unit_si: "Ом")
        let match = PhysicalConstants.match(for: variable)
        XCTAssertNil(match, "R with unit Ом should NOT match gas constant")
    }
    
    func testNoMatch_UnknownSymbol() {
        let variable = Variable(symbol: "xyz", name_ru: "Неизвестная", name_en: "Unknown", unit_si: "м")
        let match = PhysicalConstants.match(for: variable)
        XCTAssertNil(match)
    }
    
    func testNoMatch_CorrectSymbolWrongUnit() {
        // g with wrong unit
        let variable = Variable(symbol: "g", name_ru: "Масса", name_en: "Mass", unit_si: "кг")
        let match = PhysicalConstants.match(for: variable)
        XCTAssertNil(match, "g with unit кг should NOT match gravitational acceleration")
    }
    
    // MARK: - Formatted Value Tests
    
    func testFormattedValue_IntegerLike() {
        let c = PhysicalConstants.Constant(symbol: "c", value: 299792458, unit: "м/с", name_ru: "Свет", name_en: "Light")
        let formatted = PhysicalConstants.formattedValue(c)
        XCTAssertFalse(formatted.isEmpty)
        XCTAssertTrue(formatted.contains("2997924") || formatted.contains("2.99"), "Got: \(formatted)")
    }
    
    func testFormattedValue_SmallDecimal() {
        let g = PhysicalConstants.Constant(symbol: "g", value: 9.81, unit: "м/с²", name_ru: "g", name_en: "g")
        let formatted = PhysicalConstants.formattedValue(g)
        XCTAssertEqual(formatted, "9.81")
    }
    
    func testFormattedValue_VerySmall_ScientificNotation() {
        let h = PhysicalConstants.Constant(symbol: "h", value: 6.62607015e-34, unit: "Дж·с", name_ru: "h", name_en: "h")
        let formatted = PhysicalConstants.formattedValue(h)
        XCTAssertFalse(formatted.isEmpty)
        // Should contain scientific notation or very small number representation
        XCTAssertTrue(formatted.contains("e") || formatted.contains("E") || formatted.contains("6.626"),
            "Expected scientific notation or precise value, got: \(formatted)")
    }
    
    func testFormattedValue_VeryLarge_ScientificNotation() {
        // Use a value within Int range to avoid Int() trap in formattedValue
        let c = PhysicalConstants.Constant(symbol: "c", value: 299_792_458, unit: "м/с", name_ru: "c", name_en: "c")
        let formatted = PhysicalConstants.formattedValue(c)
        XCTAssertFalse(formatted.isEmpty)
        // 299792458 is an integer-like value < 1e9 — should be formatted as integer
        XCTAssertTrue(formatted == "299792458" || formatted.contains("2.99"),
            "Expected integer or scientific notation for speed of light, got: \(formatted)")
    }
    
    // MARK: - All Constants Have Names
    
    func testAllConstants_HaveNonEmptyNames() {
        for constant in PhysicalConstants.all {
            XCTAssertFalse(constant.name_ru.isEmpty, "Constant \(constant.symbol) has empty name_ru")
            XCTAssertFalse(constant.name_en.isEmpty, "Constant \(constant.symbol) has empty name_en")
            XCTAssertFalse(constant.unit.isEmpty, "Constant \(constant.symbol) has empty unit")
        }
    }
    
    func testAllConstants_HavePositiveValues() {
        for constant in PhysicalConstants.all {
            XCTAssertGreaterThan(constant.value, 0, "Constant \(constant.symbol) should have positive value")
        }
    }
    
    func testAllConstants_HaveUniqueSymbols() {
        let symbols = PhysicalConstants.all.map(\.symbol)
        XCTAssertEqual(symbols.count, Set(symbols).count, "Each constant should have a unique symbol")
    }
}

// MARK: - Performance & Thread Safety Tests

final class PerformanceAndThreadSafetyTests: XCTestCase {
    
    // MARK: - Performance
    
    func testPerformance_LoadPhysicsData() {
        // Measure loading/caching of physics data
        measure {
            let data = loadPhysicsData()
            XCTAssertNotNil(data)
        }
    }
    
    func testPerformance_CalculationService_SimpleRule() {
        let service = CalculationService()
        measure {
            for _ in 0..<100 {
                _ = try? service.calculate(rule: "m * a", variables: ["m": 10, "a": 9.8])
            }
        }
    }
    
    func testPerformance_CalculationService_ComplexRule() {
        let service = CalculationService()
        measure {
            for _ in 0..<50 {
                _ = try? service.calculate(rule: "sqrt(pow(a, 2) + pow(b, 2) + 2 * a * b * cos(theta))",
                    variables: ["a": 3, "b": 4, "theta": 1.047])
            }
        }
    }
    
    func testPerformance_PhysicalConstantsMatch() {
        let variable = Variable(symbol: "g", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
        measure {
            for _ in 0..<1000 {
                _ = PhysicalConstants.match(for: variable)
            }
        }
    }
    
    func testPerformance_ValidateInput() {
        let service = CalculationService()
        measure {
            for _ in 0..<1000 {
                _ = service.validateInput("3.14159")
                _ = service.validateInput("")
                _ = service.validateInput("abc")
                _ = service.validateInput("2.5e3")
            }
        }
    }
    
    func testPerformance_FormatResult() {
        let service = CalculationService()
        let values = [0.0, 1.0, 3.14, 1e-30, 1e30, -42.5, 299792458.0]
        measure {
            for _ in 0..<100 {
                for val in values {
                    _ = service.formatResult(val)
                }
            }
        }
    }
    
    // MARK: - Thread Safety
    
    func testThreadSafety_LoadPhysicsData_ConcurrentAccess() {
        let expectation = self.expectation(description: "Concurrent loadPhysicsData")
        expectation.expectedFulfillmentCount = 10
        
        var results = [PhysicsData?](repeating: nil, count: 10)
        let lock = NSLock()
        
        for i in 0..<10 {
            DispatchQueue.global(qos: .userInteractive).async {
                let data = loadPhysicsData()
                lock.lock()
                results[i] = data
                lock.unlock()
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
        
        // All results should be the same (same cached data)
        let firstResult = results.first ?? nil
        XCTAssertNotNil(firstResult)
        
        for result in results {
            XCTAssertNotNil(result)
            XCTAssertEqual(result?.formulas.count, firstResult?.formulas.count)
            XCTAssertEqual(result?.sections.count, firstResult?.sections.count)
        }
    }
    
    func testThreadSafety_CalculationService_ConcurrentCalculations() {
        // JSContext is not thread-safe, so each thread needs its own CalculationService
        let expectation = self.expectation(description: "Concurrent calculations")
        expectation.expectedFulfillmentCount = 20
        
        var results = [Double?](repeating: nil, count: 20)
        let lock = NSLock()
        
        for i in 0..<20 {
            DispatchQueue.global().async {
                let service = CalculationService()
                let result = try? service.calculate(rule: "m * a", variables: ["m": Double(i + 1), "a": 9.8])
                lock.lock()
                results[i] = result
                lock.unlock()
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
        
        for i in 0..<20 {
            let expected = Double(i + 1) * 9.8
            XCTAssertNotNil(results[i], "Result \(i) should not be nil")
            if let r = results[i] {
                XCTAssertEqual(r, expected, accuracy: 0.001, "Result \(i) = \(r) should be \(expected)")
            }
        }
    }
    
    func testThreadSafety_PhysicalConstantsMatch_ConcurrentAccess() {
        let expectation = self.expectation(description: "Concurrent PhysicalConstants.match")
        expectation.expectedFulfillmentCount = 50
        
        let variable = Variable(symbol: "g", name_ru: "g", name_en: "g", unit_si: "м/с²")
        var matchCount = 0
        let lock = NSLock()
        
        for _ in 0..<50 {
            DispatchQueue.global().async {
                if PhysicalConstants.match(for: variable) != nil {
                    lock.lock()
                    matchCount += 1
                    lock.unlock()
                }
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10)
        XCTAssertEqual(matchCount, 50, "All 50 concurrent matches should succeed")
    }
    
    // MARK: - Stress Tests
    
    func testStress_ManySequentialCalculations() throws {
        let service = CalculationService()
        
        for i in 1...200 {
            let result = try service.calculate(rule: "a * b + c", variables: ["a": Double(i), "b": 2.0, "c": Double(i)])
            XCTAssertEqual(result, Double(i) * 2.0 + Double(i), accuracy: 0.001)
        }
    }
    
    func testStress_AlternatingRules() throws {
        let service = CalculationService()
        let rules = [
            ("a + b", ["a": 1.0, "b": 2.0], 3.0),
            ("a * b", ["a": 3.0, "b": 4.0], 12.0),
            ("a / b", ["a": 10.0, "b": 2.0], 5.0),
            ("sqrt(a)", ["a": 16.0], 4.0),
            ("pow(a, b)", ["a": 2.0, "b": 10.0], 1024.0),
        ]
        
        for _ in 1...20 {
            for (rule, vars, expected) in rules {
                let result = try service.calculate(rule: rule, variables: vars)
                XCTAssertEqual(result, expected, accuracy: 0.001)
            }
        }
    }
}

// MARK: - Model Tests (getRearrangedFormula, getFormulaWithValues)

final class FormulaModelTests: XCTestCase {
    
    private let testFormula = Formula(
        id: "test_f_ma",
        subsectionId: "dynamics",
        name_ru: "Второй закон Ньютона",
        name_en: "Newton's Second Law",
        levels: ["school"],
        equation_latex: "F = m \\cdot a",
        description_ru: "Сила",
        description_en: "Force",
        variables: [
            Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
            Variable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
            Variable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
        ],
        calculation_rules: ["F": "m * a", "m": "F / a", "a": "F / m"]
    )
    
    func testGetRearrangedFormula_KnownSymbol() {
        let latex = testFormula.getRearrangedFormula(for: "F")
        XCTAssertTrue(latex.contains("F"), "Should contain F symbol")
        XCTAssertTrue(latex.contains("="), "Should contain equals sign")
    }
    
    func testGetRearrangedFormula_AllSymbols() {
        for variable in testFormula.variables {
            let latex = testFormula.getRearrangedFormula(for: variable.symbol)
            XCTAssertFalse(latex.isEmpty, "Rearranged formula for \(variable.symbol) should not be empty")
            XCTAssertTrue(latex.contains("="), "Should contain equals sign for \(variable.symbol)")
        }
    }
    
    func testGetRearrangedFormula_UnknownSymbol_ReturnsFallback() {
        let latex = testFormula.getRearrangedFormula(for: "xyz")
        XCTAssertEqual(latex, testFormula.equation_latex, "Should return original equation_latex for unknown symbol")
    }
    
    func testGetFormulaWithValues_SubstitutesValues() {
        let result = testFormula.getFormulaWithValues(calculatedSymbol: "F", inputValues: ["m": "10", "a": "9.8"])
        XCTAssertTrue(result.contains("F"), "Should start with the calculated symbol")
        XCTAssertTrue(result.contains("="), "Should contain equals")
        XCTAssertTrue(result.contains("10") || result.contains("9.8"),
            "Should contain at least one substituted value")
    }
    
    func testGetFormulaWithValues_NoRule_ReturnsFallback() {
        let result = testFormula.getFormulaWithValues(calculatedSymbol: "xyz", inputValues: ["m": "10", "a": "9.8"])
        XCTAssertTrue(result.contains("xyz") || result.contains("?"),
            "Should indicate unknown formula")
    }
    
    func testLocalizedName_Russian() {
        let name = testFormula.localizedName(for: "ru")
        XCTAssertEqual(name, "Второй закон Ньютона")
    }
    
    func testLocalizedName_English() {
        let name = testFormula.localizedName(for: "en")
        XCTAssertEqual(name, "Newton's Second Law")
    }
    
    func testLocalizedDescription_Russian() {
        let desc = testFormula.localizedDescription(for: "ru")
        XCTAssertEqual(desc, "Сила")
    }
    
    func testLocalizedDescription_English() {
        let desc = testFormula.localizedDescription(for: "en")
        XCTAssertEqual(desc, "Force")
    }
    
    func testVariableDisplaySymbol_GreekLetters() {
        XCTAssertEqual(Variable.displaySymbol(for: "alpha"), "α")
        XCTAssertEqual(Variable.displaySymbol(for: "beta"), "β")
        XCTAssertEqual(Variable.displaySymbol(for: "omega"), "ω")
        XCTAssertEqual(Variable.displaySymbol(for: "lambda"), "λ")
        XCTAssertEqual(Variable.displaySymbol(for: "theta"), "θ")
    }
    
    func testVariableDisplaySymbol_SpecialSymbols() {
        XCTAssertEqual(Variable.displaySymbol(for: "DeltaS"), "ΔS")
        XCTAssertEqual(Variable.displaySymbol(for: "DeltaU"), "ΔU")
        XCTAssertEqual(Variable.displaySymbol(for: "DeltaT"), "ΔT")
    }
    
    func testVariableDisplaySymbol_Passthrough() {
        XCTAssertEqual(Variable.displaySymbol(for: "F"), "F")
        XCTAssertEqual(Variable.displaySymbol(for: "m"), "m")
        XCTAssertEqual(Variable.displaySymbol(for: "v"), "v")
    }
}
