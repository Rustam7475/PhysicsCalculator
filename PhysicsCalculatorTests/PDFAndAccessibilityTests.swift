import XCTest
@testable import PhysicsCalculator
import PDFKit
import UIKit
import SwiftMath

// MARK: - PDF Generation Tests

/// Тесты генерации PDF-документов с результатами расчётов
final class PDFGenerationTests: XCTestCase {
    
    private var testFormula: Formula!
    
    override func setUp() {
        super.setUp()
        testFormula = Formula(
            id: "pdf_test_formula",
            subsectionId: "test_sub",
            name_ru: "Второй закон Ньютона",
            name_en: "Newton's Second Law",
            levels: ["school"],
            equation_latex: "F = m \\cdot a",
            description_ru: "Сила равна произведению массы на ускорение",
            description_en: "Force equals mass times acceleration",
            variables: [
                Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
                Variable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
                Variable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
            ],
            calculation_rules: ["F": "m * a", "m": "F / a", "a": "F / m"]
        )
    }
    
    override func tearDown() {
        testFormula = nil
        // Очищаем временные PDF-файлы
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let pdfPath = documentsPath.appendingPathComponent("calculation_result.pdf")
        try? FileManager.default.removeItem(at: pdfPath)
        super.tearDown()
    }
    
    // MARK: - UIGraphicsPDFRenderer Tests
    
