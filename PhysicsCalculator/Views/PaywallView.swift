import SwiftUI

struct PaywallView: View {
    @ObservedObject private var storeManager = StoreManager.shared
    @Environment(\.dismiss) private var dismiss
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    private let features: [(icon: String, text: () -> String)] = [
        ("function", { L10n.premiumFeatureFormulas }),
        ("chart.xyaxis.line", { L10n.premiumFeatureGraphs }),
        ("doc.richtext", { L10n.premiumFeaturePDF }),
        ("plusminus", { L10n.premiumFeatureError }),
        ("star.fill", { L10n.premiumFeatureFavorites }),
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Иконка
                    Image(systemName: "crown.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(.linearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .padding(.top, 20)
                    
                    // Заголовок
                    Text(L10n.premiumUnlock)
                        .font(.title.bold())
                        .multilineTextAlignment(.center)
                    
                    Text(L10n.premiumDescription)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Список фич
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                            HStack(spacing: 14) {
                                Image(systemName: feature.icon)
                                    .font(.title3)
                                    .foregroundColor(.accentColor)
                                    .frame(width: 30)
                                Text(feature.text())
                                    .font(.body)
                                Spacer()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    .padding(.horizontal)
                    
                    // Цена и кнопка покупки
                    VStack(spacing: 12) {
                        if storeManager.isPremium {
                            Label(L10n.premiumAlreadyActive, systemImage: "checkmark.seal.fill")
                                .font(.headline)
                                .foregroundColor(.green)
                                .padding()
                        } else if storeManager.isLoading && storeManager.premiumProduct == nil {
                            ProgressView()
                                .padding()
                        } else {
                            Button {
                                Task { await makePurchase() }
                            } label: {
                                HStack {
                                    if isPurchasing {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Text(storeManager.premiumProduct.map { "\(L10n.premiumUnlock) — \($0.displayPrice)" } ?? "\(L10n.premiumUnlock) — $1.99")
                                            .font(.headline)
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                                .background(Color.accentColor)
                                .foregroundColor(.white)
                                .cornerRadius(16)
                            }
                            .disabled(isPurchasing)
                            .padding(.horizontal)
                            
                            Text(L10n.premiumBuyOnce)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        // Восстановить покупку
                        if !storeManager.isPremium {
                            Button {
                                Task { await storeManager.restorePurchases() }
                            } label: {
                                Text(L10n.premiumRestore)
                                    .font(.subheadline)
                                    .foregroundColor(.accentColor)
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.top, 8)
                    
                    Spacer(minLength: 40)
                }
            }
            .navigationBarTitle(L10n.premiumTitle, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.close) { dismiss() }
                }
            }
            .alert(L10n.premiumPurchaseError, isPresented: $showError) {
                Button("OK") { }
            } message: {
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                }
            }
            .task {
                if storeManager.products.isEmpty {
                    await storeManager.loadProducts()
                }
            }
        }
    }
    
    private func makePurchase() async {
        isPurchasing = true
        defer { isPurchasing = false }
        
        do {
            let success = try await storeManager.purchase()
            if success {
                dismiss()
            } else if storeManager.premiumProduct == nil {
                errorMessage = L10n.premiumPurchaseError
                showError = true
            }
            // else: пользователь отменил — ничего не делаем
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
