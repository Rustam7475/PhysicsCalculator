import Foundation

// MARK: - Ошибки загрузки данных
enum DataServiceError: LocalizedError {
    case fileNotFound
    case decodingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return L10n.fileNotFound
        case .decodingError(let error):
            return L10n.decodingError(error.localizedDescription)
        }
    }
}

// MARK: - Протокол сервиса данных
protocol DataServiceProtocol {
    func loadPhysicsData() async throws -> PhysicsData
}

// MARK: - Реализация сервиса данных
final class DataService: DataServiceProtocol {
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func loadPhysicsData() async throws -> PhysicsData {
        guard let url = bundle.url(forResource: "formulas_data", withExtension: "json") else {
            throw DataServiceError.fileNotFound
        }
        
        let data = try Data(contentsOf: url)
        
        do {
            return try JSONDecoder().decode(PhysicsData.self, from: data)
        } catch {
            throw DataServiceError.decodingError(error)
        }
    }
    
    /// Резервные данные на случай ошибки загрузки
    static let fallbackData = PhysicsData(
        sections: [
            PhysicsSection(id: "mechanics", name_ru: "Механика", name_en: "Mechanics", levels: ["basic"])
        ],
        subsections: [
            PhysicsSubsection(id: "kinematics", sectionId: "mechanics", name_ru: "Кинематика", name_en: "Kinematics", levels: ["basic"])
        ],
        formulas: [
            Formula(
                id: "velocity",
                subsectionId: "kinematics",
                name_ru: "Скорость",
                name_en: "Velocity",
                levels: ["basic"],
                equation_latex: "v = \\frac{s}{t}",
                description_ru: "Скорость — это отношение пройденного пути ко времени",
                description_en: "Velocity is the ratio of distance to time",
                variables: [
                    Variable(symbol: "v", name_ru: "Скорость", name_en: "Velocity", unit_si: "м/с"),
                    Variable(symbol: "s", name_ru: "Путь", name_en: "Distance", unit_si: "м"),
                    Variable(symbol: "t", name_ru: "Время", name_en: "Time", unit_si: "с")
                ],
                calculation_rules: ["v": "s / t", "s": "v * t", "t": "s / v"]
            )
        ]
    )
}
