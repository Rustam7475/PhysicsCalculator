import Foundation
import SwiftUI

/// Управляет доступом к Premium-функциям.
/// Бесплатно: первые 2 формулы каждого подраздела + базовый расчёт + конвертер единиц.
/// Premium: все 126 формул + графики + PDF + калькулятор погрешностей + избранное.
@MainActor
final class PremiumManager {
    static let shared = PremiumManager()
    
    private let storeManager = StoreManager.shared
    
    /// Количество бесплатных формул на подраздел
    static let freeFormulasPerSubsection = 2
    
    var isPremium: Bool {
        storeManager.isPremium
    }
    
    /// Проверяет, доступна ли формула бесплатно
    func isFormulaFree(_ formula: Formula, allFormulas: [Formula]) -> Bool {
        let subsectionFormulas = allFormulas
            .filter { $0.subsectionId == formula.subsectionId }
        
        guard let index = subsectionFormulas.firstIndex(where: { $0.id == formula.id }) else {
            return false
        }
        
        return index < Self.freeFormulasPerSubsection
    }
    
    /// Проверяет, доступна ли формула (бесплатная или Premium куплен)
    func isFormulaAccessible(_ formula: Formula, allFormulas: [Formula]) -> Bool {
        isPremium || isFormulaFree(formula, allFormulas: allFormulas)
    }
    
    /// Доступны ли графики
    var isGraphAvailable: Bool { isPremium }
    
    /// Доступен ли экспорт PDF
    var isPDFAvailable: Bool { isPremium }
    
    /// Доступен ли калькулятор погрешностей
    var isErrorCalcAvailable: Bool { isPremium }
    
    /// Доступно ли избранное
    var isFavoritesAvailable: Bool { isPremium }
}