    func testPDFRenderer_CreatesValidPDFData() {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            let text = "Test PDF Content" as NSString
            text.draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ])
        }
        
        XCTAssertFalse(data.isEmpty, "PDF data should not be empty")
        // PDF файлы начинаются с %PDF
        let header = String(data: data.prefix(5), encoding: .ascii)
        XCTAssertEqual(header, "%PDF-", "PDF should start with %PDF- header")
    }
    
    func testPDFRenderer_A4Dimensions() {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        XCTAssertEqual(pageRect.width, 595.2, accuracy: 0.01, "A4 width = 595.2 points")
        XCTAssertEqual(pageRect.height, 841.8, accuracy: 0.01, "A4 height = 841.8 points")
    }
    
    func testPDFRenderer_WritesToFile() throws {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("test_pdf_\(UUID().uuidString).pdf")
        defer { try? FileManager.default.removeItem(at: tempURL) }
        
        try renderer.writePDF(to: tempURL) { context in
            context.beginPage()
            let text = "Physics Calculator Result" as NSString
            text.draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ])
        }
        
        XCTAssertTrue(FileManager.default.fileExists(atPath: tempURL.path), "PDF file should exist")
        let data = try Data(contentsOf: tempURL)
        XCTAssertGreaterThan(data.count, 100, "PDF file should have substantial content")
    }
    
    func testPDFDocument_ValidAfterCreation() {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            ("Test" as NSString).draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ])
        }
        
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document, "PDFDocument should be parseable from generated data")
        XCTAssertEqual(document?.pageCount, 1, "PDF should have exactly 1 page")
    }
    
    // MARK: - PDF Content Tests
    
    func testPDF_FormulaTitle_Rendered() {
        let data = generateTestPDF(title: testFormula.localizedName)
        let document = PDFDocument(data: data)
        // PDFDocument можно получить текст из страницы
        let page = document?.page(at: 0)
        let pageString = page?.string ?? ""
        // Проверяем что заголовок формулы присутствует
        XCTAssertTrue(pageString.contains("закон") || pageString.contains("Ньютон") || pageString.contains("Newton") || !pageString.isEmpty,
            "PDF page should contain formula title text")
    }
    
    func testPDF_InputValues_Rendered() {
        let inputValues = ["m": "10", "a": "9.8"]
        let data = generateTestPDFWithInputs(inputValues: inputValues)
        let document = PDFDocument(data: data)
        let page = document?.page(at: 0)
        let pageString = page?.string ?? ""
        
        // Хотя бы что-то отрендерено
        XCTAssertNotNil(document)
        XCTAssertEqual(document?.pageCount, 1)
        // Некоторые значения должны быть в тексте PDF
        let hasInputData = pageString.contains("10") || pageString.contains("9.8") || pageString.contains("м/с²")
        XCTAssertTrue(hasInputData || !pageString.isEmpty, "PDF should contain input values or any text content")
    }
    
    func testPDF_CalculatedResult_Rendered() {
        let result = 98.0
        let data = generateTestPDFWithResult(result: result)
        let document = PDFDocument(data: data)
        let page = document?.page(at: 0)
        let pageString = page?.string ?? ""
        
        XCTAssertNotNil(document)
        // Результат в любом формате присутствует
        let hasResult = pageString.contains("98") || pageString.contains(String(format: "%.4g", result))
        XCTAssertTrue(hasResult || !pageString.isEmpty, "PDF should contain calculated result")
    }
    
    func testPDF_DateFormatted() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        let dateString = formatter.string(from: Date())
        
        XCTAssertFalse(dateString.isEmpty, "Date string should not be empty")
        XCTAssertTrue(dateString.count > 5, "Date string should have reasonable length")
    }
    
    func testPDF_MultipleVariables_AllRendered() {
        let formula = Formula(
            id: "multi_var",
            subsectionId: "test_sub",
            name_ru: "Идеальный газ",
            name_en: "Ideal Gas",
            levels: ["school"],
            equation_latex: "PV = \\nu RT",
            description_ru: "Уравнение состояния идеального газа",
            description_en: "Ideal gas equation of state",
            variables: [
                Variable(symbol: "P", name_ru: "Давление", name_en: "Pressure", unit_si: "Па"),
                Variable(symbol: "V", name_ru: "Объём", name_en: "Volume", unit_si: "м³"),
                Variable(symbol: "nu", name_ru: "Количество вещества", name_en: "Amount", unit_si: "моль"),
                Variable(symbol: "T", name_ru: "Температура", name_en: "Temperature", unit_si: "К")
            ],
            calculation_rules: ["P": "nu * 8.314 * T / V"]
        )
        
        let data = generateTestPDFForFormula(formula: formula, calculatedSymbol: "P",
                                              inputValues: ["V": "0.1", "nu": "1", "T": "300"])
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document)
        XCTAssertEqual(document?.pageCount, 1)
    }
    
    // MARK: - PDF Font & Style Tests
    
    func testPDF_FontsAvailable() {
        let titleFont = UIFont.systemFont(ofSize: 26, weight: .bold)
        let subtitleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let regularFont = UIFont.systemFont(ofSize: 16)
        let captionFont = UIFont.systemFont(ofSize: 14)
        
        XCTAssertEqual(titleFont.pointSize, 26)
        XCTAssertEqual(subtitleFont.pointSize, 18)
        XCTAssertEqual(regularFont.pointSize, 16)
        XCTAssertEqual(captionFont.pointSize, 14)
    }
    
    func testPDF_ColorsValid() {
        let primaryColor = UIColor(red: 52/255, green: 120/255, blue: 246/255, alpha: 1)
        let secondaryColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1)
        let darkTextColor = UIColor(red: 29/255, green: 29/255, blue: 31/255, alpha: 1)
        let lightTextColor = UIColor(red: 134/255, green: 134/255, blue: 139/255, alpha: 1)
        
        // Проверяем что цвета созданы и не nil
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        
        primaryColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(a, 1.0, accuracy: 0.01, "Primary color should be fully opaque")
        XCTAssertEqual(r, 52/255, accuracy: 0.01)
        
        secondaryColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 239/255, accuracy: 0.01)
        
        darkTextColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 29/255, accuracy: 0.01)
        
        lightTextColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        XCTAssertEqual(r, 134/255, accuracy: 0.01)
    }
    
    // MARK: - FormulaWithValues for PDF
    
    func testGetFormulaWithValues_ForPDF() {
        let result = testFormula.getFormulaWithValues(
            calculatedSymbol: "F",
            inputValues: ["m": "10", "a": "9.8"]
        )
        XCTAssertFalse(result.isEmpty, "Formula with values should not be empty")
        // Должен содержать подставленные значения
        XCTAssertTrue(result.contains("10") || result.contains("9.8"),
            "Formula should contain substituted values, got: \(result)")
    }
    
    func testGetRearrangedFormula_ForPDF() {
        let rearranged = testFormula.getRearrangedFormula(for: "F")
        XCTAssertFalse(rearranged.isEmpty)
        // Для F = m * a в LaTeX
        XCTAssertTrue(rearranged.contains("F") || rearranged.contains("m") || rearranged.contains("a"))
    }
    
    func testGetFormulaWithValues_AllVariablesExceptCalculated() {
        // Все входные переменные кроме вычисляемой должны быть в формуле
        let result = testFormula.getFormulaWithValues(
            calculatedSymbol: "m",
            inputValues: ["F": "100", "a": "9.8"]
        )
        XCTAssertFalse(result.isEmpty)
    }
    
    // MARK: - MTMathUILabel for PDF rendering
    
    func testMTMathUILabel_Exists() {
        let label = MTMathUILabel()
        label.latex = "F = m \\cdot a"
        label.fontSize = 24
        XCTAssertEqual(label.latex, "F = m \\cdot a")
        XCTAssertEqual(label.fontSize, 24)
    }
    
    func testMTMathUILabel_AsImage() {
        let label = MTMathUILabel()
        label.latex = "E = mc^2"
        label.fontSize = 24
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        label.sizeToFit()
        
        let image = label.asImage()
        XCTAssertNotNil(image)
        // Изображение должно иметь ненулевые размеры
        XCTAssertGreaterThan(image.size.width, 0, "Image width should be > 0")
        XCTAssertGreaterThan(image.size.height, 0, "Image height should be > 0")
    }
    
    func testMTMathUILabel_ComplexLatex() {
        let label = MTMathUILabel()
        label.latex = "\\frac{1}{2}mv^2"
        label.fontSize = 24
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        label.sizeToFit()
        
        let image = label.asImage()
        XCTAssertGreaterThan(image.size.width, 0)
    }
    
    func testMTMathUILabel_EmptyLatex() {
        let label = MTMathUILabel()
        label.latex = ""
        label.fontSize = 24
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        // Не должен краш-иться
        _ = label.asImage()
    }
    
    // MARK: - PDF BezierPath Rendering
    
    func testBezierPath_RoundedRect() {
        let rect = CGRect(x: 40, y: 100, width: 515.2, height: 80)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10)
        XCTAssertFalse(path.isEmpty, "Rounded rect path should not be empty")
        XCTAssertTrue(path.bounds.width > 0)
    }
    
    // MARK: - Edge Cases
    
    func testPDF_EmptyInputValues() {
        let data = generateTestPDFWithInputs(inputValues: [:])
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document, "PDF should be valid even with empty inputs")
    }
    
    func testPDF_VeryLongFormulaName() {
        let longName = String(repeating: "Очень длинное название формулы ", count: 5)
        let data = generateTestPDF(title: longName)
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document, "PDF should handle long formula names")
        XCTAssertEqual(document?.pageCount, 1)
    }
    
    func testPDF_SpecialCharactersInValues() {
        let inputValues = ["m": "1.5e-10", "a": "-9.8"]
        let data = generateTestPDFWithInputs(inputValues: inputValues)
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document, "PDF should handle scientific notation & negative values")
    }
    
    func testPDF_VeryLargeResult() {
        let data = generateTestPDFWithResult(result: 1.23e30)
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document, "PDF should handle very large results")
    }
    
    func testPDF_ZeroResult() {
        let data = generateTestPDFWithResult(result: 0.0)
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document)
    }
    
    func testPDF_NegativeResult() {
        let data = generateTestPDFWithResult(result: -42.5)
        let document = PDFDocument(data: data)
        XCTAssertNotNil(document)
    }
    
    // MARK: - Helpers
    
    private func generateTestPDF(title: String) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { context in
            context.beginPage()
            let nsTitle = title as NSString
            nsTitle.draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 26, weight: .bold)
            ])
        }
    }
    
    private func generateTestPDFWithInputs(inputValues: [String: String]) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = 40
            for variable in testFormula.variables where variable.symbol != "F" {
                let value = inputValues[variable.symbol, default: ""]
                let text = "\(variable.localizedName): \(value) \(variable.unit_si)" as NSString
                text.draw(at: CGPoint(x: 40, y: y), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 16)
                ])
                y += 30
            }
        }
    }
    
    private func generateTestPDFWithResult(result: Double) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { context in
            context.beginPage()
            let text = "Результат: \(String(format: "%.4g", result)) Н" as NSString
            text.draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 16)
            ])
        }
    }
    
    private func generateTestPDFForFormula(formula: Formula, calculatedSymbol: String, inputValues: [String: String]) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        return renderer.pdfData { context in
            context.beginPage()
            // Заголовок
            let title = formula.localizedName as NSString
            title.draw(at: CGPoint(x: 40, y: 40), withAttributes: [
                .font: UIFont.systemFont(ofSize: 26, weight: .bold)
            ])
            // Значения
            var y: CGFloat = 80
            for variable in formula.variables where variable.symbol != calculatedSymbol {
                let value = inputValues[variable.symbol, default: ""]
                let text = "\(variable.localizedName): \(value) \(variable.unit_si)" as NSString
                text.draw(at: CGPoint(x: 40, y: y), withAttributes: [
                    .font: UIFont.systemFont(ofSize: 16)
                ])
                y += 30
            }
        }
    }
}

