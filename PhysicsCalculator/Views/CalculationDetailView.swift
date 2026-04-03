import SwiftUI
import UIKit
import CoreData // Потребуется для ObservedObject
import SwiftMath


struct CalculationDetailView: View {
    // Получаем сохраненный объект из FavoritesView
    @ObservedObject var savedCalculation: SavedCalculation
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    @State private var showDeleteConfirmation = false
    @State private var copiedToClipboard = false

    // Форматтер для даты
    private static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium // Можно сделать стиль даты подробнее
        formatter.timeStyle = .short
        return formatter
    }()

    // --- Вспомогательные вычисляемые свойства ---

    // Формула с подставленными значениями
    private var solvedEquationString: String {
        guard let inputs = savedCalculation.inputValues,
              let calculatedSymbol = savedCalculation.calculatedSymbol
        else { return savedCalculation.equationLatex ?? L10n.formulaNotFound }

        if let formulaId = savedCalculation.formulaId,
           let physicsData = loadPhysicsData(),
           let formula = physicsData.formulas.first(where: { $0.id == formulaId }) {
            return "\\displaystyle " + formula.getFormulaWithValues(
                calculatedSymbol: calculatedSymbol,
                inputValues: inputs
            )
        }
        
        // Fallback
        guard let formulaVars = savedCalculation.formulaVariables else {
            return savedCalculation.equationLatex ?? L10n.formulaNotFound
        }
        let parts = formulaVars
            .filter { $0.symbol != calculatedSymbol }
            .compactMap { inputs[$0.symbol] }
        return "\\displaystyle " + calculatedSymbol + " = " + parts.joined(separator: " \\cdot ")
    }

    // Список всех переменных (введенных и рассчитанной)
    private var allVariablesList: [(symbol: String, name: String, value: String, unit: String, isCalculated: Bool)] {
        guard let formulaVars = savedCalculation.formulaVariables, // Используем декодированные данные
              let inputs = savedCalculation.inputValues,
              let calculatedSymbol = savedCalculation.calculatedSymbol
        else { return [] }

        var list: [(symbol: String, name: String, value: String, unit: String, isCalculated: Bool)] = []

        for variable in formulaVars {
            let isCalculated = (variable.symbol == calculatedSymbol)
            var valueString: String

            if isCalculated {
                valueString = CalculationService.formatNumber(savedCalculation.calculatedValue)
            } else {
                // Ищем введенное значение, форматируем если это число
                 if let inputValue = inputs[variable.symbol] {
                     if let doubleVal = Double(inputValue) {
                         valueString = CalculationService.formatNumber(doubleVal)
                     } else {
                         valueString = inputValue // Если не число
                     }
                 } else {
                     valueString = "???" // Если значение не найдено
                 }
            }
            list.append((symbol: variable.symbol, name: variable.localizedName, value: valueString, unit: CalculationService.displayUnit(variable.unit_si), isCalculated: isCalculated))
        }
        // Сортируем, чтобы рассчитанная была последней (или первой)
        list.sort { !$0.isCalculated && $1.isCalculated }
        return list
    }


    private func generateDetailShareText() -> String {
        var text = "📐 \(savedCalculation.formulaName ?? "")\n\n"
        
        for item in allVariablesList {
            let prefix = item.isCalculated ? "▸ " : "  • "
            text += "\(prefix)\(item.name) = \(item.value) \(item.unit)"
            if item.isCalculated { text += " (\(L10n.calculated))" }
            text += "\n"
        }
        
        if let date = savedCalculation.timestamp {
            text += "\n📅 \(Self.dateFormatter.string(from: date))"
        }
        return text
    }
    
    /// Рендерит карточку результата как UIImage
    private func renderShareCard() -> UIImage {
        let width: CGFloat = 600
        let padding: CGFloat = 30
        let contentWidth = width - 2 * padding
        
        let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let labelFont = UIFont.systemFont(ofSize: 14)
        let valueFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        let resultFont = UIFont.systemFont(ofSize: 22, weight: .bold)
        let captionFont = UIFont.systemFont(ofSize: 13)
        
        let bgColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        let cardColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1)
        let textColor = UIColor.white
        let secondaryText = UIColor(white: 0.6, alpha: 1)
        let accentColor = UIColor(red: 52/255, green: 120/255, blue: 246/255, alpha: 1)
        
        let items = allVariablesList
        let inputItems = items.filter { !$0.isCalculated }
        let calculatedItem = items.first(where: { $0.isCalculated })
        
        var totalHeight: CGFloat = padding
        totalHeight += 34 // заголовок
        totalHeight += 20
        totalHeight += CGFloat(inputItems.count) * 50
        totalHeight += 20
        totalHeight += 70 // результат
        totalHeight += 20
        totalHeight += 20 // дата
        totalHeight += padding
        
        let size = CGSize(width: width, height: totalHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { ctx in
            bgColor.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            var y: CGFloat = padding
            
            // Заголовок
            let titleStr = (savedCalculation.formulaName ?? "") as NSString
            let titleRect = titleStr.boundingRect(with: CGSize(width: contentWidth, height: 100),
                                                    options: .usesLineFragmentOrigin,
                                                    attributes: [.font: titleFont, .foregroundColor: textColor], context: nil)
            titleStr.draw(in: CGRect(x: padding, y: y, width: contentWidth, height: titleRect.height),
                         withAttributes: [.font: titleFont, .foregroundColor: textColor])
            y += titleRect.height + 20
            
            // Введённые значения
            let inputCardHeight = CGFloat(inputItems.count) * 48 + 16
            let inputCardRect = CGRect(x: padding, y: y, width: contentWidth, height: inputCardHeight)
            UIBezierPath(roundedRect: inputCardRect, cornerRadius: 12).fill(with: .normal, alpha: 1)
            cardColor.setFill()
            UIBezierPath(roundedRect: inputCardRect, cornerRadius: 12).fill()
            
            var innerY = y + 8
            for item in inputItems {
                let nameLbl = item.name as NSString
                nameLbl.draw(at: CGPoint(x: padding + 16, y: innerY),
                            withAttributes: [.font: labelFont, .foregroundColor: secondaryText])
                innerY += 18
                let valLbl = "\(item.value) \(item.unit)".trimmingCharacters(in: .whitespaces) as NSString
                valLbl.draw(at: CGPoint(x: padding + 16, y: innerY),
                           withAttributes: [.font: valueFont, .foregroundColor: textColor])
                innerY += 30
            }
            y += inputCardHeight + 16
            
            // Результат
            if let calc = calculatedItem {
                let resultCardRect = CGRect(x: padding, y: y, width: contentWidth, height: 64)
                UIColor(red: 30/255, green: 60/255, blue: 120/255, alpha: 1).setFill()
                UIBezierPath(roundedRect: resultCardRect, cornerRadius: 12).fill()
                
                let nameLbl = calc.name as NSString
                nameLbl.draw(at: CGPoint(x: padding + 16, y: y + 8),
                            withAttributes: [.font: labelFont, .foregroundColor: secondaryText])
                let valLbl = "= \(calc.value) \(calc.unit)".trimmingCharacters(in: .whitespaces) as NSString
                valLbl.draw(at: CGPoint(x: padding + 16, y: y + 30),
                           withAttributes: [.font: resultFont, .foregroundColor: accentColor])
                y += 64 + 16
            }
            
            // Дата
            if let date = savedCalculation.timestamp {
                let dateLbl = Self.dateFormatter.string(from: date) as NSString
                dateLbl.draw(at: CGPoint(x: padding, y: y),
                            withAttributes: [.font: captionFont, .foregroundColor: secondaryText])
            }
        }
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // 1. Название формулы
                Text(savedCalculation.formulaName ?? L10n.detailsTitle)
                    .font(.largeTitle)
                    .padding(.bottom)

                // 2. Формула с символами
                Text(L10n.formulaLabel)
                    .font(.headline)
                Group {
                    if let formulaId = savedCalculation.formulaId,
                       let calculatedSymbol = savedCalculation.calculatedSymbol,
                       let physicsData = loadPhysicsData(),
                       let formula = physicsData.formulas.first(where: { $0.id == formulaId }) {
                        MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol))
                            .font(.title2)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.bottom, 8)
                    } else {
                        MathLabel(latex: savedCalculation.equationLatex ?? "")
                            .font(.title2)
                            .padding(.vertical, 5)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.bottom, 8)
                    }
                }

                // 3. Формула с подставленными значениями
                Text(L10n.solutionLabel)
                    .font(.headline)
                MathLabel(latex: solvedEquationString)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                // 4. Список всех переменных
                Text(L10n.valuesLabel)
                    .font(.headline)
                ForEach(allVariablesList, id: \.symbol) { item in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(item.name) (\(item.symbol))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            Text("\(item.value) \(item.unit)")
                                .font(.body.weight(item.isCalculated ? .bold : .medium))
                                .foregroundColor(item.isCalculated ? .accentColor : .primary)
                            if item.isCalculated {
                                Text("(\(L10n.calculated))")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    Divider()
                }

                // 5. Дата сохранения
                HStack {
                     Spacer()
                     Text("\(L10n.savedAt) \(savedCalculation.timestamp ?? Date(), formatter: Self.dateFormatter)")
                         .font(.caption)
                         .foregroundColor(.secondary)
                     Spacer()
                 }
                 .padding(.top)

                // 6. Кнопки действий
                HStack(spacing: 12) {
                    Button {
                        UIPasteboard.general.string = generateDetailShareText()
                        withAnimation { copiedToClipboard = true }
                        Task {
                            try? await Task.sleep(for: .seconds(2))
                            copiedToClipboard = false
                        }
                    } label: {
                        ActionButtonLabel(
                            icon: copiedToClipboard ? "checkmark.circle.fill" : "doc.on.doc",
                            label: L10n.copy,
                            color: copiedToClipboard ? .green : .accentColor
                        )
                    }
                    
                    Button {
                        let image = renderShareCard()
                        let text = generateDetailShareText()
                        ShareHelper.share(items: [image, text])
                    } label: {
                        ActionButtonLabel(icon: "square.and.arrow.up", label: L10n.share, color: .accentColor)
                    }
                    
                    if let formulaId = savedCalculation.formulaId,
                       let physicsData = loadPhysicsData(),
                       let formula = physicsData.formulas.first(where: { $0.id == formulaId }) {
                        NavigationLink {
                            CalculationView(formula: formula)
                        } label: {
                            ActionButtonLabel(icon: "arrow.counterclockwise", label: L10n.newCalculation, color: .accentColor)
                        }
                    }
                }
                .padding(.top, 4)

            } // Конец VStack
            .padding() // Отступы для VStack
        } // Конец ScrollView
        .navigationTitle(L10n.detailTitle)
        .navigationBarTitleDisplayMode(.inline)
        .oledBackground()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .alert(L10n.deleteCalcTitle, isPresented: $showDeleteConfirmation) {
            Button(L10n.delete, role: .destructive) {
                PersistenceController.shared.deleteCalculation(savedCalculation)
                dismiss()
            }
            Button(L10n.cancel, role: .cancel) {}
        } message: {
            Text(L10n.deleteCalcMessage)
        }
    } // Конец body
} // Конец CalculationDetailView


