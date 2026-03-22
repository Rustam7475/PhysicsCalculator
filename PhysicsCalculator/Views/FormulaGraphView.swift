import SwiftUI
import Charts
import Foundation

struct FormulaGraphView: View {
    let formula: Formula
    let xVariable: Variable
    let yVariable: Variable
    let otherValues: [String: Double]
    @State private var points: [GraphPoint] = []
    @State private var minX: Double = 0
    @State private var maxX: Double = 100
    @State private var stepX: Double = 1
    
    struct GraphPoint: Identifiable {
        let id = UUID()
        let x: Double
        let y: Double
    }
    
    var body: some View {
        VStack {
            // Настройки диапазона
            VStack(alignment: .leading) {
                Text("Настройки диапазона")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                HStack(spacing: 12) {
                    // Минимум
                    VStack(alignment: .leading) {
                        Text("Минимум")
                        Text(xVariable.localizedName)
                        TextField("Мин", value: $minX, format: .number.precision(.fractionLength(1...10)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                            .keyboardType(.decimalPad)
                            .onChange(of: minX) { _, _ in
                                calculatePoints()
                            }
                    }
                    
                    // Максимум
                    VStack(alignment: .leading) {
                        Text("Максимум")
                        Text(xVariable.localizedName)
                        TextField("Макс", value: $maxX, format: .number.precision(.fractionLength(1...10)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                            .keyboardType(.decimalPad)
                            .onChange(of: maxX) { _, _ in
                                calculatePoints()
                            }
                    }
                    
                    // Шаг
                    VStack(alignment: .leading) {
                        Text("Шаг")
                        Text(" ")  // Placeholder для выравнивания
                        TextField("Шаг", value: $stepX, format: .number.precision(.fractionLength(1...10)))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 80)
                            .keyboardType(.decimalPad)
                            .onChange(of: stepX) { _, _ in
                                if stepX > 0 {  // Проверяем, что шаг положительный
                                    calculatePoints()
                                }
                            }
                    }
                }
                .padding(.bottom)
                
                Button("Обновить график") {
                    calculatePoints()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            
            // График
            Chart(points) { point in
                LineMark(
                    x: .value(xVariable.localizedName, point.x),
                    y: .value(yVariable.localizedName, point.y)
                )
            }
            .chartXAxis {
                AxisMarks(position: .bottom) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartXAxisLabel(position: .bottom) {
                Text("\(xVariable.localizedName), \(xVariable.unit_si)")
            }
            .chartYAxisLabel(position: .leading) {
                Text("\(yVariable.localizedName), \(yVariable.unit_si)")
            }
            .frame(height: 300)
            .padding()
            
            // Заголовок графика
            Text("График зависимости \(yVariable.localizedName) от \(xVariable.localizedName)")
                .font(.headline)
                .padding(.top)
            
            // Легенда
            VStack(alignment: .leading, spacing: 8) {
                Text("Фиксированные значения:")
                    .font(.headline)
                
                ForEach(formula.variables) { variable in
                    if variable.symbol != xVariable.symbol && variable.symbol != yVariable.symbol {
                        HStack {
                            Text("\(variable.localizedName):")
                            Text("\(otherValues[variable.symbol, default: 0]) \(variable.unit_si)")
                                .bold()
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("График зависимости")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            calculatePoints()
        }
    }
    
    private let calculationService = CalculationService()
    
    private func calculatePoints() {
        guard let rule = formula.calculation_rules[yVariable.symbol], stepX > 0 else {
            points = []
            return
        }
        
        var newPoints: [GraphPoint] = []
        
        for x in stride(from: minX, through: maxX, by: stepX) {
            var variables = otherValues
            variables[xVariable.symbol] = x
            
            if let y = try? calculationService.calculate(rule: rule, variables: variables) {
                newPoints.append(GraphPoint(x: x, y: y))
            }
        }
        
        points = newPoints
    }
}

#Preview {
    let formula = Formula(
        id: "test",
        subsectionId: "test",
        name_ru: "Тест",
        name_en: "Test",
        levels: ["test"],
        equation_latex: "y = kx",
        description_ru: "Тест",
        description_en: "Test",
        variables: [
            Variable(symbol: "y", name_ru: "Y", name_en: "Y", unit_si: "м"),
            Variable(symbol: "k", name_ru: "K", name_en: "K", unit_si: "1"),
            Variable(symbol: "x", name_ru: "X", name_en: "X", unit_si: "м")
        ],
        calculation_rules: [
            "y": "k * x",
            "k": "y / x",
            "x": "y / k"
        ]
    )
    FormulaGraphView(
        formula: formula,
        xVariable: formula.variables[2],
        yVariable: formula.variables[0],
        otherValues: ["k": 2]
    )
} 