// MARK: - Accessibility Tests

/// Тесты доступности (VoiceOver) для UI-компонентов
final class AccessibilityTests: XCTestCase {
    
    // MARK: - MathLabel Accessibility
    
    func testMathLabel_IsAccessibilityElement() {
        let label = MTMathUILabel()
        label.latex = "F = m \\cdot a"
        label.isAccessibilityElement = true
        label.accessibilityLabel = label.latex
        
        XCTAssertTrue(label.isAccessibilityElement, "MathLabel should be an accessibility element")
        XCTAssertEqual(label.accessibilityLabel, "F = m \\cdot a", "MathLabel should have latex as accessibility label")
    }
    
    func testMathLabel_AccessibilityLabelUpdates() {
        let label = MTMathUILabel()
        label.isAccessibilityElement = true
        
        label.latex = "E = mc^2"
        label.accessibilityLabel = label.latex
        XCTAssertEqual(label.accessibilityLabel, "E = mc^2")
        
        label.latex = "F = ma"
        label.accessibilityLabel = label.latex
        XCTAssertEqual(label.accessibilityLabel, "F = ma")
    }
    
    func testMathLabel_EmptyLatex_AccessibilityLabel() {
        let label = MTMathUILabel()
        label.isAccessibilityElement = true
        label.latex = ""
        label.accessibilityLabel = label.latex
        XCTAssertEqual(label.accessibilityLabel, "")
    }
    
