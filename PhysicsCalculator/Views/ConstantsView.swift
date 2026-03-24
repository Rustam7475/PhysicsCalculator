import SwiftUI

/// A category of physical constants
struct ConstantCategory: Identifiable {
    let id: String
    let nameKey: String
    let icon: String
    let constants: [PhysicalConstant]
}

/// A single physical constant
struct PhysicalConstant: Identifiable {
    let id: String
    let symbol: String
    let value: String
    let unit: String
    let name: () -> String
    let description: () -> String
}

struct ConstantsView: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var searchText = ""
    @State private var copiedId: String?
    
    private var categories: [ConstantCategory] {
        ConstantsData.categories
    }
    
    private var filteredCategories: [ConstantCategory] {
        if searchText.isEmpty { return categories }
        return categories.compactMap { cat in
            let filtered = cat.constants.filter {
                $0.name().localizedCaseInsensitiveContains(searchText) ||
                $0.symbol.localizedCaseInsensitiveContains(searchText) ||
                $0.description().localizedCaseInsensitiveContains(searchText)
            }
            return filtered.isEmpty ? nil : ConstantCategory(id: cat.id, nameKey: cat.nameKey, icon: cat.icon, constants: filtered)
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredCategories) { category in
                Section(header: Label(category.nameKey, systemImage: category.icon)) {
                    ForEach(category.constants) { constant in
                        constantRow(constant)
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: L10n.searchConstants)
        .navigationTitle(L10n.constantsTitle)
        .id(settings.currentLanguageCode)
        .oledBackground()
    }
    
    @ViewBuilder
    private func constantRow(_ c: PhysicalConstant) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(c.name())
                    .font(.subheadline.weight(.medium))
                Spacer()
                Button {
                    UIPasteboard.general.string = "\(c.symbol) = \(c.value) \(c.unit)"
                    copiedId = c.id
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if copiedId == c.id { copiedId = nil }
                    }
                } label: {
                    Image(systemName: copiedId == c.id ? "checkmark" : "doc.on.doc")
                        .font(.caption)
                        .foregroundColor(copiedId == c.id ? .green : .accentColor)
                }
                .buttonStyle(.borderless)
            }
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(c.symbol)
                    .font(.system(.body, design: .serif))
                    .italic()
                Text("=")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Text(c.value)
                    .font(.system(.footnote, design: .monospaced))
                Text(c.unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            if !c.description().isEmpty {
                Text(c.description())
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Constants Data

private enum ConstantsData {
    static var categories: [ConstantCategory] {
        [universal, electromagnetic, atomic, thermodynamic, astrophysical, mathematical]
    }
    
    static var universal: ConstantCategory {
        ConstantCategory(id: "universal", nameKey: L10n.catUniversal, icon: "globe", constants: [
            PhysicalConstant(id: "c", symbol: "c", value: "2.998 × 10⁸", unit: "m/s",
                name: { L10n.constSpeedOfLight }, description: { L10n.constSpeedOfLightDesc }),
            PhysicalConstant(id: "G", symbol: "G", value: "6.674 × 10⁻¹¹", unit: "m³/(kg·s²)",
                name: { L10n.constGravitational }, description: { L10n.constGravitationalDesc }),
            PhysicalConstant(id: "h", symbol: "h", value: "6.626 × 10⁻³⁴", unit: "J·s",
                name: { L10n.constPlanck }, description: { L10n.constPlanckDesc }),
            PhysicalConstant(id: "hbar", symbol: "ℏ", value: "1.055 × 10⁻³⁴", unit: "J·s",
                name: { L10n.constReducedPlanck }, description: { L10n.constReducedPlanckDesc }),
            PhysicalConstant(id: "Na", symbol: "Nₐ", value: "6.022 × 10²³", unit: "mol⁻¹",
                name: { L10n.constAvogadro }, description: { L10n.constAvogadroDesc }),
            PhysicalConstant(id: "R", symbol: "R", value: "8.314", unit: "J/(mol·K)",
                name: { L10n.constGasConst }, description: { L10n.constGasConstDesc }),
            PhysicalConstant(id: "sigma", symbol: "σ", value: "5.670 × 10⁻⁸", unit: "W/(m²·K⁴)",
                name: { L10n.constStefanBoltzmann }, description: { L10n.constStefanBoltzmannDesc }),
        ])
    }
    
    static var electromagnetic: ConstantCategory {
        ConstantCategory(id: "em", nameKey: L10n.catElectromagnetic, icon: "bolt", constants: [
            PhysicalConstant(id: "e", symbol: "e", value: "1.602 × 10⁻¹⁹", unit: "C",
                name: { L10n.constElementaryCharge }, description: { L10n.constElementaryChargeDesc }),
            PhysicalConstant(id: "k", symbol: "k", value: "8.988 × 10⁹", unit: "N·m²/C²",
                name: { L10n.constCoulomb }, description: { L10n.constCoulombDesc }),
            PhysicalConstant(id: "eps0", symbol: "ε₀", value: "8.854 × 10⁻¹²", unit: "F/m",
                name: { L10n.constPermittivity }, description: { L10n.constPermittivityDesc }),
            PhysicalConstant(id: "mu0", symbol: "μ₀", value: "1.257 × 10⁻⁶", unit: "H/m",
                name: { L10n.constPermeability }, description: { L10n.constPermeabilityDesc }),
            PhysicalConstant(id: "Phi0", symbol: "Φ₀", value: "2.068 × 10⁻¹⁵", unit: "Wb",
                name: { L10n.constFluxQuantum }, description: { L10n.constFluxQuantumDesc }),
        ])
    }
    
    static var atomic: ConstantCategory {
        ConstantCategory(id: "atomic", nameKey: L10n.catAtomic, icon: "atom", constants: [
            PhysicalConstant(id: "me", symbol: "mₑ", value: "9.109 × 10⁻³¹", unit: "kg",
                name: { L10n.constElectronMass }, description: { L10n.constElectronMassDesc }),
            PhysicalConstant(id: "mp", symbol: "mₚ", value: "1.673 × 10⁻²⁷", unit: "kg",
                name: { L10n.constProtonMass }, description: { L10n.constProtonMassDesc }),
            PhysicalConstant(id: "mn", symbol: "mₙ", value: "1.675 × 10⁻²⁷", unit: "kg",
                name: { L10n.constNeutronMass }, description: { L10n.constNeutronMassDesc }),
            PhysicalConstant(id: "amu", symbol: "u", value: "1.661 × 10⁻²⁷", unit: "kg",
                name: { L10n.constAMU }, description: { L10n.constAMUDesc }),
            PhysicalConstant(id: "a0", symbol: "a₀", value: "5.292 × 10⁻¹¹", unit: "m",
                name: { L10n.constBohrRadius }, description: { L10n.constBohrRadiusDesc }),
            PhysicalConstant(id: "Ry", symbol: "R∞", value: "1.097 × 10⁷", unit: "m⁻¹",
                name: { L10n.constRydberg }, description: { L10n.constRydbergDesc }),
        ])
    }
    
    static var thermodynamic: ConstantCategory {
        ConstantCategory(id: "thermo", nameKey: L10n.catThermodynamic, icon: "thermometer.medium", constants: [
            PhysicalConstant(id: "kB", symbol: "kB", value: "1.381 × 10⁻²³", unit: "J/K",
                name: { L10n.constBoltzmann }, description: { L10n.constBoltzmannDesc }),
            PhysicalConstant(id: "atm", symbol: "atm", value: "101 325", unit: "Pa",
                name: { L10n.constAtmosphere }, description: { L10n.constAtmosphereDesc }),
            PhysicalConstant(id: "bW", symbol: "b", value: "2.898 × 10⁻³", unit: "m·K",
                name: { L10n.constWien }, description: { L10n.constWienDesc }),
            PhysicalConstant(id: "T0", symbol: "T₀", value: "273.15", unit: "K",
                name: { L10n.constAbsoluteZero }, description: { L10n.constAbsoluteZeroDesc }),
        ])
    }
    
    static var astrophysical: ConstantCategory {
        ConstantCategory(id: "astro", nameKey: L10n.catAstrophysical, icon: "sparkles", constants: [
            PhysicalConstant(id: "g", symbol: "g", value: "9.807", unit: "m/s²",
                name: { L10n.constStandardGravity }, description: { L10n.constStandardGravityDesc }),
            PhysicalConstant(id: "Me", symbol: "M⊕", value: "5.972 × 10²⁴", unit: "kg",
                name: { L10n.constEarthMass }, description: { L10n.constEarthMassDesc }),
            PhysicalConstant(id: "Re", symbol: "R⊕", value: "6.371 × 10⁶", unit: "m",
                name: { L10n.constEarthRadius }, description: { L10n.constEarthRadiusDesc }),
            PhysicalConstant(id: "Ms", symbol: "M☉", value: "1.989 × 10³⁰", unit: "kg",
                name: { L10n.constSunMass }, description: { L10n.constSunMassDesc }),
            PhysicalConstant(id: "AU", symbol: "AU", value: "1.496 × 10¹¹", unit: "m",
                name: { L10n.constAU }, description: { L10n.constAUDesc }),
            PhysicalConstant(id: "ly", symbol: "ly", value: "9.461 × 10¹⁵", unit: "m",
                name: { L10n.constLightYear }, description: { L10n.constLightYearDesc }),
        ])
    }
    
    static var mathematical: ConstantCategory {
        ConstantCategory(id: "math", nameKey: L10n.catMathematical, icon: "function", constants: [
            PhysicalConstant(id: "pi", symbol: "π", value: "3.14159265359", unit: "",
                name: { L10n.constPi }, description: { L10n.constPiDesc }),
            PhysicalConstant(id: "euler", symbol: "e", value: "2.71828182846", unit: "",
                name: { L10n.constEuler }, description: { L10n.constEulerDesc }),
        ])
    }
}

#Preview {
    NavigationStack {
        ConstantsView()
            .environmentObject(AppSettings.shared)
    }
}
