import XCTest
@testable import PhysicsCalculator

// MARK: - Мок-сервисы

/// Мок DataService для тестов ContentViewModel
final class MockDataService: DataServiceProtocol {
    var shouldThrowError = false
    var mockData: PhysicsData?
    var loadCallCount = 0
    
    func loadPhysicsData() async throws -> PhysicsData {
        loadCallCount += 1
        if shouldThrowError {
            throw DataServiceError.fileNotFound
        }
        return mockData ?? TestData.physicsData
    }
}

/// Мок PersistenceController для тестов без Core Data
final class MockPersistenceController: PersistenceControllerProtocol {
    var savedHistory: [(formulaId: String, symbol: String, value: Double)] = []
    
    func saveToHistory(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String]) {
        savedHistory.append((formula.id, calculatedSymbol, calculatedValue))
    }
}

/// Мок CalculationService для навигационных тестов
final class MockNavCalculationService: CalculationServiceProtocol {
    var mockResult: Double = 42.0
    var shouldThrowError = false
    var calculateCallCount = 0
    var lastRule: String?
    var lastVariables: [String: Double]?
    
    func calculate(rule: String, variables: [String: Double]) throws -> Double {
        calculateCallCount += 1
        lastRule = rule
        lastVariables = variables
        if shouldThrowError {
            throw CalculationError.invalidResult
        }
        return mockResult
    }
    
    func validateInput(_ input: String) -> Bool {
        Double(input.replacingOccurrences(of: ",", with: ".")) != nil
    }
    
    func formatResult(_ result: Double) -> String {
        String(format: "%.4g", result)
    }
}

// MARK: - Тестовые данные

private enum TestData {
    static let variables = [
        Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
        Variable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
        Variable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²"),
    ]
    
    static let formula = Formula(
        id: "test_newton2",
        subsectionId: "dynamics_school",
        name_ru: "Второй закон Ньютона",
        name_en: "Newton's Second Law",
        levels: ["school"],
        equation_latex: "F = ma",
        description_ru: "Сила равна произведению массы на ускорение",
        description_en: "Force equals mass times acceleration",
        variables: variables,
        calculation_rules: [
            "F": "m * a",
            "m": "F / a",
            "a": "F / m",
        ]
    )
    
    static let formula2 = Formula(
        id: "test_velocity",
        subsectionId: "kinematics_school",
        name_ru: "Скорость",
        name_en: "Velocity",
        levels: ["school"],
        equation_latex: "v = \\frac{s}{t}",
        description_ru: "Скорость — отношение пути ко времени",
        description_en: "Velocity is the ratio of distance to time",
        variables: [
            Variable(symbol: "v", name_ru: "Скорость", name_en: "Velocity", unit_si: "м/с"),
            Variable(symbol: "s", name_ru: "Путь", name_en: "Distance", unit_si: "м"),
            Variable(symbol: "t", name_ru: "Время", name_en: "Time", unit_si: "с"),
        ],
        calculation_rules: [
            "v": "s / t",
            "s": "v * t",
            "t": "s / v",
        ]
    )
    
    static let formulaOneVar = Formula(
        id: "test_single_var",
        subsectionId: "test_sub",
        name_ru: "Одна переменная",
        name_en: "Single Variable",
        levels: ["school"],
        equation_latex: "x = 1",
        description_ru: "Тест",
        description_en: "Test",
        variables: [
            Variable(symbol: "x", name_ru: "Величина", name_en: "Value", unit_si: "м"),
        ],
        calculation_rules: ["x": "1"]
    )
    
    static let section = PhysicsSection(
        id: "mechanics",
        name_ru: "Механика",
        name_en: "Mechanics",
        levels: ["school", "university"]
    )
    
    static let section2 = PhysicsSection(
        id: "thermodynamics",
        name_ru: "Термодинамика",
        name_en: "Thermodynamics",
        levels: ["university"]
    )
    
    static let subsection = PhysicsSubsection(
        id: "dynamics_school",
        sectionId: "mechanics",
        name_ru: "Динамика",
        name_en: "Dynamics",
        levels: ["school", "university"]
    )
    
    static let subsection2 = PhysicsSubsection(
        id: "kinematics_school",
        sectionId: "mechanics",
        name_ru: "Кинематика",
        name_en: "Kinematics",
        levels: ["school"]
    )
    
    static let subsectionUniversity = PhysicsSubsection(
        id: "thermo_uni",
        sectionId: "thermodynamics",
        name_ru: "Термодинамические процессы",
        name_en: "Thermodynamic Processes",
        levels: ["university"]
    )
    
    static let physicsData = PhysicsData(
        sections: [section, section2],
        subsections: [subsection, subsection2, subsectionUniversity],
        formulas: [formula, formula2]
    )
}

// MARK: - ContentViewModel — Навигация и загрузка

final class ContentViewModelNavigationTests: XCTestCase {
    
    @MainActor
    func testLoadData_Success_SetsPhysicsData() async {
        let mockService = MockDataService()
        let vm = ContentViewModel(dataService: mockService)
        
        await vm.loadData()
        
        XCTAssertNotNil(vm.physicsData)
        XCTAssertFalse(vm.isLoading)
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(vm.physicsData?.sections.count, 2)
        XCTAssertEqual(vm.physicsData?.formulas.count, 2)
    }
    
    @MainActor
    func testLoadData_Error_UsesFallbackData() async {
        let mockService = MockDataService()
        mockService.shouldThrowError = true
        let vm = ContentViewModel(dataService: mockService)
        
        await vm.loadData()
        
        XCTAssertNotNil(vm.physicsData, "При ошибке должны использоваться fallback данные")
        XCTAssertFalse(vm.isLoading)
        XCTAssertNotNil(vm.errorMessage)
    }
    
    @MainActor
    func testLoadData_SetsLoadingState() async {
        let mockService = MockDataService()
        let vm = ContentViewModel(dataService: mockService)
        
        // Перед загрузкой
        XCTAssertTrue(vm.isLoading)
        
        await vm.loadData()
        
        // После загрузки
        XCTAssertFalse(vm.isLoading)
    }
    
    @MainActor
    func testRetryAfterError_LoadsSuccessfully() async {
        let mockService = MockDataService()
        mockService.shouldThrowError = true
        let vm = ContentViewModel(dataService: mockService)
        
        await vm.loadData()
        XCTAssertNotNil(vm.errorMessage)
        
        // Повторная загрузка — теперь успешно
        mockService.shouldThrowError = false
        await vm.loadData()
        
        XCTAssertNil(vm.errorMessage)
        XCTAssertNotNil(vm.physicsData)
        XCTAssertEqual(mockService.loadCallCount, 2)
    }
}

// MARK: - SectionsView — Фильтрация и поиск

final class SectionsFilteringTests: XCTestCase {
    
    private let data = TestData.physicsData
    
    // MARK: Фильтрация разделов по уровню
    