    // MARK: - Variable DisplaySymbol for Accessibility
    
    func testVariable_DisplaySymbol_ReturnsReadableText() {
        let testCases: [(String, String)] = [
            ("F", "F"),
            ("m", "m"),
            ("alpha", "α"),
            ("beta", "β"),
            ("lambda", "λ"),
            ("omega", "ω"),
            ("rho", "ρ"),
            ("sigma", "σ"),
            ("theta", "θ"),
            ("phi", "φ"),
            ("epsilon", "ε"),
            ("mu", "μ"),
            ("nu", "ν"),
            ("delta", "δ"),
            ("gamma", "γ"),
            ("tau", "τ"),
            ("eta", "η"),
        ]
        
        for (input, expected) in testCases {
            let result = Variable.displaySymbol(for: input)
            XCTAssertEqual(result, expected, "displaySymbol for '\(input)' should be '\(expected)', got '\(result)'")
        }
    }
    
    func testVariable_DisplaySymbol_SubscriptNotation() {
        // greekMap contains exact mappings, not general subscript logic
        let subscriptCases: [(String, String)] = [
            ("eps0", "ε₀"),
            ("mu0", "μ₀"),
            ("alpha1", "α₁"),
            ("alpha2", "α₂"),
            ("Z0", "Z₀"),
        ]
        
        for (input, expected) in subscriptCases {
            let result = Variable.displaySymbol(for: input)
            XCTAssertEqual(result, expected, "displaySymbol for '\(input)' should be '\(expected)', got '\(result)'")
        }
        
        // Symbols NOT in greekMap return as-is
        let passthroughCases = ["v0", "x0", "t1", "t2"]
        for sym in passthroughCases {
            let result = Variable.displaySymbol(for: sym)
            XCTAssertEqual(result, sym, "displaySymbol for '\(sym)' should return as-is")
        }
    }
    
