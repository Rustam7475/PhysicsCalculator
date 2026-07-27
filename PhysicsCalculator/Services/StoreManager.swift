import Foundation
import StoreKit

/// Менеджер покупок через StoreKit 2
@MainActor
final class StoreManager: ObservableObject {
    static let shared = StoreManager()
    
    static let premiumProductID = "com.elmuradov.physicscalculator.premium"
    private static let premiumKey = "isPremiumPurchased"
    
    @Published private(set) var products: [Product] = []
    @Published private(set) var isLoading = false
    
    /// Читает из UserDefaults — мгновенно, без async
    var isPremium: Bool {
        UserDefaults.standard.bool(forKey: Self.premiumKey)
    }
    
    var premiumProduct: Product? {
        products.first { $0.id == Self.premiumProductID }
    }
    
    private var updateListenerTask: Task<Void, Never>?
    private var didStartListening = false
    
    private init() {
        // Ничего тяжёлого при init — StoreKit запускается позже
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    /// Запуск фоновой проверки — вызывать один раз при старте приложения
    func startBackgroundVerification() {
        guard !didStartListening else { return }
        didStartListening = true
        
        updateListenerTask = listenForTransactions()
        
        Task {
            async let products: () = loadProducts()
            async let verify: () = verifyWithStoreKit()
            _ = await (products, verify)
        }
    }
    
    // MARK: - Загрузка продуктов (только для PaywallView)
    
    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let loaded = try await Product.products(for: [Self.premiumProductID])
            print("StoreManager: Loaded \(loaded.count) products")
            products = loaded
        } catch {
            print("StoreManager: Failed to load products: \(error)")
        }
    }
    
    // MARK: - Покупка
    
    func purchase() async throws -> Bool {
        // Если продукты не загружены — пробуем загрузить
        if premiumProduct == nil {
            await loadProducts()
        }
        guard let product = premiumProduct else { return false }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            setPremium(true)
            return true
            
        case .userCancelled:
            return false
            
        case .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    // MARK: - Восстановление покупок
    
    func restorePurchases() async {
        try? await AppStore.sync()
        await verifyWithStoreKit()
    }
    
    // MARK: - Private
    
    private func setPremium(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Self.premiumKey)
        objectWillChange.send()
    }
    
    /// Проверяет реальные покупки через StoreKit и обновляет кеш
    private func verifyWithStoreKit() async {
        var hasPremium = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.premiumProductID {
                hasPremium = true
            }
        }
        
        await MainActor.run {
            setPremium(hasPremium)
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                if case .verified(let transaction) = result {
                    await transaction.finish()
                    await self.verifyWithStoreKit()
                }
            }
        }
    }
    
    enum StoreError: LocalizedError {
        case failedVerification
        
        var errorDescription: String? {
            switch self {
            case .failedVerification:
                return "Transaction verification failed"
            }
        }
    }
}
