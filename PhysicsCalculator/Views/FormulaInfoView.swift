import SwiftUI

struct FormulaInfoView: View {
    let formula: Formula
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Название
                    Text(formula.localizedName)
                        .font(.title2.weight(.bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Формула
                    GeometryReader { geometry in
                        MathLabel(latex: formula.equation_latex,
                                  fontSize: min(geometry.size.width * 0.08, 28))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: 60)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Описание
                    VStack(alignment: .leading, spacing: 8) {
                        Label(L10n.descriptionLabel, systemImage: "text.alignleft")
                            .font(.headline)
                        Text(formula.localizedDescription)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Теория
                    if let theory = formula.localizedTheory, !theory.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Label(L10n.theoryLabel, systemImage: "book")
                                .font(.headline)
                            Text(theory)
                                .font(.body)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    
                    // Примеры задач
                    if let examples = formula.examples, !examples.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Label(L10n.examplesLabel, systemImage: "lightbulb")
                                .font(.headline)
                            
                            ForEach(Array(examples.enumerated()), id: \.offset) { index, example in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("\(L10n.problemLabel):")
                                        .font(.subheadline.weight(.semibold))
                                    Text(example.localizedProblem)
                                        .font(.body)
                                    
                                    Text("\(L10n.answerLabel):")
                                        .font(.subheadline.weight(.semibold))
                                        .padding(.top, 4)
                                    Text(example.localizedAnswer)
                                        .font(.body)
                                        .foregroundColor(.accentColor)
                                }
                                if index < examples.count - 1 {
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(16)
                    }
                    
                    // Переменные
                    VStack(alignment: .leading, spacing: 12) {
                        Label(L10n.variablesLabel, systemImage: "textformat.abc")
                            .font(.headline)
                        
                        ForEach(formula.variables) { variable in
                            HStack {
                                Text(variable.symbol)
                                    .font(.system(.body, design: .serif))
                                    .fontWeight(.semibold)
                                    .frame(width: 40, alignment: .leading)
                                VStack(alignment: .leading) {
                                    Text(variable.localizedName)
                                        .font(.body)
                                }
                                Spacer()
                                Text(variable.unit_si)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.accentColor.opacity(0.12))
                                    .cornerRadius(6)
                            }
                            if variable.id != formula.variables.last?.id {
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                    
                    // Применение
                    VStack(alignment: .leading, spacing: 8) {
                        Label(L10n.applicationArea, systemImage: "scope")
                            .font(.headline)
                        
                        HStack(spacing: 8) {
                            ForEach(formula.levels, id: \.self) { level in
                                Text(level == "school" ? L10n.school : L10n.university)
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(level == "school" ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                                    .foregroundColor(level == "school" ? .green : .blue)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(16)
                }
                .padding()
            }
            .navigationTitle(L10n.infoTitle)
            .navigationBarTitleDisplayMode(.inline)
            .oledBackground()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(L10n.done) { dismiss() }
                }
            }
        }
    }
}
