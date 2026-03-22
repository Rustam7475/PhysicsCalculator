import SwiftUI
import CoreData
import SwiftMath


struct CalculationView: View {
    @StateObject private var viewModel: CalculationViewModel

    // Доступ к контексту Core Data
    @Environment(\.managedObjectContext) private var viewContext

    // FetchRequest для поиска сохраненных расчетов ЭТОЙ формулы
    @FetchRequest private var savedItems: FetchedResults<SavedCalculation>

    // Вычисляемое свойство, чтобы определить, сохранена ли эта формула
    private var isFavorite: Bool {
        !savedItems.isEmpty
    }

    // Инициализатор
    init(formula: Formula) {
        let predicate = NSPredicate(format: "formulaId == %@", formula.id)
        _savedItems = FetchRequest<SavedCalculation>(
            sortDescriptors: [NSSortDescriptor(keyPath: \SavedCalculation.timestamp, ascending: true)],
            predicate: predicate,
            animation: .default
        )
        _viewModel = StateObject(wrappedValue: CalculationViewModel(formula: formula))
    }

    // Основное тело View
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Заголовок формулы
                Text(viewModel.formula.localizedName)
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 8)
                
                // Отображение формулы
                GeometryReader { geometry in
                    MathLabel(latex: viewModel.formula.equation_latex, 
                            fontSize: min(geometry.size.width, geometry.size.height) * 0.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                
                // Описание
                Text(viewModel.formula.localizedDescription)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 4)

                // Список переменных
                ForEach(viewModel.formula.variables) { variable in
                    VariableInputRow(
                        variable: variable,
                        inputValue: Binding(
                            get: { viewModel.inputValues[variable.symbol, default: ""] },
                            set: { viewModel.inputValues[variable.symbol] = $0 }
                        ),
                        isUnknown: viewModel.selectedUnknownSymbol == variable.symbol,
                        calculatedValue: (viewModel.selectedUnknownSymbol == variable.symbol) ? viewModel.calculatedResult : nil,
                        onSelectUnknown: { viewModel.selectUnknown(symbol: variable.symbol) }
                    )
                    Divider()
                }

                // Отображение ошибки
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.callout)
                }

                // Кнопки действий
                HStack(spacing: 20) {
                    Button("Рассчитать") { viewModel.calculate() }
                        .buttonStyle(.borderedProminent)
                        .disabled(!viewModel.canCalculate)
                    Button("Сбросить") { viewModel.reset() }
                        .buttonStyle(.bordered)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                Spacer()
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
    }
} // Конец struct CalculationView


// --- Вспомогательное View ---
struct VariableInputRow: View {
    let variable: Variable
    @Binding var inputValue: String
    let isUnknown: Bool
    let calculatedValue: Double?
    let onSelectUnknown: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onSelectUnknown) {
                Image(systemName: isUnknown ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(isUnknown ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)
            
            Text("\(variable.symbol):")
                .frame(width: 40, alignment: .leading)
            
            if isUnknown {
                Text("Будет рассчитано")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                TextField("Введите значение \(variable.localizedName.lowercased())", text: $inputValue)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity)
                    .textFieldStyle(.roundedBorder)
                    .frame(height: 32)
            }
            
            Text(variable.unit_si)
                .foregroundColor(.secondary)
                .frame(width: 60, alignment: .trailing)
        }
        .frame(height: 40)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelectUnknown()
        }
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
