import Foundation

// MARK: - ViewModel для главного экрана
@MainActor
final class ContentViewModel: ObservableObject {
    
    @Published var physicsData: PhysicsData?
    @Published var isLoading = true
    @Published var errorMessage: String?
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol = DataService()) {
        self.dataService = dataService
    }
    
    func loadData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            physicsData = try await dataService.loadPhysicsData()
        } catch {
            errorMessage = error.localizedDescription
            physicsData = DataService.fallbackData
        }
        
        isLoading = false
    }
}
