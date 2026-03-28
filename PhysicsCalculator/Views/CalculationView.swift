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
                            .accessibilityHidden(true)
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
        .scrollDismissesKeyboard(.interactively)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingInfo = true
                } label: {
                    Image(systemName: "info.circle")
                }
                .accessibilityLabel(L10n.infoTitle)
            }
        }
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
                    unitSelections: selectedUnits,
                    calculationDate: viewModel.calculationDate
                )
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
        variable.displaySymbol
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
            
            if let units = availableUnits, units.count > 1 {
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
