import SwiftUI

struct MultiCalcView: View {
    let formula: Formula
    let unknownSymbol: String
    
    @State private var rows: [[String: String]] = [[:]]
    @State private var results: [Double?] = [nil]
    @State private var errorMessage: String?

    private let calculationService = CalculationService()
    
    private var inputVariables: [Variable] {
        formula.variables.filter { $0.symbol != unknownSymbol }
    }
    
    private var resultVariable: Variable? {
        formula.variables.first { $0.symbol == unknownSymbol }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Заголовок
                VStack(spacing: 4) {
                    Text(formula.localizedName)
                        .font(.headline)
                    if let rv = resultVariable {
                        Text(L10n.multiCalcSubtitle(rv.localizedName, rv.symbol))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 8)
                
                // Таблица
                ScrollView(.horizontal, showsIndicators: true) {
                    VStack(spacing: 0) {
                        // Заголовок таблицы
                        HStack(spacing: 0) {
                            Text("#")
                                .frame(width: 36)
                                .font(.caption.weight(.semibold))
                            
                            ForEach(inputVariables) { variable in
                                Text("\(variable.symbol), \(variable.unit_si)")
                                    .frame(width: 100)
                                    .font(.caption.weight(.semibold))
                            }
                            
                            if let rv = resultVariable {
                                Text("\(rv.symbol), \(rv.unit_si)")
                                    .frame(width: 120)
                                    .font(.caption.weight(.bold))
                                    .foregroundColor(.accentColor)
                            }
                        }
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                        
                        Divider()
                        
                        // Строки данных
                        ForEach(rows.indices, id: \.self) { rowIndex in
                            HStack(spacing: 0) {
                                Text("\(rowIndex + 1)")
                                    .frame(width: 36)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                
                                ForEach(inputVariables) { variable in
                                    TextField("—", text: Binding(
                                        get: { rows[rowIndex][variable.symbol, default: ""] },
                                        set: { rows[rowIndex][variable.symbol] = $0 }
                                    ))
                                    .keyboardType(.decimalPad)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(size: 14))
                                    .frame(width: 100)
                                    .padding(.horizontal, 2)
                                }
                                
                                if let result = results[rowIndex] {
                                    Text(String(format: "%.4g", result))
                                        .frame(width: 120)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.accentColor)
                                } else {
                                    Text("—")
                                        .frame(width: 120)
                                        .font(.system(size: 14))
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                            
                            if rowIndex < rows.count - 1 {
                                Divider()
                            }
                        }
                    }
                    .padding(.horizontal, 4)
                }
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                
                // Ошибка
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                // Кнопки
                HStack(spacing: 12) {
                    Button {
                        addRow()
                    } label: {
                        Label(L10n.addRow, systemImage: "plus")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(10)
                    
                    if rows.count > 1 {
                        Button {
                            removeLastRow()
                        } label: {
                            Label(L10n.removeRow, systemImage: "minus")
                                .font(.subheadline)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                        }
                        .buttonStyle(.bordered)
                        .tint(.red)
                        .cornerRadius(10)
                    }
                }
                
                Button {
                    calculateAll()
                } label: {
                    Text(L10n.calculateAll)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(12)
                
                // Статистика результатов
                let validResults = results.compactMap { $0 }
                if validResults.count > 1, let rv = resultVariable {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.statistics)
                            .font(.headline)
                        
                        HStack {
                            StatItem(label: L10n.statMin, value: validResults.min()!, unit: rv.unit_si)
                            Spacer()
                            StatItem(label: L10n.statMax, value: validResults.max()!, unit: rv.unit_si)
                            Spacer()
                            StatItem(label: L10n.statAvg, value: validResults.reduce(0, +) / Double(validResults.count), unit: rv.unit_si)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(L10n.multiCalcTitle)
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
    }
    
    private func addRow() {
        // Pre-fill constants
        var newRow: [String: String] = [:]
        for variable in inputVariables {
            if let constant = PhysicalConstants.match(for: variable) {
                newRow[variable.symbol] = PhysicalConstants.formattedValue(constant)
            }
        }
        rows.append(newRow)
        results.append(nil)
    }
    
    private func removeLastRow() {
        guard rows.count > 1 else { return }
        rows.removeLast()
        results.removeLast()
    }
    
    private func calculateAll() {
        errorMessage = nil
        guard let rule = formula.calculation_rules[unknownSymbol] else {
            errorMessage = L10n.noRuleFound
            return
        }
        
        for i in rows.indices {
            var variables: [String: Double] = [:]
            var valid = true
            
            for variable in inputVariables {
                guard let valStr = rows[i][variable.symbol]?.replacingOccurrences(of: ",", with: "."),
                      let val = Double(valStr) else {
                    valid = false
                    break
                }
                variables[variable.symbol] = val
            }
            
            if valid {
                results[i] = try? calculationService.calculate(rule: rule, variables: variables)
            } else {
                results[i] = nil
            }
        }
    }
}

struct StatItem: View {
    let label: String
    let value: Double
    let unit: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "%.4g", value))
                .font(.system(.body, weight: .semibold))
                .foregroundColor(.accentColor)
            Text(unit)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
    }
}