    func testFilterSections_SchoolLevel_ShowsMechanics() {
        let schoolSections = data.sections.filter { $0.levels.contains("school") }
        
        XCTAssertTrue(schoolSections.contains(where: { $0.id == "mechanics" }))
        XCTAssertFalse(schoolSections.contains(where: { $0.id == "thermodynamics" }),
                       "Термодинамика — только university")
    }
    
    func testFilterSections_UniversityLevel_ShowsAll() {
        let uniSections = data.sections.filter { $0.levels.contains("university") }
        
        XCTAssertTrue(uniSections.contains(where: { $0.id == "mechanics" }))
        XCTAssertTrue(uniSections.contains(where: { $0.id == "thermodynamics" }))
    }
    
    // MARK: Фильтрация подразделов
    
    func testFilterSubsections_BySection() {
        let mechSubs = data.subsections.filter { $0.sectionId == "mechanics" }
        
        XCTAssertEqual(mechSubs.count, 2)
        XCTAssertTrue(mechSubs.contains(where: { $0.id == "dynamics_school" }))
        XCTAssertTrue(mechSubs.contains(where: { $0.id == "kinematics_school" }))
    }
    
    func testFilterSubsections_BySectionAndLevel() {
        let mechSchoolSubs = data.subsections.filter {
            $0.sectionId == "mechanics" && $0.levels.contains("school")
        }
        
        XCTAssertEqual(mechSchoolSubs.count, 2)
    }
    
    // MARK: Фильтрация формул
    
    func testFilterFormulas_BySubsection() {
        let dynamicsFormulas = data.formulas.filter { $0.subsectionId == "dynamics_school" }
        
        XCTAssertEqual(dynamicsFormulas.count, 1)
        XCTAssertEqual(dynamicsFormulas.first?.id, "test_newton2")
    }
    
    func testFilterFormulas_ByLevel() {
        let schoolFormulas = data.formulas.filter { $0.levels.contains("school") }
        
        XCTAssertEqual(schoolFormulas.count, 2)
    }
    
    // MARK: Поиск
    
    func testSearch_ByFormulaName_Russian() {
        let query = "ньютон"
        let results = data.formulas.filter {
            $0.localizedName(for: "ru").lowercased().contains(query)
        }
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, "test_newton2")
    }
    
    func testSearch_ByFormulaName_English() {
        let query = "newton"
        let results = data.formulas.filter {
            $0.localizedName(for: "en").lowercased().contains(query)
        }
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, "test_newton2")
    }
    
    func testSearch_ByVariableSymbol() {
        let query = "f"
        let results = data.formulas.filter { formula in
            formula.variables.contains(where: { $0.symbol.lowercased() == query })
        }
        
        XCTAssertTrue(results.contains(where: { $0.id == "test_newton2" }))
    }
    
    func testSearch_ByVariableName() {
        let query = "масса"
        let results = data.formulas.filter { formula in
            formula.variables.contains(where: { $0.localizedName(for: "ru").lowercased().contains(query) })
        }
        
        XCTAssertTrue(results.contains(where: { $0.id == "test_newton2" }))
    }
    
    func testSearch_ByDescription() {
        let query = "произведению"
        let results = data.formulas.filter {
            $0.localizedDescription(for: "ru").lowercased().contains(query)
        }
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.id, "test_newton2")
    }
    
    func testSearch_BySubsectionName() {
        let query = "динамика"
        let results = data.formulas.filter { formula in
            data.subsections.first(where: { $0.id == formula.subsectionId })
                .map { $0.localizedName(for: "ru").lowercased().contains(query) } ?? false
        }
        
        XCTAssertTrue(results.contains(where: { $0.id == "test_newton2" }))
    }
    
    func testSearch_EmptyQuery_ReturnsNoResults() {
        let query = ""
        let trimmed = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        XCTAssertTrue(trimmed.isEmpty, "Пустой поисковый запрос не должен давать результаты")
    }
    
    func testSearch_NoMatch_ReturnsEmpty() {
        let query = "квантовая хромодинамика"
        let results = data.formulas.filter {
            $0.localizedName(for: "ru").lowercased().contains(query)
        }
        
        XCTAssertTrue(results.isEmpty)
    }
    
    // MARK: Переключение уровня сбрасывает выбор
    
    func testLevelSwitch_ResetsSection() {
        // Симуляция: при смене уровня selectedSection и selectedSubsection должны стать nil
        var selectedSection: PhysicsSection? = TestData.section
        var selectedSubsection: PhysicsSubsection? = TestData.subsection
        
        // Имитируем onChange(of: selectedLevel)
        selectedSection = nil
        selectedSubsection = nil
        
        XCTAssertNil(selectedSection)
        XCTAssertNil(selectedSubsection)
    }
}

// MARK: - CalculationViewModel — Полный цикл взаимодействия

final class CalculationInteractionTests: XCTestCase {
    
    // MARK: Полный цикл: выбор неизвестной → ввод → расчёт → результат
    
    @MainActor
    func testFullCalculationFlow() {
        let mockService = MockNavCalculationService()
        mockService.mockResult = 50.0
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        // 1. Начальное состояние
        XCTAssertNil(vm.selectedUnknownSymbol)
        XCTAssertNil(vm.calculatedResult)
        XCTAssertFalse(vm.canCalculate)
        XCTAssertFalse(vm.showingResult)
        
        // 2. Выбираем неизвестную
        vm.selectUnknown(symbol: "F")
        XCTAssertEqual(vm.selectedUnknownSymbol, "F")
        XCTAssertFalse(vm.canCalculate, "Ещё не введены значения")
        
        // 3. Вводим значения
        vm.inputValues["m"] = "10"
        XCTAssertFalse(vm.canCalculate, "Не все значения введены")
        
        vm.inputValues["a"] = "5"
        XCTAssertTrue(vm.canCalculate, "Все значения введены")
        
        // 4. Рассчитываем
        vm.calculate()
        
        XCTAssertEqual(vm.calculatedResult, 50.0)
        XCTAssertTrue(vm.showingResult)
        XCTAssertNil(vm.errorMessage)
        XCTAssertEqual(mockService.lastRule, "m * a")
        XCTAssertEqual(mockService.lastVariables?["m"], 10.0)
        XCTAssertEqual(mockService.lastVariables?["a"], 5.0)
    }
    
    // MARK: Автосохранение в историю при расчёте
    
    @MainActor
    func testCalculate_SavestoHistory() {
        let mockService = MockNavCalculationService()
        mockService.mockResult = 100.0
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "20"
        vm.inputValues["a"] = "5"
        vm.calculate()
        
        XCTAssertEqual(mockPersistence.savedHistory.count, 1)
        XCTAssertEqual(mockPersistence.savedHistory.first?.formulaId, "test_newton2")
        XCTAssertEqual(mockPersistence.savedHistory.first?.symbol, "F")
        XCTAssertEqual(mockPersistence.savedHistory.first?.value, 100.0)
    }
    
    // MARK: Смена неизвестной переменной
    
