import SwiftUI
import UIKit

/// Калькулятор погрешностей: вычисляет абсолютную и относительную погрешности
/// результата на основе погрешностей входных измерений.
/// Используется метод распространения ошибок (частные производные, числовое дифференцирование).
struct ErrorCalculatorView: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    
    @State private var errors: [String: String] = [:]
    @State private var absoluteError: Double?
    @State private var relativeError: Double?
    @State private var isCalculated = false
    @State private var showSteps = false
    @State private var showInputFields = true
    @State private var partialDerivatives: [String: Double] = [:]
    @State private var termValues: [String: Double] = [:]
    @State private var copiedToClipboard = false
    
    private let calculationService = CalculationService()
    
    private var inputVariables: [Variable] {
        formula.variables.filter { $0.symbol != calculatedSymbol }
    }
    
    private func displayUnit(_ unit: String) -> String {
        unit == "—" ? "" : unit
    }
    
    private func displaySymbol(_ symbol: String) -> String {
        Variable.displaySymbol(for: symbol)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Заголовок
                Text(L10n.errorCalculator)
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                
                // Формула
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol),
                                fontSize: min(geometry.size.width * 0.07, 24))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 44)
                    
                    if let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                        Text("\(resultVar.localizedName) = \(CalculationService.formatNumber(calculatedValue)) \(displayUnit(resultVar.unit_si))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // Пошаговое решение погрешности
                if isCalculated, let absErr = absoluteError, let relErr = relativeError {
                    ErrorStepsSection(
                        formula: formula,
                        calculatedSymbol: calculatedSymbol,
                        calculatedValue: calculatedValue,
                        inputValues: inputValues,
                        errors: errors,
                        partialDerivatives: partialDerivatives,
                        termValues: termValues,
                        absoluteError: absErr,
                        relativeError: relErr,
                        isExpanded: $showSteps,
                        displaySymbol: displaySymbol
                    )
                }
                
                // Описание метода
                if !isCalculated {
                    Text(L10n.errorDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 4)
                }
                
                // Поля ввода погрешностей
                DisclosureGroup(isExpanded: $showInputFields) {
                    VStack(spacing: 0) {
                        ForEach(Array(inputVariables.enumerated()), id: \.element.id) { index, variable in
                            let isConstant = PhysicalConstants.match(for: variable) != nil
                            HStack(spacing: 10) {
                                Text("Δ\(displaySymbol(variable.symbol))")
                                    .font(.system(size: 16, weight: .medium, design: .serif))
                                    .frame(width: 50, alignment: .leading)
                                
                                TextField(isConstant ? L10n.errorConstant : L10n.errorPlaceholder, text: Binding(
                                    get: { errors[variable.symbol, default: isConstant ? "0" : ""] },
                                    set: { errors[variable.symbol] = $0 }
                                ))
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .disabled(isConstant)
                                .opacity(isConstant ? 0.6 : 1.0)
                                
                                Text(CalculationService.displayUnit(variable.unit_si))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .fixedSize()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            
                            if index < inputVariables.count - 1 {
                                Divider().padding(.leading, 48)
                            }
                        }
                    }
                    
                    // Кнопка расчёта / пересчёта внутри раскрытого блока
                    Button {
                        calculateError()
                    } label: {
                        Text(isCalculated ? L10n.recalculate : L10n.calculateError)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(12)
                    .disabled(!canCalculateError)
                    .padding(.top, 8)
                } label: {
                    Text(L10n.errorInputTitle)
                        .font(.subheadline.weight(.medium))
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // Результаты
                if isCalculated, let absErr = absoluteError, let relErr = relativeError {
                    VStack(spacing: 12) {
                        Text(L10n.errorResults)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                            // Абсолютная погрешность
                            HStack {
                                Text(L10n.absoluteError)
                                    .font(.subheadline)
                                Spacer()
                                Text("Δ\(displaySymbol(calculatedSymbol)) = \(CalculationService.formatNumber(absErr)) \(displayUnit(resultVar.unit_si))")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(.orange)
                            }
                            
                            Divider()
                            
                            // Относительная погрешность
                            HStack {
                                Text(L10n.relativeError)
                                    .font(.subheadline)
                                Spacer()
                                Text("δ\(displaySymbol(calculatedSymbol)) = \(String(format: "%.2f", relErr))%")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundColor(relErr < 5 ? .green : relErr < 15 ? .orange : .red)
                            }
                            
                            Divider()
                            
                            // Итоговая запись
                            VStack(spacing: 4) {
                                Text(L10n.errorFinalResult)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Text("\(resultVar.localizedName) = (\(CalculationService.formatNumber(calculatedValue)) ± \(CalculationService.formatNumber(absErr))) \(displayUnit(resultVar.unit_si))")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 4)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Кнопки копирования и отправки
                    HStack(spacing: 12) {
                        Button {
                            UIPasteboard.general.string = generateErrorShareText()
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
                            let image = renderErrorShareCard()
                            let text = generateErrorShareText()
                            ShareHelper.share(items: [image, text])
                        } label: {
                            ActionButtonLabel(icon: "square.and.arrow.up", label: L10n.share, color: .accentColor)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        .oledBackground()
        .onAppear {
            // Предзаполнить 0 для констант
            for variable in inputVariables {
                if PhysicalConstants.match(for: variable) != nil {
                    errors[variable.symbol] = "0"
                }
            }
        }
    }
    
    private var canCalculateError: Bool {
        for variable in inputVariables {
            let isConst = PhysicalConstants.match(for: variable) != nil
            if isConst { continue }
            let val = errors[variable.symbol, default: ""].trimmingCharacters(in: .whitespaces)
            if val.isEmpty { return false }
            guard let d = Double(val.replacingOccurrences(of: ",", with: ".")), d >= 0 else { return false }
        }
        return true
    }
    
    private func generateErrorShareText() -> String {
        guard let absErr = absoluteError, let relErr = relativeError,
              let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) else { return "" }
        
        let sym = displaySymbol(calculatedSymbol)
        var text = "📐 \(formula.localizedName)\n"
        text += "\(formula.localizedDescription)\n\n"
        
        // Входные значения
        text += L10n.shareInputValues + "\n"
        for variable in inputVariables {
            let val = inputValues[variable.symbol, default: ""]
            let err = errors[variable.symbol, default: "0"]
            text += "  • \(variable.localizedName) = \(val) ± \(err) \(displayUnit(variable.unit_si))\n"
        }
        
        // Формула погрешности
        text += "\n\(L10n.errorStepFormula)\n"
        text += "  Δ\(sym) = √(Σ(∂\(sym)/∂xᵢ · Δxᵢ)²)\n"
        let nonZeroVars = inputVariables.filter { (errors[$0.symbol, default: "0"] != "0") && !(errors[$0.symbol, default: "0"].isEmpty) }
        if !nonZeroVars.isEmpty {
            let expanded = nonZeroVars.map { v in
                "(∂\(sym)/∂\(displaySymbol(v.symbol)) · Δ\(displaySymbol(v.symbol)))"
            }.joined(separator: "² + ")
            text += "  Δ\(sym) = √(\(expanded)²)\n"
        }
        
        // Частные производные
        text += "\n\(L10n.errorStepDerivatives)\n"
        for variable in inputVariables {
            if let deriv = partialDerivatives[variable.symbol], deriv != 0 {
                text += "  ∂\(sym)/∂\(displaySymbol(variable.symbol)) = \(CalculationService.formatNumber(deriv))\n"
            }
        }
        
        // Подстановка значений
        text += "\n\(L10n.stepSubstitute)\n"
        var termParts: [String] = []
        for variable in inputVariables {
            if let deriv = partialDerivatives[variable.symbol], deriv != 0 {
                let err = errors[variable.symbol, default: "0"]
                text += "  (\(CalculationService.formatNumber(deriv))·\(err))² = \(CalculationService.formatNumber((deriv * (Double(err.replacingOccurrences(of: ",", with: ".")) ?? 0)) * (deriv * (Double(err.replacingOccurrences(of: ",", with: ".")) ?? 0))))\n"
                let term = termValues[variable.symbol] ?? 0
                termParts.append(CalculationService.formatNumber(term))
            }
        }
        if !termParts.isEmpty {
            let sumStr = termParts.joined(separator: " + ")
            let sumVal = termValues.values.reduce(0, +)
            text += "  Δ\(sym) = √(\(sumStr))\n"
            text += "  Δ\(sym) = √(\(String(format: "%.4g", sumVal))) ≈ \(CalculationService.formatNumber(absErr))\n"
        }
        
        // Результаты
        text += "\n\(L10n.errorResults)\n"
        text += "  Δ\(sym) = \(CalculationService.formatNumber(absErr)) \(displayUnit(resultVar.unit_si))\n"
        text += "  δ\(sym) = Δ\(sym)/|\(sym)| × 100%\n"
        text += "  δ\(sym) = \(CalculationService.formatNumber(absErr))/\(CalculationService.formatNumber(abs(calculatedValue))) × 100% ≈ \(String(format: "%.2f", relErr))%\n\n"
        text += "  ▸ \(resultVar.localizedName) = (\(CalculationService.formatNumber(calculatedValue)) ± \(CalculationService.formatNumber(absErr))) \(displayUnit(resultVar.unit_si))"
        return text
    }
    
    /// Рендерит карточку погрешности как UIImage
    private func renderErrorShareCard() -> UIImage {
        guard let absErr = absoluteError, let relErr = relativeError,
              let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) else {
            return UIImage()
        }
        
        let width: CGFloat = 600
        let padding: CGFloat = 30
        let contentWidth = width - 2 * padding
        
        let titleFont = UIFont.systemFont(ofSize: 24, weight: .bold)
        let labelFont = UIFont.systemFont(ofSize: 14)
        let valueFont = UIFont.systemFont(ofSize: 18, weight: .medium)
        let resultFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let bgColor = UIColor(red: 28/255, green: 28/255, blue: 30/255, alpha: 1)
        let cardColor = UIColor(red: 44/255, green: 44/255, blue: 46/255, alpha: 1)
        let textColor = UIColor.white
        let secondaryText = UIColor(white: 0.6, alpha: 1)
        let accentColor = UIColor(red: 52/255, green: 120/255, blue: 246/255, alpha: 1)
        
        var totalHeight: CGFloat = padding + 34 + 20
        totalHeight += CGFloat(inputVariables.count) * 50
        totalHeight += 20 + 90 + padding
        
        let size = CGSize(width: width, height: totalHeight)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { ctx in
            bgColor.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            
            var y: CGFloat = padding
            
            // Заголовок
            let titleStr = "\(formula.localizedName) — \(L10n.errorCalculator)" as NSString
            let titleRect = titleStr.boundingRect(with: CGSize(width: contentWidth, height: 100),
                                                    options: .usesLineFragmentOrigin,
                                                    attributes: [.font: titleFont, .foregroundColor: textColor], context: nil)
            titleStr.draw(in: CGRect(x: padding, y: y, width: contentWidth, height: titleRect.height),
                         withAttributes: [.font: titleFont, .foregroundColor: textColor])
            y += titleRect.height + 20
            
            // Входные значения с погрешностями
            let inputCardHeight = CGFloat(inputVariables.count) * 48 + 16
            let inputCardRect = CGRect(x: padding, y: y, width: contentWidth, height: inputCardHeight)
            cardColor.setFill()
            UIBezierPath(roundedRect: inputCardRect, cornerRadius: 12).fill()
            
            var innerY = y + 8
            for variable in inputVariables {
                let nameLbl = variable.localizedName as NSString
                nameLbl.draw(at: CGPoint(x: padding + 16, y: innerY),
                            withAttributes: [.font: labelFont, .foregroundColor: secondaryText])
                innerY += 18
                let val = CalculationService.formatInputValue(inputValues[variable.symbol, default: ""])
                let err = errors[variable.symbol, default: "0"]
                let unit = displayUnit(variable.unit_si)
                let valLbl = "\(val) ± \(err) \(unit)".trimmingCharacters(in: .whitespaces) as NSString
                valLbl.draw(at: CGPoint(x: padding + 16, y: innerY),
                           withAttributes: [.font: valueFont, .foregroundColor: textColor])
                innerY += 30
            }
            y += inputCardHeight + 16
            
            // Результат
            let resultCardRect = CGRect(x: padding, y: y, width: contentWidth, height: 84)
            UIColor(red: 30/255, green: 60/255, blue: 120/255, alpha: 1).setFill()
            UIBezierPath(roundedRect: resultCardRect, cornerRadius: 12).fill()
            
            let unit = displayUnit(resultVar.unit_si)
            let absLabel = "Δ = \(CalculationService.formatNumber(absErr)) \(unit)" as NSString
            absLabel.draw(at: CGPoint(x: padding + 16, y: y + 10),
                         withAttributes: [.font: valueFont, .foregroundColor: textColor])
            let relLabel = "δ = \(String(format: "%.2f", relErr))%" as NSString
            relLabel.draw(at: CGPoint(x: padding + 16, y: y + 34),
                         withAttributes: [.font: valueFont, .foregroundColor: textColor])
            let finalLabel = "(\(CalculationService.formatNumber(calculatedValue)) ± \(CalculationService.formatNumber(absErr))) \(unit)" as NSString
            finalLabel.draw(at: CGPoint(x: padding + 16, y: y + 58),
                           withAttributes: [.font: resultFont, .foregroundColor: accentColor])
        }
    }
    
    /// Расчёт погрешности методом числового дифференцирования (распространение ошибок)
    private func calculateError() {
        guard let rule = formula.calculation_rules[calculatedSymbol] else { return }
        
        // Собираем числовые значения переменных
        var baseVars: [String: Double] = [:]
        for variable in inputVariables {
            guard let str = inputValues[variable.symbol]?.replacingOccurrences(of: ",", with: "."),
                  let val = Double(str) else { return }
            baseVars[variable.symbol] = val
        }
        
        // Вычисляем f(x₁,x₂,...) — базовое значение
        guard let f0 = try? calculationService.calculate(rule: rule, variables: baseVars) else { return }
        
        // ΔF = √(Σ (∂f/∂xᵢ · Δxᵢ)²)
        var sumSquares = 0.0
        var derivs: [String: Double] = [:]
        var terms: [String: Double] = [:]
        
        for variable in inputVariables {
            let errStr = errors[variable.symbol, default: "0"]
                .replacingOccurrences(of: ",", with: ".")
            let deltaX = Double(errStr) ?? 0.0
            if deltaX == 0 {
                derivs[variable.symbol] = 0
                terms[variable.symbol] = 0
                continue
            }
            
            guard let xVal = baseVars[variable.symbol], xVal != 0 else {
                // Для нулевого значения — прямой сдвиг
                var shifted = baseVars
                shifted[variable.symbol] = deltaX
                if let fShifted = try? calculationService.calculate(rule: rule, variables: shifted) {
                    let derivative = (fShifted - f0) / deltaX
                    derivs[variable.symbol] = derivative
                    let term = (derivative * deltaX) * (derivative * deltaX)
                    terms[variable.symbol] = term
                    sumSquares += term
                }
                continue
            }
            
            // Числовая частная производная: центральная разность
            let h = abs(xVal) * 1e-6  // маленький шаг
            var varsPlus = baseVars
            var varsMinus = baseVars
            varsPlus[variable.symbol] = xVal + h
            varsMinus[variable.symbol] = xVal - h
            
            guard let fPlus = try? calculationService.calculate(rule: rule, variables: varsPlus),
                  let fMinus = try? calculationService.calculate(rule: rule, variables: varsMinus) else { continue }
            
            let derivative = (fPlus - fMinus) / (2 * h)
            derivs[variable.symbol] = derivative
            let term = (derivative * deltaX) * (derivative * deltaX)
            terms[variable.symbol] = term
            sumSquares += term
        }
        
        let absErr = sqrt(sumSquares)
        let relErr = abs(f0) > 0 ? (absErr / abs(f0)) * 100 : 0
        
        withAnimation {
            absoluteError = absErr
            relativeError = relErr
            partialDerivatives = derivs
            termValues = terms
            isCalculated = true
            showSteps = true
            withAnimation { showInputFields = false }
        }
    }
}

// MARK: - Error Step-by-step Section

struct ErrorStepsSection: View {
    let formula: Formula
    let calculatedSymbol: String
    let calculatedValue: Double
    let inputValues: [String: String]
    let errors: [String: String]
    let partialDerivatives: [String: Double]
    let termValues: [String: Double]
    let absoluteError: Double
    let relativeError: Double
    @Binding var isExpanded: Bool
    let displaySymbol: (String) -> String
    
    private var inputVariables: [Variable] {
        formula.variables.filter { $0.symbol != calculatedSymbol }
    }
    
    // Переменные с ненулевой погрешностью
    private var activeVariables: [Variable] {
        inputVariables.filter {
            let d = Double(errors[$0.symbol, default: "0"].replacingOccurrences(of: ",", with: ".")) ?? 0
            return d > 0
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    Image(systemName: "list.number")
                        .foregroundColor(.accentColor)
                    Text(L10n.stepByStep)
                        .font(.subheadline.weight(.medium))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding()
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Divider()
                    
                    let sym = displaySymbol(calculatedSymbol)
                    
                    // Step 1: Formula
                    StepRow(number: 1, title: L10n.stepOriginalFormula) {
                        GeometryReader { geometry in
                            MathLabel(latex: formula.getRearrangedFormula(for: calculatedSymbol),
                                    fontSize: min(geometry.size.width * 0.07, 24))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .frame(height: 44)
                    }
                    
                    // Step 2: Error propagation formula
                    StepRow(number: 2, title: L10n.errorStepFormula) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Δ\(sym) = √(Σ(∂\(sym)/∂xᵢ · Δxᵢ)²)")
                                .font(.system(size: 15, design: .serif))
                            
                            if !activeVariables.isEmpty {
                                let parts = activeVariables.map { v in
                                    "(∂\(sym)/∂\(displaySymbol(v.symbol)) · Δ\(displaySymbol(v.symbol)))²"
                                }
                                Text("Δ\(sym) = √(\(parts.joined(separator: " + ")))")
                                    .font(.system(size: 13, design: .serif))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    
                    // Step 3: Partial derivatives
                    StepRow(number: 3, title: L10n.errorStepDerivatives) {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(activeVariables, id: \.symbol) { variable in
                                let deriv = partialDerivatives[variable.symbol] ?? 0
                                Text("∂\(sym)/∂\(displaySymbol(variable.symbol)) = \(CalculationService.formatNumber(deriv))")
                                    .font(.system(size: 14, design: .serif))
                            }
                        }
                    }
                    
                    // Step 4: Substitute
                    StepRow(number: 4, title: L10n.stepSubstitute) {
                        VStack(alignment: .leading, spacing: 4) {
                            let parts = activeVariables.map { v -> String in
                                let deriv = partialDerivatives[v.symbol] ?? 0
                                let delta = Double(errors[v.symbol, default: "0"].replacingOccurrences(of: ",", with: ".")) ?? 0
                                return "(\(CalculationService.formatNumber(deriv))·\(CalculationService.formatNumber(delta)))²"
                            }
                            Text("Δ\(sym) = √(\(parts.joined(separator: " + ")))")
                                .font(.system(size: 13, design: .serif))
                            
                            let termParts = activeVariables.map { v -> String in
                                let term = termValues[v.symbol] ?? 0
                                return CalculationService.formatNumber(term)
                            }
                            Text("Δ\(sym) = √(\(termParts.joined(separator: " + ")))")
                                .font(.system(size: 13, design: .serif))
                                .foregroundColor(.secondary)
                            
                            let sumTerms = activeVariables.reduce(0.0) { $0 + (termValues[$1.symbol] ?? 0) }
                            Text("Δ\(sym) = √(\(CalculationService.formatNumber(sumTerms))) ≈ \(CalculationService.formatNumber(absoluteError))")
                                .font(.system(size: 14, weight: .medium, design: .serif))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    // Step 5: Relative error
                    StepRow(number: 5, title: L10n.errorStepRelative) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("δ\(sym) = Δ\(sym)/|\(sym)| × 100%")
                                .font(.system(size: 14, design: .serif))
                            Text("δ\(sym) = \(CalculationService.formatNumber(absoluteError))/\(CalculationService.formatNumber(abs(calculatedValue))) × 100% ≈ \(String(format: "%.2f", relativeError))%")
                                .font(.system(size: 13, design: .serif))
                                .foregroundColor(relativeError < 5 ? .green : relativeError < 15 ? .orange : .red)
                        }
                    }
                    
                    // Step 6: Final
                    if let resultVar = formula.variables.first(where: { $0.symbol == calculatedSymbol }) {
                        let unit = CalculationService.displayUnit(resultVar.unit_si)
                        StepRow(number: 6, title: L10n.errorFinalResult) {
                            Text("\(resultVar.localizedName) = (\(CalculationService.formatNumber(calculatedValue)) ± \(CalculationService.formatNumber(absoluteError))) \(unit)")
                                .font(.system(size: 15, weight: .semibold))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}
