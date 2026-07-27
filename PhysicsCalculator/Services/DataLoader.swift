import Foundation

/// Потокобезопасная загрузка данных физических формул из JSON с кешированием.
/// Вынесено из `PhysicsModels.swift` для изоляции глобального состояния.
enum DataLoader {
    private static let lock = NSLock()
    private static var cachedData: PhysicsData?
    private static var dataLoaded = false

    /// Загружает данные из `formulas_data.json`. Результат кешируется — повторные вызовы мгновенны.
    static func loadPhysicsData() -> PhysicsData? {
        lock.lock()
        defer { lock.unlock() }

        if dataLoaded { return cachedData }
        guard let url = Bundle.main.url(forResource: "formulas_data", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            dataLoaded = true
            return nil
        }
        cachedData = try? JSONDecoder().decode(PhysicsData.self, from: data)
        dataLoaded = true
        return cachedData
    }
}