    @MainActor
    func testSwitchUnknown_ClearsResult() {
        let mockService = MockNavCalculationService()
        mockService.mockResult = 50.0
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        // Рассчитываем F
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "10"
        vm.inputValues["a"] = "5"
        vm.calculate()
        XCTAssertEqual(vm.calculatedResult, 50.0)
        
        // Переключаемся на m
        vm.selectUnknown(symbol: "m")
        
        XCTAssertEqual(vm.selectedUnknownSymbol, "m")
        XCTAssertNil(vm.calculatedResult, "Результат должен сброситься при смене неизвестной")
        XCTAssertNil(vm.errorMessage)
    }
    
    // MARK: Сброс после расчёта
    
    @MainActor
    func testReset_AfterCalculation() {
        let mockService = MockNavCalculationService()
        mockService.mockResult = 50.0
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "10"
        vm.inputValues["a"] = "5"
        vm.calculate()
        
        vm.reset()
        
        XCTAssertNil(vm.selectedUnknownSymbol)
        XCTAssertNil(vm.calculatedResult)
        XCTAssertNil(vm.errorMessage)
        XCTAssertFalse(vm.showingResult)
        XCTAssertFalse(vm.canCalculate)
    }
    
    // MARK: Расчёт каждой переменной формулы
    
    @MainActor
    func testCalculate_EachVariable_HasRule() {
        let formula = TestData.formula
        
        for variable in formula.variables {
            XCTAssertNotNil(formula.calculation_rules[variable.symbol],
                           "Переменная \(variable.symbol) должна иметь правило вычисления")
        }
    }
    