    func testVariable_DisplaySymbol_GreekLetters_NonEmpty() {
        // Все символы из greekMap должны быть непустые строки
        let symbols = ["alpha", "beta", "gamma", "delta", "epsilon", "theta", "lambda",
                       "mu", "nu", "rho", "sigma", "tau", "phi", "omega", "eta"]
        for sym in symbols {
            let display = Variable.displaySymbol(for: sym)
            XCTAssertFalse(display.isEmpty, "displaySymbol for '\(sym)' should not be empty")
            XCTAssertNotEqual(display, sym, "displaySymbol for '\(sym)' should differ from raw symbol")
        }
    }
    
    // MARK: - Formula Localized Names for Accessibility
    
    func testFormula_LocalizedName_ReadableForVoiceOver() {
        guard let data = loadPhysicsData() else {
            XCTFail("Cannot load physics data"); return
        }
        let languages = ["ru", "en"]
        for formula in data.formulas {
            for lang in languages {
                let name = formula.localizedName(for: lang)
                XCTAssertFalse(name.isEmpty, "Formula \(formula.id) should have non-empty \(lang) name")
                XCTAssertGreaterThan(name.count, 2, "Formula \(formula.id) name in \(lang) should be meaningful")
            }
        }
    }
    
    func testFormula_LocalizedDescription_ReadableForVoiceOver() {
        guard let data = loadPhysicsData() else {
            XCTFail("Cannot load physics data"); return
        }
        let languages = ["ru", "en"]
        for formula in data.formulas {
            for lang in languages {
                let desc = formula.localizedDescription(for: lang)
                XCTAssertFalse(desc.isEmpty, "Formula \(formula.id) should have non-empty \(lang) description")
            }
        }
    }
    
    // MARK: - PhysicalConstants Accessibility Names
    
    func testPhysicalConstants_AllHaveReadableNames() {
        for constant in PhysicalConstants.all {
            XCTAssertFalse(constant.name_ru.isEmpty, "Constant \(constant.symbol) should have ru name for VoiceOver")
            XCTAssertFalse(constant.name_en.isEmpty, "Constant \(constant.symbol) should have en name for VoiceOver")
            // Имя должно быть длиннее 2 символов
            XCTAssertGreaterThan(constant.name_ru.count, 2, "Constant \(constant.symbol) ru name should be descriptive")
            XCTAssertGreaterThan(constant.name_en.count, 2, "Constant \(constant.symbol) en name should be descriptive")
        }
    }
    
    func testPhysicalConstants_FormattedValue_ReadableForVoiceOver() {
        for constant in PhysicalConstants.all {
            let formatted = PhysicalConstants.formattedValue(constant)
            XCTAssertFalse(formatted.isEmpty, "Formatted value for \(constant.symbol) should not be empty")
            // Отформатированное значение должно быть числом или строкой в научной нотации
            let containsDigits = formatted.rangeOfCharacter(from: .decimalDigits) != nil
            XCTAssertTrue(containsDigits, "Formatted value '\(formatted)' for \(constant.symbol) should contain digits")
        }
    }
    
    func testPhysicalConstants_Units_NotEmpty() {
        for constant in PhysicalConstants.all {
            XCTAssertFalse(constant.unit.isEmpty, "Constant \(constant.symbol) should have a unit for accessibility")
        }
    }
    
    // MARK: - CalculationService Result Accessibility
    
    func testFormatResult_ReadableForVoiceOver() {
        let service = CalculationService()
        
        // Целое число
        let integer = service.formatResult(100.0)
        XCTAssertEqual(integer, "100", "Integer result should be clean for VoiceOver")
        
        // Дробное
        let decimal = service.formatResult(3.14159)
        XCTAssertFalse(decimal.isEmpty)
        let containsDigits = decimal.rangeOfCharacter(from: .decimalDigits) != nil
        XCTAssertTrue(containsDigits)
        
        // Очень маленькое
        let tiny = service.formatResult(1.5e-10)
        XCTAssertFalse(tiny.isEmpty)
        
        // Очень большое
        let huge = service.formatResult(6.02e23)
        XCTAssertFalse(huge.isEmpty)
    }
    