// --- Предпросмотр для CalculationDetailView ---
#Preview {
    // Создаем моковый контекст и один моковый объект SavedCalculation
    let controller = PersistenceController(inMemory: true)
    let context = controller.container.viewContext

    // Нужны моковые данные для Formula и Variable
     struct MockVariable: Codable, Identifiable, Hashable { var id: String { symbol }; let symbol: String; let name_ru: String; let name_en: String; let unit_si: String; var localizedName: String { name_ru }}
     struct MockFormula: Codable, Identifiable, Hashable { var id: String; let subsectionId: String; let name_ru: String; let name_en: String; let levels: [String]; let equation_latex: String; let description_ru: String; let description_en: String; let variables: [MockVariable]; let calculation_rules: [String: String]; var localizedName: String { name_ru } }

     let mockVars = [
         MockVariable(symbol: "F", name_ru: "Сила", name_en: "Force", unit_si: "Н"),
         MockVariable(symbol: "m", name_ru: "Масса", name_en: "Mass", unit_si: "кг"),
         MockVariable(symbol: "a", name_ru: "Ускорение", name_en: "Acceleration", unit_si: "м/с²")
     ]
     let mockFormula = MockFormula(id: "newton_second", subsectionId: "dyn", name_ru: "Второй закон Ньютона", name_en: "NLS", levels: ["s"], equation_latex: "F = m \\cdot a", description_ru: "", description_en: "", variables: mockVars, calculation_rules: [:])

     let mockSavedCalc = SavedCalculation(context: context)
     mockSavedCalc.formulaId = mockFormula.id
     mockSavedCalc.formulaName = mockFormula.localizedName
     mockSavedCalc.equationLatex = mockFormula.equation_latex
     mockSavedCalc.calculatedSymbol = "F"
     mockSavedCalc.calculatedValue = 804.0
     mockSavedCalc.timestamp = Date()
     // Кодируем словари/массивы
     mockSavedCalc.inputValuesData = try? JSONEncoder().encode(["m": "23", "a": "35"]) // Входные данные как строки
     mockSavedCalc.variablesData = try? JSONEncoder().encode(mockVars) // Переменные формулы

    return NavigationView { // Оборачиваем в NavigationView для работы NavigationLink
        CalculationDetailView(savedCalculation: mockSavedCalc)
           .environment(\.managedObjectContext, context)
    }
}