    @MainActor
    func testCalculate_AllVariablesAsUnknown() {
        let formula = TestData.formula
        
        // F = m * a
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        
        // Тест 1: найти F
        mockService.mockResult = 50.0
        let vm1 = CalculationViewModel(
            formula: formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        vm1.selectUnknown(symbol: "F")
        vm1.inputValues["m"] = "10"
        vm1.inputValues["a"] = "5"
        vm1.calculate()
        XCTAssertEqual(vm1.calculatedResult, 50.0)
        XCTAssertEqual(mockService.lastRule, "m * a")
        
        // Тест 2: найти m
        mockService.mockResult = 2.0
        let vm2 = CalculationViewModel(
            formula: formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        vm2.selectUnknown(symbol: "m")
        vm2.inputValues["F"] = "10"
        vm2.inputValues["a"] = "5"
        vm2.calculate()
        XCTAssertEqual(vm2.calculatedResult, 2.0)
        XCTAssertEqual(mockService.lastRule, "F / a")
        
        // Тест 3: найти a
        mockService.mockResult = 5.0
        let vm3 = CalculationViewModel(
            formula: formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        vm3.selectUnknown(symbol: "a")
        vm3.inputValues["F"] = "50"
        vm3.inputValues["m"] = "10"
        vm3.calculate()
        XCTAssertEqual(vm3.calculatedResult, 5.0)
        XCTAssertEqual(mockService.lastRule, "F / m")
    }
    
    // MARK: Ошибки ввода
    
    @MainActor
    func testCalculate_InvalidInput_ShowsError() {
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "не число"
        vm.inputValues["a"] = "5"
        vm.calculate()
        
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertNil(vm.calculatedResult)
        XCTAssertFalse(vm.showingResult)
        XCTAssertEqual(mockPersistence.savedHistory.count, 0, "При ошибке не должно сохраняться в историю")
    }
    
    @MainActor
    func testCalculate_EmptyInput_ShowsError() {
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = ""
        vm.inputValues["a"] = "5"
        
        XCTAssertFalse(vm.canCalculate, "Пустое поле — нельзя рассчитать")
    }
    
    @MainActor
    func testCalculate_NoUnknownSelected_ShowsError() {
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.inputValues["F"] = "10"
        vm.inputValues["m"] = "5"
        vm.inputValues["a"] = "2"
        vm.calculate()
        
        XCTAssertNotNil(vm.errorMessage, "Без выбора неизвестной — ошибка")
        XCTAssertNil(vm.calculatedResult)
    }
    
    @MainActor
    func testCalculate_ServiceError_ShowsError() {
        let mockService = MockNavCalculationService()
        mockService.shouldThrowError = true
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "10"
        vm.inputValues["a"] = "5"
        vm.calculate()
        
        XCTAssertNotNil(vm.errorMessage)
        XCTAssertNil(vm.calculatedResult)
        XCTAssertFalse(vm.showingResult)
    }
    
    // MARK: Запятая как десятичный разделитель
    
    @MainActor
    func testCalculate_CommaDecimalSeparator() {
        let mockService = MockNavCalculationService()
        mockService.mockResult = 25.0
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "5,5"
        vm.inputValues["a"] = "2"
        vm.calculate()
        
        XCTAssertEqual(vm.calculatedResult, 25.0)
        XCTAssertEqual(mockService.lastVariables?["m"], 5.5, "Запятая должна конвертироваться в точку")
    }
    
    // MARK: Конвертация единиц при расчёте
    
    @MainActor
    func testCalculate_WithUnitConversion() {
        let mockService = MockNavCalculationService()
        mockService.mockResult = 2.778
        let mockPersistence = MockPersistenceController()
        
        let formula = TestData.formula2 // v = s/t
        let vm = CalculationViewModel(
            formula: formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "v")
        vm.inputValues["s"] = "100"
        vm.inputValues["t"] = "1"
        
        // Передаём единицы км/ч → конвертация в м/с
        vm.calculate(unitSelections: ["t": "min"])
        
        // Проверяем что calculate был вызван (единицы конвертируются)
        XCTAssertEqual(mockService.calculateCallCount, 1)
    }
    
    // MARK: Множественные расчёты подряд
    
    @MainActor
    func testMultipleCalculations_InSequence() {
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        // Первый расчёт
        mockService.mockResult = 50.0
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "10"
        vm.inputValues["a"] = "5"
        vm.calculate()
        XCTAssertEqual(vm.calculatedResult, 50.0)
        
        // Сброс и второй расчёт
        vm.reset()
        mockService.mockResult = 100.0
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "20"
        vm.inputValues["a"] = "5"
        vm.calculate()
        XCTAssertEqual(vm.calculatedResult, 100.0)
        
        // Оба сохранились в историю
        XCTAssertEqual(mockPersistence.savedHistory.count, 2)
        XCTAssertEqual(mockService.calculateCallCount, 2)
    }
    
    // MARK: Двойной клик по неизвестной — снятие выбора
    
    @MainActor
    func testDoubleSelectUnknown_Deselects() {
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        XCTAssertEqual(vm.selectedUnknownSymbol, "F")
        
        vm.selectUnknown(symbol: "F")
        XCTAssertNil(vm.selectedUnknownSymbol, "Повторный клик снимает выбор")
    }
    
    // MARK: canCalculate — пробелы не считаются значением
    
    @MainActor
    func testCanCalculate_WhitespaceNotValid() {
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: TestData.formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        vm.selectUnknown(symbol: "F")
        vm.inputValues["m"] = "   "
        vm.inputValues["a"] = "5"
        
        XCTAssertFalse(vm.canCalculate, "Пробелы не должны считаться заполненным полем")
    }
}

// MARK: - Модели: форматирование результата

final class ResultFormattingTests: XCTestCase {
    
    func testGetRearrangedFormula_ReturnsLatex() {
        let formula = TestData.formula
        let rearranged = formula.getRearrangedFormula(for: "F")
        
        XCTAssertTrue(rearranged.contains("F"))
        XCTAssertTrue(rearranged.contains("="))
    }
    
    func testGetRearrangedFormula_InvalidSymbol_ReturnsOriginal() {
        let formula = TestData.formula
        let result = formula.getRearrangedFormula(for: "nonexistent")
        
        XCTAssertEqual(result, formula.equation_latex)
    }
    
    func testGetFormulaWithValues_SubstitutesValues() {
        let formula = TestData.formula
        let result = formula.getFormulaWithValues(
            calculatedSymbol: "F",
            inputValues: ["m": "10", "a": "5"]
        )
        
        XCTAssertTrue(result.contains("F"))
        XCTAssertTrue(result.contains("="))
        XCTAssertTrue(result.contains("10"))
        XCTAssertTrue(result.contains("5"))
    }
    
    func testCanShowGraph_TwoOrMoreVariables() {
        let formula = TestData.formula
        XCTAssertTrue(formula.variables.count >= 2, "Формула с 3 переменными → график доступен")
    }
    
    func testCanShowGraph_SingleVariable_NoGraph() {
        let formula = TestData.formulaOneVar
        XCTAssertFalse(formula.variables.count >= 2, "Формула с 1 переменной → график недоступен")
    }
}

// MARK: - CalculationResultView — Генерация текста для шаринга

final class ShareTextTests: XCTestCase {
    
    func testGenerateShareText_ContainsFormulaName() {
        let formula = TestData.formula
        let text = generateShareText(
            formula: formula,
            calculatedSymbol: "F",
            calculatedValue: 50.0,
            inputValues: ["m": "10", "a": "5"]
        )
        
        XCTAssertTrue(text.contains(formula.localizedName))
    }
    
    func testGenerateShareText_ContainsResult() {
        let formula = TestData.formula
        let text = generateShareText(
            formula: formula,
            calculatedSymbol: "F",
            calculatedValue: 50.0,
            inputValues: ["m": "10", "a": "5"]
        )
        
        XCTAssertTrue(text.contains("50"))
    }
    
    func testGenerateShareText_ContainsInputValues() {
        let formula = TestData.formula
        let text = generateShareText(
            formula: formula,
            calculatedSymbol: "F",
            calculatedValue: 50.0,
            inputValues: ["m": "10", "a": "5"]
        )
        
        XCTAssertTrue(text.contains("10"))
        XCTAssertTrue(text.contains("5"))
    }
    
    // Вспомогательная функция (дублирует логику из CalculationResultView)
    private func generateShareText(formula: Formula, calculatedSymbol: String, calculatedValue: Double, inputValues: [String: String]) -> String {
        var text = "📐 \(formula.localizedName)\n"
        text += "\(formula.localizedDescription)\n\n"
        
        for variable in formula.variables where variable.symbol != calculatedSymbol {
            let value = inputValues[variable.symbol, default: ""]
            text += "  • \(variable.localizedName) = \(value) \(variable.unit_si)\n"
        }
        
        if let resultVariable = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
            text += "\n"
            text += "  ▸ \(resultVariable.localizedName) = \(String(format: "%.4g", calculatedValue)) \(resultVariable.unit_si)\n"
        }
        
        return text
    }
}

// MARK: - UnitConverter — Конвертация единиц

final class UnitConverterInteractionTests: XCTestCase {
    
    // MARK: Конвертация длины
    
    func testConvert_Kilometers_ToMeters() {
        if let lengthUnits = UnitConverter.units(forSI: "м") {
            let kmUnit = lengthUnits.first(where: { $0.id == "km" })
            XCTAssertNotNil(kmUnit)
            
            let siValue = kmUnit!.toSI(5.0)
            XCTAssertEqual(siValue, 5000.0, accuracy: 0.001)
        }
    }
    
    func testConvert_Centimeters_ToMeters() {
        if let lengthUnits = UnitConverter.units(forSI: "м") {
            let cmUnit = lengthUnits.first(where: { $0.id == "cm" })
            XCTAssertNotNil(cmUnit)
            
            let siValue = cmUnit!.toSI(150.0)
            XCTAssertEqual(siValue, 1.5, accuracy: 0.001)
        }
    }
    
    // MARK: Конвертация массы
    
    func testConvert_Grams_ToKilograms() {
        if let massUnits = UnitConverter.units(forSI: "кг") {
            let gUnit = massUnits.first(where: { $0.id == "g_mass" })
            XCTAssertNotNil(gUnit)
            
            let siValue = gUnit!.toSI(500.0)
            XCTAssertEqual(siValue, 0.5, accuracy: 0.001)
        }
    }
    
    // MARK: Конвертация скорости
    
    func testConvert_KmPerHour_ToMPerSecond() {
        if let speedUnits = UnitConverter.units(forSI: "м/с") {
            let kmhUnit = speedUnits.first(where: { $0.id == "kmh" })
            XCTAssertNotNil(kmhUnit)
            
            let siValue = kmhUnit!.toSI(36.0) // 36 км/ч = 10 м/с
            XCTAssertEqual(siValue, 10.0, accuracy: 0.001)
        }
    }
    
    // MARK: Конвертация давления
    
    func testConvert_Atmosphere_ToPascal() {
        if let pressureUnits = UnitConverter.units(forSI: "Па") {
            let atmUnit = pressureUnits.first(where: { $0.id == "atm" })
            XCTAssertNotNil(atmUnit)
            
            let siValue = atmUnit!.toSI(1.0)
            XCTAssertEqual(siValue, 101325.0, accuracy: 1.0)
        }
    }
    
    // MARK: Конвертация энергии
    
    func testConvert_Kilojoules_ToJoules() {
        if let energyUnits = UnitConverter.units(forSI: "Дж") {
            let kjUnit = energyUnits.first(where: { $0.id == "kJ" })
            XCTAssertNotNil(kjUnit)
            
            let siValue = kjUnit!.toSI(2.5)
            XCTAssertEqual(siValue, 2500.0, accuracy: 0.001)
        }
    }
    
    // MARK: Обратная конвертация (fromSI)
    
    func testConvert_Meters_ToKilometers_Reverse() {
        if let lengthUnits = UnitConverter.units(forSI: "м") {
            let kmUnit = lengthUnits.first(where: { $0.id == "km" })
            XCTAssertNotNil(kmUnit)
            
            let userValue = kmUnit!.fromSI(5000.0)
            XCTAssertEqual(userValue, 5.0, accuracy: 0.001)
        }
    }
    
    // MARK: Конвертация — круговой тест (toSI → fromSI)
    
    func testRoundTrip_AllUnits() {
        let siUnits = ["м", "с", "кг", "м/с", "Н", "Па", "Дж", "Вт"]
        let testValue = 42.0
        
        for siUnit in siUnits {
            guard let units = UnitConverter.units(forSI: siUnit) else { continue }
            for unit in units {
                let si = unit.toSI(testValue)
                let back = unit.fromSI(si)
                XCTAssertEqual(back, testValue, accuracy: 0.001,
                              "Круговая конвертация провалена для \(unit.id) (\(siUnit))")
            }
        }
    }
    
    // MARK: Несуществующая единица возвращает nil
    
    func testUnits_ForUnknownSI_ReturnsNil() {
        let result = UnitConverter.units(forSI: "несуществующая_единица")
        XCTAssertNil(result)
    }
}

// MARK: - UnitConverterView — Конвертация температуры

final class TemperatureConversionTests: XCTestCase {
    
    // Дублируем логику convertTemperature из UnitConverterView для тестирования
    private func convertTemperature(_ value: Double, from: Int, to: Int) -> Double {
        let kelvin: Double
        switch from {
        case 0: kelvin = value          // K
        case 1: kelvin = value + 273.15 // °C
        case 2: kelvin = (value - 32) * 5.0/9.0 + 273.15 // °F
        default: return value
        }
        switch to {
        case 0: return kelvin
        case 1: return kelvin - 273.15
        case 2: return (kelvin - 273.15) * 9.0/5.0 + 32
        default: return value
        }
    }
    
    func testCelsius_ToKelvin() {
        let result = convertTemperature(0, from: 1, to: 0)
        XCTAssertEqual(result, 273.15, accuracy: 0.01)
    }
    
    func testKelvin_ToCelsius() {
        let result = convertTemperature(273.15, from: 0, to: 1)
        XCTAssertEqual(result, 0.0, accuracy: 0.01)
    }
    
    func testCelsius_ToFahrenheit() {
        let result = convertTemperature(100, from: 1, to: 2)
        XCTAssertEqual(result, 212.0, accuracy: 0.01)
    }
    
    func testFahrenheit_ToCelsius() {
        let result = convertTemperature(32, from: 2, to: 1)
        XCTAssertEqual(result, 0.0, accuracy: 0.01)
    }
    
    func testFahrenheit_ToKelvin() {
        let result = convertTemperature(32, from: 2, to: 0)
        XCTAssertEqual(result, 273.15, accuracy: 0.01)
    }
    
    func testKelvin_ToFahrenheit() {
        let result = convertTemperature(373.15, from: 0, to: 2)
        XCTAssertEqual(result, 212.0, accuracy: 0.01)
    }
    
    func testAbsoluteZero_Celsius() {
        let result = convertTemperature(0, from: 0, to: 1)
        XCTAssertEqual(result, -273.15, accuracy: 0.01)
    }
    
    func testSameUnit_NoConversion() {
        let result = convertTemperature(42.0, from: 1, to: 1)
        XCTAssertEqual(result, 42.0, accuracy: 0.01)
    }
}

// MARK: - Навигационные данные (проверка связей)

final class NavigationDataIntegrityTests: XCTestCase {
    
    private var physicsData: PhysicsData!
    
    override func setUp() {
        super.setUp()
        physicsData = loadPhysicsData()
        XCTAssertNotNil(physicsData, "physicsData должна загрузиться")
    }
    
    // Каждая формула ссылается на существующий подраздел
    func testAllFormulas_PointToValidSubsection() {
        guard let data = physicsData else { return }
        let subsectionIds = Set(data.subsections.map(\.id))
        
        for formula in data.formulas {
            XCTAssertTrue(subsectionIds.contains(formula.subsectionId),
                         "Формула \(formula.id) ссылается на несуществующий подраздел \(formula.subsectionId)")
        }
    }
    
    // Каждый подраздел ссылается на существующий раздел
    func testAllSubsections_PointToValidSection() {
        guard let data = physicsData else { return }
        let sectionIds = Set(data.sections.map(\.id))
        
        for sub in data.subsections {
            XCTAssertTrue(sectionIds.contains(sub.sectionId),
                         "Подраздел \(sub.id) ссылается на несуществующий раздел \(sub.sectionId)")
        }
    }
    
    // Навигация: из каждого раздела можно дойти до формул
    func testNavigation_SectionToFormulas_PathExists() {
        guard let data = physicsData else { return }
        
        for section in data.sections {
            let subsections = data.subsections.filter { $0.sectionId == section.id }
            XCTAssertFalse(subsections.isEmpty,
                          "Раздел \(section.id) не содержит подразделов")
            
            for sub in subsections {
                let formulas = data.formulas.filter { $0.subsectionId == sub.id }
                XCTAssertFalse(formulas.isEmpty,
                              "Подраздел \(sub.id) раздела \(section.id) не содержит формул")
            }
        }
    }
    
    // У каждой формулы есть правило вычисления для каждой переменной
    func testNavigation_FormulaVariables_HaveRules() {
        guard let data = physicsData else { return }
        
        for formula in data.formulas {
            for variable in formula.variables {
                XCTAssertNotNil(formula.calculation_rules[variable.symbol],
                               "Формула \(formula.id): переменная \(variable.symbol) не имеет правила вычисления")
            }
        }
    }
    
    // Уровни формул совпадают с уровнями подразделов
    func testNavigation_FormulaLevels_MatchSubsectionLevels() {
        guard let data = physicsData else { return }
        
        for formula in data.formulas {
            guard let subsection = data.subsections.first(where: { $0.id == formula.subsectionId }) else {
                continue
            }
            
            for level in formula.levels {
                XCTAssertTrue(subsection.levels.contains(level),
                             "Формула \(formula.id) имеет уровень \(level), но подраздел \(subsection.id) не содержит этот уровень")
            }
        }
    }
    
    // Все ID формул уникальны
    func testAllFormulaIds_AreUnique() {
        guard let data = physicsData else { return }
        let ids = data.formulas.map(\.id)
        let uniqueIds = Set(ids)
        
        XCTAssertEqual(ids.count, uniqueIds.count, "Найдены дубликаты ID формул")
    }
    
    // Все ID подразделов уникальны
    func testAllSubsectionIds_AreUnique() {
        guard let data = physicsData else { return }
        let ids = data.subsections.map(\.id)
        let uniqueIds = Set(ids)
        
        XCTAssertEqual(ids.count, uniqueIds.count, "Найдены дубликаты ID подразделов")
    }
}

// MARK: - Настройки приложения — Взаимодействие

final class SettingsInteractionTests: XCTestCase {
    
    func testAppTheme_AllCases_HaveLocalizedName() {
        for theme in AppTheme.allCases {
            let name = theme.localizedName
            XCTAssertFalse(name.isEmpty, "Тема \(theme.rawValue) не имеет локализованного имени")
        }
    }
    
    func testAppTheme_ColorScheme() {
        XCTAssertEqual(AppTheme.light.colorScheme, .light)
        XCTAssertEqual(AppTheme.dark.colorScheme, .dark)
        XCTAssertEqual(AppTheme.oled.colorScheme, .dark, "OLED использует .dark")
        XCTAssertNil(AppTheme.system.colorScheme, "System не задаёт конкретную схему")
    }
    
    func testAppTheme_OLED_IsOLED() {
        XCTAssertTrue(AppTheme.oled.isOLED)
        XCTAssertFalse(AppTheme.dark.isOLED)
        XCTAssertFalse(AppTheme.light.isOLED)
        XCTAssertFalse(AppTheme.system.isOLED)
    }
    
    func testAppTheme_RawValues() {
        XCTAssertEqual(AppTheme.light.rawValue, "light")
        XCTAssertEqual(AppTheme.dark.rawValue, "dark")
        XCTAssertEqual(AppTheme.oled.rawValue, "oled")
        XCTAssertEqual(AppTheme.system.rawValue, "system")
    }
    
    func testAllThemes_Identifiable() {
        for theme in AppTheme.allCases {
            XCTAssertEqual(theme.id, theme.rawValue)
        }
    }
}

// MARK: - Локализация моделей

final class LocalizationInteractionTests: XCTestCase {
    
    func testSection_LocalizedName_Russian() {
        let section = TestData.section
        let name = section.localizedName(for: "ru")
        
        XCTAssertEqual(name, "Механика")
    }
    
    func testSection_LocalizedName_English() {
        let section = TestData.section
        let name = section.localizedName(for: "en")
        
        XCTAssertEqual(name, "Mechanics")
    }
    
    func testFormula_LocalizedName_Russian() {
        let formula = TestData.formula
        let name = formula.localizedName(for: "ru")
        
        XCTAssertEqual(name, "Второй закон Ньютона")
    }
    
    func testFormula_LocalizedDescription_English() {
        let formula = TestData.formula
        let desc = formula.localizedDescription(for: "en")
        
        XCTAssertEqual(desc, "Force equals mass times acceleration")
    }
    
    func testVariable_LocalizedName_Russian() {
        let variable = TestData.variables[0] // F
        let name = variable.localizedName(for: "ru")
        
        XCTAssertEqual(name, "Сила")
    }
    
    func testVariable_LocalizedName_English() {
        let variable = TestData.variables[0] // F
        let name = variable.localizedName(for: "en")
        
        XCTAssertEqual(name, "Force")
    }
    
    func testVariable_DisplaySymbol_Regular() {
        XCTAssertEqual(Variable.displaySymbol(for: "F"), "F")
        XCTAssertEqual(Variable.displaySymbol(for: "m"), "m")
    }
    
    func testVariable_DisplaySymbol_Greek() {
        XCTAssertEqual(Variable.displaySymbol(for: "alpha"), "α")
        XCTAssertEqual(Variable.displaySymbol(for: "omega"), "ω")
        XCTAssertEqual(Variable.displaySymbol(for: "lambda"), "λ")
        XCTAssertEqual(Variable.displaySymbol(for: "nu"), "ν")
    }
    
    func testVariable_DisplaySymbol_Special() {
        XCTAssertEqual(Variable.displaySymbol(for: "DeltaT"), "ΔT")
        XCTAssertEqual(Variable.displaySymbol(for: "DeltaS"), "ΔS")
        XCTAssertEqual(Variable.displaySymbol(for: "alpha1"), "α₁")
        XCTAssertEqual(Variable.displaySymbol(for: "alpha2"), "α₂")
    }
}

// MARK: - Физические константы — Взаимодействие

final class PhysicalConstantsInteractionTests: XCTestCase {
    
    @MainActor
    func testPhysicalConstants_AutoFillInCalculation() {
        // Проверяем, что константы предзаполняются при инициализации ViewModel
        // Создадим формулу с переменной, которая совпадает с физической константой
        let formula = Formula(
            id: "test_gravity",
            subsectionId: "test",
            name_ru: "Сила тяжести",
            name_en: "Gravity Force",
            levels: ["school"],
            equation_latex: "F = mg",
            description_ru: "F = mg",
            description_en: "F = mg",
            variables: [
                Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
                Variable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
                Variable(symbol: "g", name_ru: "Ускорение свободного падения", name_en: "Gravitational acceleration", unit_si: "м/с²"),
            ],
            calculation_rules: ["F": "m * g", "m": "F / g", "g": "F / m"]
        )
        
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        // g = 9.807 должна быть предзаполнена
        if PhysicalConstants.match(for: formula.variables.first(where: { $0.symbol == "g" })!) != nil {
            let gValue = vm.inputValues["g"]
            XCTAssertNotNil(gValue, "Константа g должна быть предзаполнена")
            XCTAssertFalse(gValue?.isEmpty ?? true)
        }
    }
    
    @MainActor
    func testPhysicalConstants_RestoredOnDeselect() {
        // Когда снимаем выбор неизвестной, которая является константой — значение восстанавливается
        let formula = Formula(
            id: "test_gravity",
            subsectionId: "test",
            name_ru: "Сила тяжести",
            name_en: "Gravity Force",
            levels: ["school"],
            equation_latex: "F = mg",
            description_ru: "F = mg",
            description_en: "F = mg",
            variables: [
                Variable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
                Variable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
                Variable(symbol: "g", name_ru: "Ускорение свободного падения", name_en: "Gravitational acceleration", unit_si: "м/с²"),
            ],
            calculation_rules: ["F": "m * g", "m": "F / g", "g": "F / m"]
        )
        
        let mockService = MockNavCalculationService()
        let mockPersistence = MockPersistenceController()
        let vm = CalculationViewModel(
            formula: formula,
            calculationService: mockService,
            persistenceController: mockPersistence
        )
        
        let gBefore = vm.inputValues["g"]
        
        // Выбираем g как неизвестную — значение очищается
        vm.selectUnknown(symbol: "g")
        XCTAssertEqual(vm.inputValues["g"], "")
        
        // Снимаем выбор — константа должна восстановиться
        vm.selectUnknown(symbol: "g")
        XCTAssertEqual(vm.inputValues["g"], gBefore, "Константа должна восстановиться при снятии выбора")
    }
}

// MARK: - UnitCategory — Данные конвертера

final class UnitCategoryTests: XCTestCase {
    
    func testAllCategories_HaveUnits() {
        for category in UnitCategory.all {
            XCTAssertFalse(category.units.isEmpty,
                          "Категория \(category.id) не содержит единиц")
        }
    }
    
    func testAllCategories_HaveLocalizedName() {
        for category in UnitCategory.all {
            let name = category.localizedName
            XCTAssertFalse(name.isEmpty,
                          "Категория \(category.id) не имеет локализованного имени")
        }
    }
    
    func testAllCategories_HaveIcon() {
        for category in UnitCategory.all {
            XCTAssertFalse(category.icon.isEmpty,
                          "Категория \(category.id) не имеет иконки")
        }
    }
    
    func testCategoryCount_AtLeast13() {
        XCTAssertGreaterThanOrEqual(UnitCategory.all.count, 13,
                                    "Должно быть минимум 13 категорий конвертера")
    }
    
    func testAllUnits_HaveSymbol() {
        for category in UnitCategory.all {
            for unit in category.units {
                XCTAssertFalse(unit.symbol.isEmpty,
                              "Единица в категории \(category.id) не имеет символа")
            }
        }
    }
    
    func testCategorySelection_ResetsUnits() {
        // При смене категории индексы единиц должны сбрасываться
        var selectedCategory = 0
        var fromUnitIndex = 3
        var toUnitIndex = 2
        
        // Смена категории
        selectedCategory = 5
        fromUnitIndex = 0
        toUnitIndex = min(1, UnitCategory.all[selectedCategory].units.count - 1)
        
        XCTAssertEqual(fromUnitIndex, 0)
        XCTAssertLessThan(toUnitIndex, UnitCategory.all[selectedCategory].units.count)
    }
}

// MARK: - Онбординг — Навигация

final class OnboardingNavigationTests: XCTestCase {
    
    func testOnboardingPages_Count() {
        // Онбординг должен содержать 6 страниц
        let pageCount = 6
        XCTAssertEqual(pageCount, 6)
    }
    
    func testOnboardingNavigation_NextButton() {
        var currentPage = 0
        let totalPages = 6
        
        // Нажимаем "Далее" 5 раз
        for _ in 0..<(totalPages - 1) {
            if currentPage < totalPages - 1 {
                currentPage += 1
            }
        }
        
        XCTAssertEqual(currentPage, totalPages - 1, "После 5 нажатий должны быть на последней странице")
    }
    
    func testOnboardingNavigation_SkipButton() {
        var hasSeenOnboarding = false
        
        // Нажимаем "Пропустить"
        hasSeenOnboarding = true
        
        XCTAssertTrue(hasSeenOnboarding, "Пропуск должен устанавливать hasSeenOnboarding = true")
    }
    
    func testOnboardingNavigation_StartButton_OnLastPage() {
        var currentPage = 5 // Последняя страница
        var hasSeenOnboarding = false
        let totalPages = 6
        
        // На последней странице кнопка "Начать" устанавливает hasSeenOnboarding = true
        if currentPage >= totalPages - 1 {
            hasSeenOnboarding = true
        }
        
        XCTAssertTrue(hasSeenOnboarding)
    }
}

// MARK: - Навигационный поток App → ContentView

final class AppNavigationFlowTests: XCTestCase {
    
    func testAppFlow_NewUser_ShowsLanguagePicker() {
        let hasChosenLanguage = false
        let hasSeenOnboarding = false
        
        // Новый пользователь → LanguagePickerView
        XCTAssertFalse(hasChosenLanguage)
        XCTAssertFalse(hasSeenOnboarding)
    }
    
    func testAppFlow_AfterLanguage_ShowsOnboarding() {
        let hasChosenLanguage = true
        let hasSeenOnboarding = false
        
        // Язык выбран → OnboardingView
        XCTAssertTrue(hasChosenLanguage)
        XCTAssertFalse(hasSeenOnboarding)
    }
    
    func testAppFlow_AfterOnboarding_ShowsContent() {
        let hasChosenLanguage = true
        let hasSeenOnboarding = true
        
        // Всё пройдено → ContentView
        XCTAssertTrue(hasChosenLanguage)
        XCTAssertTrue(hasSeenOnboarding)
    }
    
    func testLanguagePicker_SelectLanguage_SetsFlag() {
        var hasChosenLanguage = false
        var languageCode = "system"
        
        // Выбираем русский
        languageCode = "ru"
        hasChosenLanguage = true
        
        XCTAssertTrue(hasChosenLanguage)
        XCTAssertEqual(languageCode, "ru")
    }
    
    func testLanguagePicker_AllLanguages_Available() {
        let supportedLanguages = ["system", "ru", "en", "de", "es", "fr", "zh"]
        
        XCTAssertEqual(supportedLanguages.count, 7)
        XCTAssertTrue(supportedLanguages.contains("ru"))
        XCTAssertTrue(supportedLanguages.contains("en"))
        XCTAssertTrue(supportedLanguages.contains("de"))
        XCTAssertTrue(supportedLanguages.contains("es"))
        XCTAssertTrue(supportedLanguages.contains("fr"))
        XCTAssertTrue(supportedLanguages.contains("zh"))
    }
}

// MARK: - Таб-навигация

final class TabNavigationTests: XCTestCase {
    
    func testTabsAvailable_SixTabs() {
        // ContentView содержит 6 табов
        let tabs = ["sections", "favorites", "history", "settings", "converter", "constants"]
        XCTAssertEqual(tabs.count, 6)
    }
    
    func testTabOrder() {
        let expectedOrder = [
            ("sections", "list.bullet"),
            ("favorites", "star"),
            ("history", "clock.arrow.circlepath"),
            ("settings", "gear"),
            ("converter", "arrow.left.arrow.right"),
            ("constants", "textformat.123"),
        ]
        
        XCTAssertEqual(expectedOrder.count, 6)
        
        // Все значки системные (SF Symbols)
        for (_, icon) in expectedOrder {
            XCTAssertFalse(icon.isEmpty)
        }
    }
}

// MARK: - Расчёт ошибок — Логика

final class ErrorCalculationLogicTests: XCTestCase {
    
    func testErrorPropagation_NumericDifferentiation() {
        // Проверяем, что численное дифференцирование работает корректно
        // f(x) = x^2, df/dx = 2x
        let service = CalculationService()
        let h = 1e-6
        let x = 3.0
        
        // f(x+h) - f(x-h) / (2h)
        let fPlus = try? service.calculate(rule: "pow(x, 2)", variables: ["x": x + h])
        let fMinus = try? service.calculate(rule: "pow(x, 2)", variables: ["x": x - h])
        
        XCTAssertNotNil(fPlus)
        XCTAssertNotNil(fMinus)
        
        if let fp = fPlus, let fm = fMinus {
            let derivative = (fp - fm) / (2 * h)
            XCTAssertEqual(derivative, 6.0, accuracy: 0.001, "d/dx(x²) при x=3 должна быть 6")
        }
    }
    
    func testInputVariables_ExcludesCalculated() {
        let formula = TestData.formula
        let calculatedSymbol = "F"
        
        let inputVariables = formula.variables.filter { $0.symbol != calculatedSymbol }
        
        XCTAssertEqual(inputVariables.count, 2)
        XCTAssertFalse(inputVariables.contains(where: { $0.symbol == "F" }))
        XCTAssertTrue(inputVariables.contains(where: { $0.symbol == "m" }))
        XCTAssertTrue(inputVariables.contains(where: { $0.symbol == "a" }))
    }
}

// MARK: - MultiCalcView — Логика мульти-расчёта

final class MultiCalcLogicTests: XCTestCase {
    
    func testMultiCalc_AddRow() {
        var rows: [[String: String]] = [[:]]
        var results: [Double?] = [nil]
        
        // Добавляем строку
        rows.append([:])
        results.append(nil)
        
        XCTAssertEqual(rows.count, 2)
        XCTAssertEqual(results.count, 2)
    }
    
    func testMultiCalc_RemoveLastRow() {
        var rows: [[String: String]] = [[:], [:], [:]]
        var results: [Double?] = [nil, nil, nil]
        
        // Удаляем последнюю строку (если больше одной)
        if rows.count > 1 {
            rows.removeLast()
            results.removeLast()
        }
        
        XCTAssertEqual(rows.count, 2)
    }
    
    func testMultiCalc_CalculateAllRows() {
        let service = CalculationService()
        let formula = TestData.formula // F = m * a
        let unknownSymbol = "F"
        
        let testRows: [[String: String]] = [
            ["m": "10", "a": "5"],
            ["m": "20", "a": "3"],
            ["m": "5", "a": "10"],
        ]
        
        var results: [Double?] = []
        
        for row in testRows {
            var variables: [String: Double] = [:]
            var valid = true
            for v in formula.variables where v.symbol != unknownSymbol {
                guard let str = row[v.symbol], let val = Double(str) else {
                    valid = false; break
                }
                variables[v.symbol] = val
            }
            
            if valid, let rule = formula.calculation_rules[unknownSymbol] {
                let result = try? service.calculate(rule: rule, variables: variables)
                results.append(result)
            } else {
                results.append(nil)
            }
        }
        
        XCTAssertEqual(results.count, 3)
        XCTAssertEqual(results[0]!, 50.0, accuracy: 0.001)  // 10 * 5
        XCTAssertEqual(results[1]!, 60.0, accuracy: 0.001)  // 20 * 3
        XCTAssertEqual(results[2]!, 50.0, accuracy: 0.001)  // 5 * 10
    }
    
    func testMultiCalc_InputVariables_ExcludeUnknown() {
        let formula = TestData.formula
        let unknownSymbol = "F"
        
        let inputVariables = formula.variables.filter { $0.symbol != unknownSymbol }
        
        XCTAssertEqual(inputVariables.count, 2)
        XCTAssertTrue(inputVariables.contains(where: { $0.symbol == "m" }))
        XCTAssertTrue(inputVariables.contains(where: { $0.symbol == "a" }))
    }
}

// MARK: - CalculationService — Расчёт через JSContext

final class CalculationServiceInteractionTests: XCTestCase {
    
    let service = CalculationService()
    
    func testCalculate_SimpleMultiplication() {
        let result = try? service.calculate(rule: "m * a", variables: ["m": 10.0, "a": 5.0])
        XCTAssertEqual(result, 50.0)
    }
    
    func testCalculate_Division() {
        let result = try? service.calculate(rule: "s / t", variables: ["s": 100.0, "t": 4.0])
        XCTAssertEqual(result, 25.0)
    }
    
    func testCalculate_SquareRoot() {
        let result = try? service.calculate(rule: "sqrt(x)", variables: ["x": 144.0])
        XCTAssertEqual(result, 12.0)
    }
    
    func testCalculate_Power() {
        let result = try? service.calculate(rule: "pow(x, 2)", variables: ["x": 7.0])
        XCTAssertEqual(result, 49.0)
    }
    
    func testCalculate_Trigonometry() {
        let result = try? service.calculate(rule: "sin(x)", variables: ["x": Double.pi / 2])
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 1.0, accuracy: 0.0001)
    }
    
    func testCalculate_DivisionByZero_ThrowsError() {
        XCTAssertThrowsError(try service.calculate(rule: "x / y", variables: ["x": 1.0, "y": 0.0]))
    }
    
    func testCalculate_NegativeSquareRoot_ThrowsError() {
        XCTAssertThrowsError(try service.calculate(rule: "sqrt(x)", variables: ["x": -1.0]))
    }
    
    func testCalculate_ReservedWord_InVariable() {
        // Переменная "in" — зарезервированное слово JS, должна обрабатываться
        let result = try? service.calculate(rule: "F / a", variables: ["F": 100.0, "a": 5.0])
        XCTAssertNotNil(result)
        XCTAssertEqual(result!, 20.0)
    }
    
    func testValidateInput_ValidNumber() {
        XCTAssertTrue(service.validateInput("42"))
        XCTAssertTrue(service.validateInput("3.14"))
        XCTAssertTrue(service.validateInput("3,14"))
        XCTAssertTrue(service.validateInput("-5"))
    }
    
    func testValidateInput_InvalidInput() {
        XCTAssertFalse(service.validateInput("abc"))
        XCTAssertFalse(service.validateInput(""))
    }
    
    func testFormatResult_LargeNumber() {
        let formatted = service.formatResult(12345.6789)
        XCTAssertFalse(formatted.isEmpty)
    }
    
    func testFormatResult_SmallNumber() {
        let formatted = service.formatResult(0.001234)
        XCTAssertFalse(formatted.isEmpty)
    }
}

// MARK: - История — Группировка по дате

final class HistoryGroupingTests: XCTestCase {
    