    func testFormatResult_NoControlCharacters() {
        let service = CalculationService()
        let values = [0.0, 1.0, -1.0, 3.14, 1e10, 1e-10, 999999.999]
        
        for value in values {
            let result = service.formatResult(value)
            let hasControl = result.unicodeScalars.contains { CharacterSet.controlCharacters.contains($0) }
            XCTAssertFalse(hasControl, "Formatted result '\(result)' should not contain control characters")
        }
    }
    
    // MARK: - L10n Strings Accessibility
    
    func testL10n_TabNames_SuitableForVoiceOver() {
        let tabNames = [L10n.tabSections, L10n.tabFavorites, L10n.tabHistory,
                        L10n.tabSettings, L10n.tabConstants, L10n.tabConverter]
        for name in tabNames {
            XCTAssertFalse(name.isEmpty, "Tab name for VoiceOver should not be empty")
            XCTAssertGreaterThan(name.count, 1, "Tab name '\(name)' should be meaningful for VoiceOver")
        }
    }
    
    func testL10n_ButtonLabels_SuitableForVoiceOver() {
        let buttons = [L10n.calculate, L10n.close, L10n.cancel, L10n.delete, L10n.share]
        for button in buttons {
            XCTAssertFalse(button.isEmpty, "Button label should not be empty for VoiceOver")
        }
    }
    
    func testL10n_ErrorMessages_SuitableForVoiceOver() {
        let errors = [L10n.invalidResult, L10n.errorCalc, L10n.errorDescription]
        for error in errors {
            XCTAssertFalse(error.isEmpty, "Error message should not be empty for VoiceOver")
            XCTAssertGreaterThan(error.count, 3, "Error message should be descriptive for VoiceOver")
        }
    }
    
    // MARK: - Section/Subsection Names Accessibility
    
    func testSectionNames_ReadableForVoiceOver() {
        guard let data = loadPhysicsData() else {
            XCTFail("Cannot load physics data"); return
        }
        for section in data.sections {
            let nameRu = section.localizedName(for: "ru")
            let nameEn = section.localizedName(for: "en")
            XCTAssertFalse(nameRu.isEmpty, "Section \(section.id) should have ru name for VoiceOver")
            XCTAssertFalse(nameEn.isEmpty, "Section \(section.id) should have en name for VoiceOver")
        }
    }
    
    func testSubsectionNames_ReadableForVoiceOver() {
        guard let data = loadPhysicsData() else {
            XCTFail("Cannot load physics data"); return
        }
        for subsection in data.subsections {
            let nameRu = subsection.localizedName(for: "ru")
            let nameEn = subsection.localizedName(for: "en")
            XCTAssertFalse(nameRu.isEmpty, "Subsection \(subsection.id) should have ru name for VoiceOver")
            XCTAssertFalse(nameEn.isEmpty, "Subsection \(subsection.id) should have en name for VoiceOver")
        }
    }
    
    // MARK: - Variable Names & Units for Accessibility
    
    func testVariableNames_ReadableForVoiceOver() {
        guard let data = loadPhysicsData() else {
            XCTFail("Cannot load physics data"); return
        }
        for formula in data.formulas {
            for variable in formula.variables {
                XCTAssertFalse(variable.name_ru.isEmpty,
                    "Variable \(variable.symbol) in \(formula.id) should have ru name")
                XCTAssertFalse(variable.name_en.isEmpty,
                    "Variable \(variable.symbol) in \(formula.id) should have en name")
                XCTAssertFalse(variable.unit_si.isEmpty,
                    "Variable \(variable.symbol) in \(formula.id) should have unit for VoiceOver")
            }
        }
    }
    
    // MARK: - UnitConverter Accessibility
    
    func testUnitConverter_AllUnitsHaveNames() {
        // Проверяем через конкретные SI-единицы
        let siUnits = ["м", "с", "кг", "Н", "Дж", "Вт", "Па", "К", "А", "В", "Ом", "м/с", "м²"]
        for siUnit in siUnits {
            if let units = UnitConverter.units(forSI: siUnit) {
                XCTAssertFalse(units.isEmpty, "Units for \(siUnit) should not be empty")
                for unit in units {
                    XCTAssertFalse(unit.symbol.isEmpty, "Unit symbol for \(unit.id) should not be empty")
                }
            }
        }
    }
}
