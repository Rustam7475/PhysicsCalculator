import SwiftUI
import SwiftMath


struct CalculationView: View {
    @StateObject private var viewModel: CalculationViewModel
    @State private var selectedUnits: [String: String] = [:]
    @State private var showingInfo = false // symbol -> unitOption.id

    // Инициализатор
    init(formula: Formula) {
        _viewModel = StateObject(wrappedValue: CalculationViewModel(formula: formula))
    }

    // Основное тело View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Заголовок формулы
                Text(viewModel.formula.localizedName)
                    .font(.title2.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.top, 8)
                
                // Формула в карточке
                VStack(spacing: 8) {
                    GeometryReader { geometry in
                        MathLabel(latex: viewModel.formula.equation_latex,
                                fontSize: min(geometry.size.width * 0.08, 28))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 50)
                    
                    // Описание
                    Text(viewModel.formula.localizedDescription)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)

                // Список переменных
                VStack(spacing: 0) {
                    ForEach(Array(viewModel.formula.variables.enumerated()), id: \.element.id) { index, variable in
                        VariableInputRow(
                            variable: variable,
                            inputValue: Binding(
                                get: { viewModel.inputValues[variable.symbol, default: ""] },
                                set: { viewModel.inputValues[variable.symbol] = $0 }
                            ),
                            isUnknown: viewModel.selectedUnknownSymbol == variable.symbol,
                            isConstant: PhysicalConstants.match(for: variable) != nil,
                            calculatedValue: (viewModel.selectedUnknownSymbol == variable.symbol) ? viewModel.calculatedResult : nil,
                            selectedUnitId: Binding(
                                get: { selectedUnits[variable.symbol] },
                                set: { selectedUnits[variable.symbol] = $0 }
                            ),
                            onSelectUnknown: { viewModel.selectUnknown(symbol: variable.symbol) }
                        )
                        if index < viewModel.formula.variables.count - 1 {
                            Divider().padding(.leading, 48)
                        }
                    }
                }
                .padding(.vertical, 8)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)

                // Отображение ошибки
                if let error = viewModel.errorMessage {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(.red)
                        Text(error)
                            .foregroundColor(.red)
                            .font(.callout)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
                }

                // Кнопки действий
                HStack(spacing: 12) {
                    Button {
                        viewModel.calculate(unitSelections: selectedUnits)
                    } label: {
                        Text(L10n.calculate)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.borderedProminent)
                    .cornerRadius(12)
                    .disabled(!viewModel.canCalculate)
                    
                    Button {
                        viewModel.reset()
                    } label: {
                        Text(L10n.reset)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .buttonStyle(.bordered)
                    .cornerRadius(12)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if viewModel.inputValues.isEmpty {
                viewModel.reset()
            }
        }
        .navigationDestination(isPresented: $viewModel.showingResult) {
            if let result = viewModel.calculatedResult, let symbol = viewModel.selectedUnknownSymbol {
                CalculationResultView(
                    formula: viewModel.formula,
                    calculatedSymbol: symbol,
                    calculatedValue: result,
                    inputValues: viewModel.inputValues,
                    calculationDate: viewModel.calculationDate
                )
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingInfo = true
                } label: {
                    Image(systemName: "info.circle")
                }
            }
        }
        .sheet(isPresented: $showingInfo) {
            FormulaInfoView(formula: viewModel.formula)
        }
        .oledBackground()
    }
} // Конец struct CalculationView


// --- Вспомогательное View ---
struct VariableInputRow: View {
    let variable: Variable
    @Binding var inputValue: String
    let isUnknown: Bool
    let isConstant: Bool
    let calculatedValue: Double?
    @Binding var selectedUnitId: String?
    let onSelectUnknown: () -> Void
    
    private var availableUnits: [UnitConverter.UnitOption]? {
        UnitConverter.units(forSI: variable.unit_si)
    }

    private var displaySymbol: String {
        let greekMap: [String: String] = [
            "nu": "ν", "alpha": "α", "beta": "β", "gamma": "γ",
            "delta": "δ", "epsilon": "ε", "theta": "θ", "lambda": "λ",
            "mu": "μ", "rho": "ρ", "sigma": "σ", "tau": "τ",
            "phi": "φ", "omega": "ω", "eta": "η", "Phi": "Φ",
            "DeltaS": "ΔS", "DeltaU": "ΔU", "DeltaT": "ΔT",
            "dPhi": "ΔΦ", "dphi": "Δφ", "dPhiB": "dΦ_B", "dPhiE": "dΦ_E",
            "alpha1": "α₁", "alpha2": "α₂",
            "v1prime": "v'₁", "v2prime": "v'₂",
            "n_ord": "n", "Avyh": "A_вых", "Eup": "E_уп", "Ep": "E_p",
            "eps0": "ε₀", "mu0": "μ₀", "Z0": "Z₀", "Id": "I_d"
        ]
        return greekMap[variable.symbol] ?? variable.symbol
    }

    var body: some View {
        HStack(spacing: 10) {
            Button(action: onSelectUnknown) {
                Image(systemName: isUnknown ? "largecircle.fill.circle" : "circle")
                    .font(.system(size: 20))
                    .foregroundColor(isUnknown ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
            
            Text(displaySymbol)
                .font(.system(size: 17, weight: .medium, design: .serif))
                .frame(width: 36, alignment: .leading)
            
            if isUnknown {
                Text(L10n.willBeCalculated)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.accentColor)
                    .italic()
                    .font(.subheadline)
            } else {
                HStack(spacing: 4) {
                    TextField(variable.localizedName, text: $inputValue)
                        .keyboardType(.decimalPad)
                        .frame(maxWidth: .infinity)
                        .textFieldStyle(.roundedBorder)
                        .disabled(isConstant)
                        .opacity(isConstant ? 0.7 : 1.0)
                    if isConstant && !inputValue.isEmpty {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            if let units = availableUnits, units.count > 1, !isUnknown {
                Menu {
                    ForEach(units) { unit in
                        Button(unit.name) {
                            selectedUnitId = unit.id
                        }
                    }
                } label: {
                    Text(units.first(where: { $0.id == selectedUnitId })?.symbol ?? variable.unit_si)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                        .fixedSize()
                }
            } else {
                Text(variable.unit_si)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .fixedSize()
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

// --- Предпросмотр ---
#Preview {
    let persistenceController = PersistenceController(inMemory: true)
    let context = persistenceController.container.viewContext
     if let previewData = loadPhysicsData(),
        let formula = previewData.formulas.first(where: { $0.id == "mech_school_newton_second" }) {
         NavigationView {
              CalculationView(formula: formula)
                 .environment(\.managedObjectContext, context)
         }
     } else { Text("Ошибка загрузки данных для превью") }
}
