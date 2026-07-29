import XCTest
@testable import PhysicsCalculator

/// Tests for the `L10n` localization system.
///
/// These were added after an incident where an accidental `rm` of two
/// L10n extension files (`L10n+Views.swift`, `L10n+Common.swift`) silently
/// dropped ~85 localized keys, and a subsequent data-corruption bug leaked
/// Cyrillic text into the Spanish translation of `favoritesEmpty`. Neither
/// issue was caught by the compiler (missing keys surfaced as compile
/// errors one-by-one; the corrupted translation compiled fine). These tests
/// guard against both classes of regression going forward.
final class L10nTests: XCTestCase {

    private var originalLanguageCode: String!

    override func setUp() {
        super.setUp()
        originalLanguageCode = AppSettings.shared.currentLanguageCode
    }

    override func tearDown() {
        AppSettings.shared.currentLanguageCode = originalLanguageCode
        super.tearDown()
    }

    private func setLanguage(_ code: String) {
        AppSettings.shared.currentLanguageCode = code
    }

    // MARK: - Core `t()` logic

    func testCode_MatchesAppSettingsCurrentLanguageCode() {
        setLanguage("de")
        XCTAssertEqual(L10n.code, "de")
    }

    func testT_ReturnsExactLanguageMatch_WhenAvailable() {
        setLanguage("fr")
        XCTAssertEqual(L10n.t(["en": "Hello", "fr": "Bonjour"]), "Bonjour")
    }

    func testT_FallsBackToEnglish_WhenCurrentLanguageMissing() {
        setLanguage("de")
        XCTAssertEqual(L10n.t(["en": "Hello", "ru": "Привет"]), "Hello")
    }

    func testT_ReturnsEmptyString_WhenNoMatchAndNoEnglishFallback() {
        setLanguage("de")
        XCTAssertEqual(L10n.t(["ru": "Привет"]), "")
    }

    // MARK: - Supported languages

    func testSupportedLanguages_AreExactlySixExpectedCodes() {
        XCTAssertEqual(AppConfiguration.supportedLanguages, ["ru", "en", "de", "es", "fr", "zh"])
    }

    /// One representative key from every L10n+ extension file, used to smoke-test
    /// completeness across all supported languages without relying on reflection
    /// (Swift has no clean way to enumerate all `static var` members of a type).
    private var representativeKeys: [(name: String, value: () -> String)] {
        [
            ("tabSections", { L10n.tabSections }),           // L10n+Common
            ("calculate", { L10n.calculate }),                // L10n+Common
            ("next", { L10n.next }),                          // L10n+Common
            ("selectUnknownVariable", { L10n.selectUnknownVariable }), // L10n+Errors
            ("invalidResult", { L10n.invalidResult }),        // L10n+Errors
            ("fileNotFound", { L10n.fileNotFound }),          // L10n+Errors
            ("sectionsTitle", { L10n.sectionsTitle }),        // L10n+Physics
            ("levelLabel", { L10n.levelLabel }),              // L10n+Physics
            ("nothingFound", { L10n.nothingFound }),          // L10n+Physics
            ("favoritesEmpty", { L10n.favoritesEmpty }),      // L10n+Views
            ("graph", { L10n.graph }),                        // L10n+Views
            ("stepByStep", { L10n.stepByStep }),               // L10n+Views
            ("stepOriginalFormula", { L10n.stepOriginalFormula }), // L10n+Views
            ("stepRearrange", { L10n.stepRearrange }),        // L10n+Views
            ("stepSubstitute", { L10n.stepSubstitute }),      // L10n+Views
            ("stepCalculate", { L10n.stepCalculate }),        // L10n+Views
        ]
    }

    func testRepresentativeKeys_AreNonEmpty_ForEverySupportedLanguage() {
        for code in AppConfiguration.supportedLanguages {
            setLanguage(code)
            for entry in representativeKeys {
                XCTAssertFalse(entry.value().isEmpty, "\(entry.name) is empty for language '\(code)'")
            }
        }
    }

    // MARK: - Parameterized error messages

    func testEnterCorrectValue_IncludesProvidedName() {
        setLanguage("en")
        XCTAssertTrue(L10n.enterCorrectValue("mass").contains("mass"))
    }

    func testNoRuleFor_IncludesProvidedSymbol() {
        setLanguage("en")
        XCTAssertTrue(L10n.noRuleFor("v").contains("v"))
    }

    func testEvaluationError_IncludesProvidedMessage() {
        setLanguage("ru")
        XCTAssertTrue(L10n.evaluationError("stack overflow").contains("stack overflow"))
    }

    func testDecodingError_IncludesProvidedError() {
        setLanguage("zh")
        XCTAssertTrue(L10n.decodingError("bad json").contains("bad json"))
    }

    // MARK: - Regression: translation content integrity
    //
    // Guards against the specific incident where Cyrillic text ("здесь") leaked
    // into the Spanish translation of `favoritesEmpty`.

    func testFavoritesEmpty_SpanishTranslation_MatchesExpectedText() {
        setLanguage("es")
        XCTAssertEqual(
            L10n.favoritesEmpty,
            "Todavía no hay nada aquí. Guarda fórmulas para un acceso rápido."
        )
    }

    func testNonRussianTranslations_ContainNoCyrillicCharacters() {
        let nonRussianLanguages = AppConfiguration.supportedLanguages.filter { $0 != "ru" }
        for code in nonRussianLanguages {
            setLanguage(code)
            for entry in representativeKeys {
                let value = entry.value()
                XCTAssertFalse(
                    containsCyrillic(value),
                    "\(entry.name) for language '\(code)' should not contain Cyrillic characters: \(value)"
                )
            }
        }
    }

    private func containsCyrillic(_ text: String) -> Bool {
        text.unicodeScalars.contains { (0x0400...0x04FF).contains($0.value) }
    }

    // MARK: - AppTheme localization (depends on L10n)

    func testAppTheme_LocalizedName_ChangesWithLanguage() {
        setLanguage("en")
        XCTAssertEqual(AppTheme.dark.localizedName, "Dark")
        setLanguage("ru")
        XCTAssertEqual(AppTheme.dark.localizedName, "Тёмная")
    }
}
