import SwiftUI
import Charts
import Photos

struct FormulaGraphView: View {
    let formula: Formula
    let xVariable: Variable
    let yVariable: Variable
    let otherValues: [String: Double]
    @State private var points: [GraphPoint] = []
    @State private var minX: Double = 0
    @State private var maxX: Double = 100
    @State private var stepX: Double = 1
    @State private var showingSaveConfirmation = false
    @Environment(\.displayScale) private var displayScale
    
    struct GraphPoint: Identifiable {
        let id = UUID()
        let x: Double
        let y: Double
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Настройки диапазона
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.rangeSettings)
                        .font(.headline)
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading) {
                            Text(L10n.minimum).font(.caption).foregroundColor(.secondary)
                            TextField(L10n.minimum, value: $minX, format: .number.precision(.fractionLength(1...10)))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(L10n.maximum).font(.caption).foregroundColor(.secondary)
                            TextField(L10n.maximum, value: $maxX, format: .number.precision(.fractionLength(1...10)))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .keyboardType(.decimalPad)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(L10n.step).font(.caption).foregroundColor(.secondary)
                            TextField(L10n.step, value: $stepX, format: .number.precision(.fractionLength(1...10)))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 80)
                                .keyboardType(.decimalPad)
                        }
                    }
                    
                    Button(L10n.updateGraph) {
                        calculatePoints()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // График
                chartView
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                
                // Заголовок графика
                Text(L10n.graphDependency(yVariable.localizedName, xVariable.localizedName))
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                // Легенда
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.fixedValues)
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
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)
                
                // Кнопка сохранения
                Button {
                    saveGraphAsImage()
                } label: {
                    Label(L10n.saveGraph, systemImage: "square.and.arrow.down")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.borderedProminent)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(L10n.graphTitle)
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
            calculatePoints()
        }
        .overlay {
            if showingSaveConfirmation {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text(L10n.graphSaved)
                            .font(.subheadline.weight(.medium))
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding(.bottom, 40)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
    
    @ViewBuilder
    private var chartView: some View {
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
    
    @MainActor
    private func saveGraphAsImage() {
        // Создаём рендерируемый вид графика с заголовком и легендой
        let exportView = VStack(spacing: 12) {
            Text(formula.localizedName)
                .font(.title3.weight(.semibold))
            
            Text(L10n.graphDependency(yVariable.localizedName, xVariable.localizedName))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            chartView
                .frame(width: 380, height: 300)
            
            HStack {
                ForEach(formula.variables) { variable in
                    if variable.symbol != xVariable.symbol && variable.symbol != yVariable.symbol {
                        Text("\(variable.localizedName) = \(otherValues[variable.symbol, default: 0]) \(variable.unit_si)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        
        let renderer = ImageRenderer(content: exportView)
        renderer.scale = displayScale
        
        guard let image = renderer.uiImage else { return }
        
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        switch status {
        case .authorized, .limited:
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            withAnimation { showingSaveConfirmation = true }
            Task {
                try? await Task.sleep(for: .seconds(2.5))
                withAnimation { showingSaveConfirmation = false }
            }
        case .notDetermined:
            Task {
                let newStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                if newStatus == .authorized || newStatus == .limited {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    withAnimation { showingSaveConfirmation = true }
                    try? await Task.sleep(for: .seconds(2.5))
                    withAnimation { showingSaveConfirmation = false }
                }
            }
        default:
            break
        }
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