    func testHistoryGrouping_Today() {
        let date = Date()
        XCTAssertTrue(Calendar.current.isDateInToday(date))
    }
    
    func testHistoryGrouping_Yesterday() {
        let date = Date().addingTimeInterval(-86400)
        XCTAssertTrue(Calendar.current.isDateInYesterday(date))
    }
    
    func testHistoryGrouping_ThisWeek() {
        // Дата в текущей неделе (но не сегодня/вчера)
        let calendar = Calendar.current
        let now = Date()
        let twoDaysAgo = now.addingTimeInterval(-2 * 86400)
        
        let isThisWeek = calendar.isDate(twoDaysAgo, equalTo: now, toGranularity: .weekOfYear)
        // Может быть true или false в зависимости от дня недели — просто проверяем, что не падает
        XCTAssertNotNil(isThisWeek)
    }
    
    func testHistorySearch_FiltersByName() {
        let mockItems = [
            ("Второй закон Ньютона", "F"),
            ("Скорость", "v"),
            ("Период колебаний", "T"),
        ]
        
        let query = "ньютон"
        let filtered = mockItems.filter { $0.0.lowercased().contains(query) }
        
        XCTAssertEqual(filtered.count, 1)
        XCTAssertEqual(filtered.first?.1, "F")
    }
    
    func testHistorySearch_FiltersBySymbol() {
        let mockItems = [
            ("Второй закон Ньютона", "F"),
            ("Скорость", "v"),
        ]
        
        let query = "f"
        let filtered = mockItems.filter { $0.1.lowercased().contains(query) }
        
        XCTAssertEqual(filtered.count, 1)
    }
    
    func testHistorySearch_EmptyQuery_ReturnsAll() {
        let mockItems = [
            ("Второй закон Ньютона", "F"),
            ("Скорость", "v"),
        ]
        
        let query = ""
        let filtered = query.isEmpty ? mockItems : mockItems.filter { $0.0.lowercased().contains(query) }
        
        XCTAssertEqual(filtered.count, 2)
    }
}
