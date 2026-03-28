import XCTest
@testable import PhysicsCalculator

// Auto-generated: tests for all 126 formulas, every calculation rule
// Each test verifies that the CalculationService correctly evaluates
// the formula rule with known input values.

final class FormulaCalculationTests: XCTestCase {

    private var sut: CalculationService!

    override func setUp() {
        super.setUp()
        sut = CalculationService()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Average Velocity (mech_school_velocity)

    func test_mech_school_velocity_v() throws {
        let result = try sut.calculate(rule: "s / t", variables: ["s": 2.0, "t": 5.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: mech_school_velocity solving for v")
    }

    func test_mech_school_velocity_s() throws {
        let result = try sut.calculate(rule: "v * t", variables: ["v": 10.0, "t": 5.0])
        XCTAssertEqual(result, 50.0, accuracy: 0.01, "Failed: mech_school_velocity solving for s")
    }

    func test_mech_school_velocity_t() throws {
        let result = try sut.calculate(rule: "s / v", variables: ["v": 10.0, "s": 2.0])
        XCTAssertEqual(result, 0.2, accuracy: 0.002, "Failed: mech_school_velocity solving for t")
    }

    // MARK: - Acceleration (mech_school_acceleration)

    func test_mech_school_acceleration_a() throws {
        let result = try sut.calculate(rule: "(v - u) / t", variables: ["v": 20.0, "u": 5.0, "t": 3.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: mech_school_acceleration solving for a")
    }

    func test_mech_school_acceleration_v() throws {
        let result = try sut.calculate(rule: "u + a * t", variables: ["a": 5.0, "u": 5.0, "t": 3.0])
        XCTAssertEqual(result, 20.0, accuracy: 0.01, "Failed: mech_school_acceleration solving for v")
    }

    func test_mech_school_acceleration_u() throws {
        let result = try sut.calculate(rule: "v - a * t", variables: ["a": 5.0, "v": 20.0, "t": 3.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: mech_school_acceleration solving for u")
    }

    func test_mech_school_acceleration_t() throws {
        let result = try sut.calculate(rule: "(v - u) / a", variables: ["a": 5.0, "v": 20.0, "u": 5.0])
        XCTAssertEqual(result, 3.0, accuracy: 0.01, "Failed: mech_school_acceleration solving for t")
    }

    // MARK: - Newton's Second Law (mech_school_newton_second)

    func test_mech_school_newton_second_F() throws {
        let result = try sut.calculate(rule: "m * a", variables: ["m": 2.0, "a": 5.0])
        XCTAssertEqual(result, 10.0, accuracy: 0.01, "Failed: mech_school_newton_second solving for F")
    }

    func test_mech_school_newton_second_m() throws {
        let result = try sut.calculate(rule: "F / a", variables: ["F": 5.0, "a": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_newton_second solving for m")
    }

    func test_mech_school_newton_second_a() throws {
        let result = try sut.calculate(rule: "F / m", variables: ["F": 5.0, "m": 2.0])
        XCTAssertEqual(result, 2.5, accuracy: 0.01, "Failed: mech_school_newton_second solving for a")
    }

    // MARK: - Momentum Conservation (2 bodies) (mech_uni_momentum_conservation)

    func test_mech_uni_momentum_conservation_v1prime() throws {
        let result = try sut.calculate(rule: "(m1 * v1 + m2 * v2 - m2 * v2prime) / m1", variables: ["m1": 3.0, "v1": 4.0, "m2": 2.0, "v2": 1.0, "v2prime": 4.0])
        XCTAssertEqual(result, 2.0, accuracy: 0.01, "Failed: mech_uni_momentum_conservation solving for v1prime")
    }

    func test_mech_uni_momentum_conservation_v2prime() throws {
        let result = try sut.calculate(rule: "(m1 * v1 + m2 * v2 - m1 * v1prime) / m2", variables: ["m1": 3.0, "v1": 4.0, "m2": 2.0, "v2": 1.0, "v1prime": 2.0])
        XCTAssertEqual(result, 4.0, accuracy: 0.01, "Failed: mech_uni_momentum_conservation solving for v2prime")
    }

    func test_mech_uni_momentum_conservation_m1() throws {
        let result = try sut.calculate(rule: "(m2 * (v2prime - v2)) / (v1 - v1prime)", variables: ["v1": 4.0, "m2": 2.0, "v2": 1.0, "v1prime": 2.0, "v2prime": 4.0])
        XCTAssertEqual(result, 3.0, accuracy: 0.01, "Failed: mech_uni_momentum_conservation solving for m1")
    }

    func test_mech_uni_momentum_conservation_m2() throws {
        let result = try sut.calculate(rule: "(m1 * (v1prime - v1)) / (v2 - v2prime)", variables: ["m1": 3.0, "v1": 4.0, "v2": 1.0, "v1prime": 2.0, "v2prime": 4.0])
        XCTAssertEqual(result, 2.0, accuracy: 0.01, "Failed: mech_uni_momentum_conservation solving for m2")
    }

    func test_mech_uni_momentum_conservation_v1() throws {
        let result = try sut.calculate(rule: "(m1 * v1prime + m2 * v2prime - m2 * v2) / m1", variables: ["m1": 3.0, "m2": 2.0, "v2": 1.0, "v1prime": 2.0, "v2prime": 4.0])
        XCTAssertEqual(result, 4.0, accuracy: 0.01, "Failed: mech_uni_momentum_conservation solving for v1")
    }

    func test_mech_uni_momentum_conservation_v2() throws {
        let result = try sut.calculate(rule: "(m1 * v1prime + m2 * v2prime - m1 * v1) / m2", variables: ["m1": 3.0, "v1": 4.0, "m2": 2.0, "v1prime": 2.0, "v2prime": 4.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_uni_momentum_conservation solving for v2")
    }

    // MARK: - Kinetic Energy (mech_school_kinetic_energy)

    func test_mech_school_kinetic_energy_Ek() throws {
        let result = try sut.calculate(rule: "0.5 * m * pow(v, 2)", variables: ["m": 2.0, "v": 10.0])
        XCTAssertEqual(result, 100.0, accuracy: 0.01, "Failed: mech_school_kinetic_energy solving for Ek")
    }

    func test_mech_school_kinetic_energy_m() throws {
        let result = try sut.calculate(rule: "(2 * Ek) / pow(v, 2)", variables: ["Ek": 5.0, "v": 10.0])
        XCTAssertEqual(result, 0.1, accuracy: 0.001, "Failed: mech_school_kinetic_energy solving for m")
    }

    func test_mech_school_kinetic_energy_v() throws {
        let result = try sut.calculate(rule: "sqrt((2 * Ek) / m)", variables: ["Ek": 5.0, "m": 2.0])
        XCTAssertEqual(result, 2.23606797749979, accuracy: 0.01, "Failed: mech_school_kinetic_energy solving for v")
    }

    // MARK: - Ideal Gas Law (ideal_gas_law)

    func test_ideal_gas_law_p() throws {
        let result = try sut.calculate(rule: "(nu * R * T) / V", variables: ["V": 5.0, "nu": 5.0, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 2494.2, accuracy: 0.01, "Failed: ideal_gas_law solving for p")
    }

    func test_ideal_gas_law_V() throws {
        let result = try sut.calculate(rule: "(nu * R * T) / p", variables: ["p": 101325.0, "nu": 5.0, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 0.12307920059215396, accuracy: 0.0012307920059215396, "Failed: ideal_gas_law solving for V")
    }

    func test_ideal_gas_law_nu() throws {
        let result = try sut.calculate(rule: "(p * V) / (R * T)", variables: ["p": 101325.0, "V": 5.0, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 203.12124127976907, accuracy: 0.01, "Failed: ideal_gas_law solving for nu")
    }

    func test_ideal_gas_law_R() throws {
        let result = try sut.calculate(rule: "(p * V) / (nu * T)", variables: ["p": 101325.0, "V": 5.0, "nu": 5.0, "T": 300.0])
        XCTAssertEqual(result, 337.75, accuracy: 0.01, "Failed: ideal_gas_law solving for R")
    }

    func test_ideal_gas_law_T() throws {
        let result = try sut.calculate(rule: "(p * V) / (nu * R)", variables: ["p": 101325.0, "V": 5.0, "nu": 5.0, "R": 8.314])
        XCTAssertEqual(result, 12187.274476786144, accuracy: 0.01, "Failed: ideal_gas_law solving for T")
    }

    // MARK: - Second Law of Thermodynamics (Entropy) (thermo_uni_second_law)

    func test_thermo_uni_second_law_DeltaS() throws {
        let result = try sut.calculate(rule: "Q / T", variables: ["Q": 5.0, "T": 300.0])
        XCTAssertEqual(result, 0.016666666666666666, accuracy: 0.00016666666666666666, "Failed: thermo_uni_second_law solving for DeltaS")
    }

    func test_thermo_uni_second_law_Q() throws {
        let result = try sut.calculate(rule: "DeltaS * T", variables: ["DeltaS": 5.0, "T": 300.0])
        XCTAssertEqual(result, 1500.0, accuracy: 0.01, "Failed: thermo_uni_second_law solving for Q")
    }

    func test_thermo_uni_second_law_T() throws {
        let result = try sut.calculate(rule: "Q / DeltaS", variables: ["DeltaS": 5.0, "Q": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: thermo_uni_second_law solving for T")
    }

    // MARK: - Ohm's Law (circuit section) (em_school_ohm_law)

    func test_em_school_ohm_law_I() throws {
        let result = try sut.calculate(rule: "U / R", variables: ["U": 5.0, "R": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_ohm_law solving for I")
    }

    func test_em_school_ohm_law_U() throws {
        let result = try sut.calculate(rule: "I * R", variables: ["I": 5.0, "R": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: em_school_ohm_law solving for U")
    }

    func test_em_school_ohm_law_R() throws {
        let result = try sut.calculate(rule: "U / I", variables: ["I": 5.0, "U": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_ohm_law solving for R")
    }

    // MARK: - Faraday's Law (Induced EMF) (em_uni_faraday_law)

    func test_em_uni_faraday_law_epsilon() throws {
        let result = try sut.calculate(rule: "dPhiB / dt", variables: ["dPhiB": 5.0, "dt": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_uni_faraday_law solving for epsilon")
    }

    func test_em_uni_faraday_law_dPhiB() throws {
        let result = try sut.calculate(rule: "epsilon * dt", variables: ["epsilon": 5.0, "dt": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: em_uni_faraday_law solving for dPhiB")
    }

    func test_em_uni_faraday_law_dt() throws {
        let result = try sut.calculate(rule: "dPhiB / epsilon", variables: ["epsilon": 5.0, "dPhiB": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_uni_faraday_law solving for dt")
    }

    // MARK: - Thin Lens Formula (optics_school_lens_formula)

    func test_optics_school_lens_formula_f() throws {
        let result = try sut.calculate(rule: "1 / (1/do + 1/di)", variables: ["do": 0.3, "di": 0.15])
        XCTAssertEqual(result, 0.1, accuracy: 0.001, "Failed: optics_school_lens_formula solving for f")
    }

    func test_optics_school_lens_formula_do() throws {
        let result = try sut.calculate(rule: "1 / (1/f - 1/di)", variables: ["f": 0.1, "di": 0.15])
        XCTAssertEqual(result, 0.30000000000000004, accuracy: 0.0030000000000000005, "Failed: optics_school_lens_formula solving for do")
    }

    func test_optics_school_lens_formula_di() throws {
        let result = try sut.calculate(rule: "1 / (1/f - 1/do)", variables: ["f": 0.1, "do": 0.3])
        XCTAssertEqual(result, 0.15000000000000002, accuracy: 0.0015000000000000002, "Failed: optics_school_lens_formula solving for di")
    }

    // MARK: - Malus's Law (optics_uni_malus_law)

    func test_optics_uni_malus_law_I() throws {
        let result = try sut.calculate(rule: "I0 * pow(cos(theta), 2)", variables: ["I0": 100.0, "theta": 0.8])
        XCTAssertEqual(result, 48.54002388493556, accuracy: 0.01, "Failed: optics_uni_malus_law solving for I")
    }

    func test_optics_uni_malus_law_I0() throws {
        let result = try sut.calculate(rule: "I / pow(cos(theta), 2)", variables: ["I": 48.54002388493556, "theta": 0.8])
        XCTAssertEqual(result, 100.0, accuracy: 0.01, "Failed: optics_uni_malus_law solving for I0")
    }

    func test_optics_uni_malus_law_theta() throws {
        let result = try sut.calculate(rule: "acos(sqrt(I / I0))", variables: ["I": 48.54002388493556, "I0": 100.0])
        XCTAssertEqual(result, 0.8, accuracy: 0.008, "Failed: optics_uni_malus_law solving for theta")
    }

    // MARK: - Isothermal Process (Boyle's Law) (thermo_school_isothermal_process)

    func test_thermo_school_isothermal_process_P1() throws {
        let result = try sut.calculate(rule: "(P2 * V2) / V1", variables: ["V1": 5.0, "P2": 101325.0, "V2": 5.0])
        XCTAssertEqual(result, 101325.0, accuracy: 0.01, "Failed: thermo_school_isothermal_process solving for P1")
    }

    func test_thermo_school_isothermal_process_V1() throws {
        let result = try sut.calculate(rule: "(P2 * V2) / P1", variables: ["P1": 101325.0, "P2": 101325.0, "V2": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: thermo_school_isothermal_process solving for V1")
    }

    func test_thermo_school_isothermal_process_P2() throws {
        let result = try sut.calculate(rule: "(P1 * V1) / V2", variables: ["P1": 101325.0, "V1": 5.0, "V2": 5.0])
        XCTAssertEqual(result, 101325.0, accuracy: 0.01, "Failed: thermo_school_isothermal_process solving for P2")
    }

    func test_thermo_school_isothermal_process_V2() throws {
        let result = try sut.calculate(rule: "(P1 * V1) / P2", variables: ["P1": 101325.0, "V1": 5.0, "P2": 101325.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: thermo_school_isothermal_process solving for V2")
    }

    // MARK: - Archimedes' Principle (archimedes_force)

    func test_archimedes_force_F_A() throws {
        let result = try sut.calculate(rule: "ρ * g * V", variables: ["ρ": 1000.0, "g": 9.8, "V": 5.0])
        XCTAssertEqual(result, 49000.0, accuracy: 0.01, "Failed: archimedes_force solving for F_A")
    }

    func test_archimedes_force_ρ() throws {
        let result = try sut.calculate(rule: "F_A / (g * V)", variables: ["F_A": 5.0, "g": 9.8, "V": 5.0])
        XCTAssertEqual(result, 0.10204081632653061, accuracy: 0.0010204081632653062, "Failed: archimedes_force solving for ρ")
    }

    func test_archimedes_force_g() throws {
        let result = try sut.calculate(rule: "F_A / (ρ * V)", variables: ["F_A": 5.0, "ρ": 1000.0, "V": 5.0])
        XCTAssertEqual(result, 0.001, accuracy: 1e-05, "Failed: archimedes_force solving for g")
    }

    func test_archimedes_force_V() throws {
        let result = try sut.calculate(rule: "F_A / (ρ * g)", variables: ["F_A": 5.0, "ρ": 1000.0, "g": 9.8])
        XCTAssertEqual(result, 0.0005102040816326531, accuracy: 5.1020408163265315e-06, "Failed: archimedes_force solving for V")
    }

    // MARK: - Hydrostatic Pressure (hydrostatic_pressure)

    func test_hydrostatic_pressure_p() throws {
        let result = try sut.calculate(rule: "ρ * g * h", variables: ["ρ": 1000.0, "g": 9.8, "h": 5.0])
        XCTAssertEqual(result, 49000.0, accuracy: 0.01, "Failed: hydrostatic_pressure solving for p")
    }

    func test_hydrostatic_pressure_ρ() throws {
        let result = try sut.calculate(rule: "p / (g * h)", variables: ["p": 101325.0, "g": 9.8, "h": 5.0])
        XCTAssertEqual(result, 2067.8571428571427, accuracy: 0.01, "Failed: hydrostatic_pressure solving for ρ")
    }

    func test_hydrostatic_pressure_g() throws {
        let result = try sut.calculate(rule: "p / (ρ * h)", variables: ["p": 101325.0, "ρ": 1000.0, "h": 5.0])
        XCTAssertEqual(result, 20.265, accuracy: 0.01, "Failed: hydrostatic_pressure solving for g")
    }

    func test_hydrostatic_pressure_h() throws {
        let result = try sut.calculate(rule: "p / (ρ * g)", variables: ["p": 101325.0, "ρ": 1000.0, "g": 9.8])
        XCTAssertEqual(result, 10.339285714285714, accuracy: 0.01, "Failed: hydrostatic_pressure solving for h")
    }

    // MARK: - Total Pressure at Bottom (total_pressure)

    func test_total_pressure_p() throws {
        let result = try sut.calculate(rule: "p_0 + ρ * g * h", variables: ["p_0": 101325.0, "ρ": 1000.0, "g": 9.8, "h": 1.02])
        XCTAssertEqual(result, 111321.0, accuracy: 0.01, "Failed: total_pressure solving for p")
    }

    func test_total_pressure_p_0() throws {
        let result = try sut.calculate(rule: "p - ρ * g * h", variables: ["p": 111325.0, "ρ": 1000.0, "g": 9.8, "h": 1.02])
        XCTAssertEqual(result, 101329.0, accuracy: 0.01, "Failed: total_pressure solving for p_0")
    }

    func test_total_pressure_ρ() throws {
        let result = try sut.calculate(rule: "(p - p_0) / (g * h)", variables: ["p": 111325.0, "p_0": 101325.0, "g": 9.8, "h": 1.02])
        XCTAssertEqual(result, 1000.4001600640256, accuracy: 0.01, "Failed: total_pressure solving for ρ")
    }

    func test_total_pressure_g() throws {
        let result = try sut.calculate(rule: "(p - p_0) / (ρ * h)", variables: ["p": 111325.0, "p_0": 101325.0, "ρ": 1000.0, "h": 1.02])
        XCTAssertEqual(result, 9.803921568627452, accuracy: 0.01, "Failed: total_pressure solving for g")
    }

    func test_total_pressure_h() throws {
        let result = try sut.calculate(rule: "(p - p_0) / (ρ * g)", variables: ["p": 111325.0, "p_0": 101325.0, "ρ": 1000.0, "g": 9.8])
        XCTAssertEqual(result, 1.0204081632653061, accuracy: 0.01, "Failed: total_pressure solving for h")
    }

    // MARK: - Communicating Vessels (communicating_vessels)

    func test_communicating_vessels_h_1() throws {
        let result = try sut.calculate(rule: "(ρ_2 * h_2) / ρ_1", variables: ["h_2": 5.0, "ρ_1": 1000.0, "ρ_2": 800.0])
        XCTAssertEqual(result, 4.0, accuracy: 0.01, "Failed: communicating_vessels solving for h_1")
    }

    func test_communicating_vessels_h_2() throws {
        let result = try sut.calculate(rule: "(ρ_1 * h_1) / ρ_2", variables: ["h_1": 5.0, "ρ_1": 1000.0, "ρ_2": 800.0])
        XCTAssertEqual(result, 6.25, accuracy: 0.01, "Failed: communicating_vessels solving for h_2")
    }

    func test_communicating_vessels_ρ_1() throws {
        let result = try sut.calculate(rule: "(ρ_2 * h_2) / h_1", variables: ["h_1": 5.0, "h_2": 5.0, "ρ_2": 800.0])
        XCTAssertEqual(result, 800.0, accuracy: 0.01, "Failed: communicating_vessels solving for ρ_1")
    }

    func test_communicating_vessels_ρ_2() throws {
        let result = try sut.calculate(rule: "(ρ_1 * h_1) / h_2", variables: ["h_1": 5.0, "h_2": 5.0, "ρ_1": 1000.0])
        XCTAssertEqual(result, 1000.0, accuracy: 0.01, "Failed: communicating_vessels solving for ρ_2")
    }

    // MARK: - Displacement with Constant Acceleration (mech_school_displacement_acc)

    func test_mech_school_displacement_acc_s() throws {
        let result = try sut.calculate(rule: "v0 * t + 0.5 * a * t * t", variables: ["v0": 10.0, "a": 5.0, "t": 5.0])
        XCTAssertEqual(result, 112.5, accuracy: 0.01, "Failed: mech_school_displacement_acc solving for s")
    }

    func test_mech_school_displacement_acc_v0() throws {
        let result = try sut.calculate(rule: "(s - 0.5 * a * t * t) / t", variables: ["s": 5.0, "a": 5.0, "t": 5.0])
        XCTAssertEqual(result, -11.5, accuracy: 0.01, "Failed: mech_school_displacement_acc solving for v0")
    }

    func test_mech_school_displacement_acc_a() throws {
        let result = try sut.calculate(rule: "(2 * (s - v0 * t)) / (t * t)", variables: ["s": 5.0, "v0": 10.0, "t": 5.0])
        XCTAssertEqual(result, -3.6, accuracy: 0.01, "Failed: mech_school_displacement_acc solving for a")
    }

    func test_mech_school_displacement_acc_t() throws {
        let result = try sut.calculate(rule: "(-v0 + sqrt(v0 * v0 + 2 * a * s)) / a", variables: ["s": 5.0, "v0": 10.0, "a": 5.0])
        XCTAssertEqual(result, 0.44948974278317805, accuracy: 0.004494897427831781, "Failed: mech_school_displacement_acc solving for t")
    }

    // MARK: - Velocity-Displacement Relation (mech_school_velocity_displacement)

    func test_mech_school_velocity_displacement_v() throws {
        let result = try sut.calculate(rule: "sqrt(v0 * v0 + 2 * a * s)", variables: ["v0": 5.0, "a": 2.0, "s": 10.0])
        XCTAssertEqual(result, 8.06225774829855, accuracy: 0.01, "Failed: mech_school_velocity_displacement solving for v")
    }

    func test_mech_school_velocity_displacement_v0() throws {
        let result = try sut.calculate(rule: "sqrt(v * v - 2 * a * s)", variables: ["v": 20.0, "a": 2.0, "s": 10.0])
        XCTAssertEqual(result, 18.973665961010276, accuracy: 0.01, "Failed: mech_school_velocity_displacement solving for v0")
    }

    func test_mech_school_velocity_displacement_a() throws {
        let result = try sut.calculate(rule: "(v * v - v0 * v0) / (2 * s)", variables: ["v": 20.0, "v0": 5.0, "s": 10.0])
        XCTAssertEqual(result, 18.75, accuracy: 0.01, "Failed: mech_school_velocity_displacement solving for a")
    }

    func test_mech_school_velocity_displacement_s() throws {
        let result = try sut.calculate(rule: "(v * v - v0 * v0) / (2 * a)", variables: ["v": 20.0, "v0": 5.0, "a": 2.0])
        XCTAssertEqual(result, 93.75, accuracy: 0.01, "Failed: mech_school_velocity_displacement solving for s")
    }

    // MARK: - Free Fall (mech_school_free_fall)

    func test_mech_school_free_fall_h() throws {
        let result = try sut.calculate(rule: "0.5 * g * t * t", variables: ["g": 9.8, "t": 5.0])
        XCTAssertEqual(result, 122.5, accuracy: 0.01, "Failed: mech_school_free_fall solving for h")
    }

    func test_mech_school_free_fall_g() throws {
        let result = try sut.calculate(rule: "(2 * h) / (t * t)", variables: ["h": 5.0, "t": 5.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: mech_school_free_fall solving for g")
    }

    func test_mech_school_free_fall_t() throws {
        let result = try sut.calculate(rule: "sqrt((2 * h) / g)", variables: ["h": 5.0, "g": 9.8])
        XCTAssertEqual(result, 1.0101525445522108, accuracy: 0.01, "Failed: mech_school_free_fall solving for t")
    }

    // MARK: - Centripetal Acceleration (mech_school_centripetal_acc)

    func test_mech_school_centripetal_acc_a() throws {
        let result = try sut.calculate(rule: "(v * v) / r", variables: ["v": 10.0, "r": 5.0])
        XCTAssertEqual(result, 20.0, accuracy: 0.01, "Failed: mech_school_centripetal_acc solving for a")
    }

    func test_mech_school_centripetal_acc_v() throws {
        let result = try sut.calculate(rule: "sqrt(a * r)", variables: ["a": 5.0, "r": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: mech_school_centripetal_acc solving for v")
    }

    func test_mech_school_centripetal_acc_r() throws {
        let result = try sut.calculate(rule: "(v * v) / a", variables: ["a": 5.0, "v": 10.0])
        XCTAssertEqual(result, 20.0, accuracy: 0.01, "Failed: mech_school_centripetal_acc solving for r")
    }

    // MARK: - Weight (mech_school_weight)

    func test_mech_school_weight_P() throws {
        let result = try sut.calculate(rule: "m * g", variables: ["m": 2.0, "g": 9.8])
        XCTAssertEqual(result, 19.6, accuracy: 0.01, "Failed: mech_school_weight solving for P")
    }

    func test_mech_school_weight_m() throws {
        let result = try sut.calculate(rule: "P / g", variables: ["P": 5.0, "g": 9.8])
        XCTAssertEqual(result, 0.5102040816326531, accuracy: 0.005102040816326531, "Failed: mech_school_weight solving for m")
    }

    func test_mech_school_weight_g() throws {
        let result = try sut.calculate(rule: "P / m", variables: ["P": 5.0, "m": 2.0])
        XCTAssertEqual(result, 2.5, accuracy: 0.01, "Failed: mech_school_weight solving for g")
    }

    // MARK: - Sliding Friction Force (mech_school_friction)

    func test_mech_school_friction_F() throws {
        let result = try sut.calculate(rule: "mu * N", variables: ["mu": 5.0, "N": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: mech_school_friction solving for F")
    }

    func test_mech_school_friction_mu() throws {
        let result = try sut.calculate(rule: "F / N", variables: ["F": 5.0, "N": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_friction solving for mu")
    }

    func test_mech_school_friction_N() throws {
        let result = try sut.calculate(rule: "F / mu", variables: ["F": 5.0, "mu": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_friction solving for N")
    }

    // MARK: - Hooke's Law (mech_school_hooke)

    func test_mech_school_hooke_F() throws {
        let result = try sut.calculate(rule: "k * x", variables: ["k": 5.0, "x": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: mech_school_hooke solving for F")
    }

    func test_mech_school_hooke_k() throws {
        let result = try sut.calculate(rule: "F / x", variables: ["F": 5.0, "x": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_hooke solving for k")
    }

    func test_mech_school_hooke_x() throws {
        let result = try sut.calculate(rule: "F / k", variables: ["F": 5.0, "k": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_hooke solving for x")
    }

    // MARK: - Momentum (mech_school_momentum)

    func test_mech_school_momentum_p() throws {
        let result = try sut.calculate(rule: "m * v", variables: ["m": 2.0, "v": 10.0])
        XCTAssertEqual(result, 20.0, accuracy: 0.01, "Failed: mech_school_momentum solving for p")
    }

    func test_mech_school_momentum_m() throws {
        let result = try sut.calculate(rule: "p / v", variables: ["p": 5.0, "v": 10.0])
        XCTAssertEqual(result, 0.5, accuracy: 0.005, "Failed: mech_school_momentum solving for m")
    }

    func test_mech_school_momentum_v() throws {
        let result = try sut.calculate(rule: "p / m", variables: ["p": 5.0, "m": 2.0])
        XCTAssertEqual(result, 2.5, accuracy: 0.01, "Failed: mech_school_momentum solving for v")
    }

    // MARK: - Potential Energy (mech_school_potential_energy)

    func test_mech_school_potential_energy_Ep() throws {
        let result = try sut.calculate(rule: "m * g * h", variables: ["m": 2.0, "g": 9.8, "h": 5.0])
        XCTAssertEqual(result, 98.0, accuracy: 0.01, "Failed: mech_school_potential_energy solving for Ep")
    }

    func test_mech_school_potential_energy_m() throws {
        let result = try sut.calculate(rule: "Ep / (g * h)", variables: ["Ep": 5.0, "g": 9.8, "h": 5.0])
        XCTAssertEqual(result, 0.10204081632653061, accuracy: 0.0010204081632653062, "Failed: mech_school_potential_energy solving for m")
    }

    func test_mech_school_potential_energy_g() throws {
        let result = try sut.calculate(rule: "Ep / (m * h)", variables: ["Ep": 5.0, "m": 2.0, "h": 5.0])
        XCTAssertEqual(result, 0.5, accuracy: 0.005, "Failed: mech_school_potential_energy solving for g")
    }

    func test_mech_school_potential_energy_h() throws {
        let result = try sut.calculate(rule: "Ep / (m * g)", variables: ["Ep": 5.0, "m": 2.0, "g": 9.8])
        XCTAssertEqual(result, 0.25510204081632654, accuracy: 0.0025510204081632655, "Failed: mech_school_potential_energy solving for h")
    }

    // MARK: - Mechanical Work (mech_school_work)

    func test_mech_school_work_A() throws {
        let result = try sut.calculate(rule: "F * s * cos(alpha)", variables: ["F": 5.0, "s": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 21.939564047259317, accuracy: 0.01, "Failed: mech_school_work solving for A")
    }

    func test_mech_school_work_F() throws {
        let result = try sut.calculate(rule: "A / (s * cos(alpha))", variables: ["A": 5.0, "s": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 1.139493927324549, accuracy: 0.01, "Failed: mech_school_work solving for F")
    }

    func test_mech_school_work_s() throws {
        let result = try sut.calculate(rule: "A / (F * cos(alpha))", variables: ["A": 5.0, "F": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 1.139493927324549, accuracy: 0.01, "Failed: mech_school_work solving for s")
    }

    func test_mech_school_work_alpha() throws {
        let result = try sut.calculate(rule: "acos(A / (F * s))", variables: ["A": 5.0, "F": 5.0, "s": 5.0])
        XCTAssertEqual(result, 1.3694384060045657, accuracy: 0.01, "Failed: mech_school_work solving for alpha")
    }

    // MARK: - Power (mech_school_power)

    func test_mech_school_power_N() throws {
        let result = try sut.calculate(rule: "A / t", variables: ["A": 5.0, "t": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_power solving for N")
    }

    func test_mech_school_power_A() throws {
        let result = try sut.calculate(rule: "N * t", variables: ["N": 5.0, "t": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: mech_school_power solving for A")
    }

    func test_mech_school_power_t() throws {
        let result = try sut.calculate(rule: "A / N", variables: ["N": 5.0, "A": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_school_power solving for t")
    }

    // MARK: - Elastic Potential Energy (mech_school_elastic_energy)

    func test_mech_school_elastic_energy_Eup() throws {
        let result = try sut.calculate(rule: "0.5 * k * x * x", variables: ["k": 5.0, "x": 5.0])
        XCTAssertEqual(result, 62.5, accuracy: 0.01, "Failed: mech_school_elastic_energy solving for Eup")
    }

    func test_mech_school_elastic_energy_k() throws {
        let result = try sut.calculate(rule: "(2 * Eup) / (x * x)", variables: ["Eup": 5.0, "x": 5.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: mech_school_elastic_energy solving for k")
    }

    func test_mech_school_elastic_energy_x() throws {
        let result = try sut.calculate(rule: "sqrt((2 * Eup) / k)", variables: ["Eup": 5.0, "k": 5.0])
        XCTAssertEqual(result, 1.4142135623730951, accuracy: 0.01, "Failed: mech_school_elastic_energy solving for x")
    }

    // MARK: - Law of Universal Gravitation (mech_school_gravity_law)

    func test_mech_school_gravity_law_F() throws {
        let result = try sut.calculate(rule: "G * m1 * m2 / (r * r)", variables: ["G": 6.674e-11, "m1": 5.0, "m2": 5.0, "r": 2.0])
        XCTAssertEqual(result, 4.17125e-10, accuracy: 4.1712500000000004e-12, "Failed: mech_school_gravity_law solving for F")
    }

    func test_mech_school_gravity_law_G() throws {
        let result = try sut.calculate(rule: "F * r * r / (m1 * m2)", variables: ["F": 5.0, "m1": 5.0, "m2": 5.0, "r": 2.0])
        XCTAssertEqual(result, 0.8, accuracy: 0.008, "Failed: mech_school_gravity_law solving for G")
    }

    func test_mech_school_gravity_law_m1() throws {
        let result = try sut.calculate(rule: "F * r * r / (G * m2)", variables: ["F": 5.0, "G": 6.674e-11, "m2": 5.0, "r": 2.0])
        XCTAssertEqual(result, 59934072520.22775, accuracy: 59934.07252022775, "Failed: mech_school_gravity_law solving for m1")
    }

    func test_mech_school_gravity_law_m2() throws {
        let result = try sut.calculate(rule: "F * r * r / (G * m1)", variables: ["F": 5.0, "G": 6.674e-11, "m1": 5.0, "r": 2.0])
        XCTAssertEqual(result, 59934072520.22775, accuracy: 59934.07252022775, "Failed: mech_school_gravity_law solving for m2")
    }

    func test_mech_school_gravity_law_r() throws {
        let result = try sut.calculate(rule: "sqrt(G * m1 * m2 / F)", variables: ["F": 5.0, "G": 6.674e-11, "m1": 5.0, "m2": 5.0])
        XCTAssertEqual(result, 1.826745740380965e-05, accuracy: 1.826745740380965e-07, "Failed: mech_school_gravity_law solving for r")
    }

    // MARK: - First Cosmic Velocity (mech_school_orbital_velocity)

    func test_mech_school_orbital_velocity_v1() throws {
        let result = try sut.calculate(rule: "sqrt(g * R)", variables: ["g": 9.8, "R": 5.0])
        XCTAssertEqual(result, 7.0, accuracy: 0.01, "Failed: mech_school_orbital_velocity solving for v1")
    }

    func test_mech_school_orbital_velocity_g() throws {
        let result = try sut.calculate(rule: "(v1 * v1) / R", variables: ["v1": 10.0, "R": 5.0])
        XCTAssertEqual(result, 20.0, accuracy: 0.01, "Failed: mech_school_orbital_velocity solving for g")
    }

    func test_mech_school_orbital_velocity_R() throws {
        let result = try sut.calculate(rule: "(v1 * v1) / g", variables: ["v1": 10.0, "g": 9.8])
        XCTAssertEqual(result, 10.204081632653061, accuracy: 0.01, "Failed: mech_school_orbital_velocity solving for R")
    }

    // MARK: - Gravitational Acceleration (mech_school_g_formula)

    func test_mech_school_g_formula_g() throws {
        let result = try sut.calculate(rule: "G * M / (R * R)", variables: ["G": 6.674e-11, "M": 5.0, "R": 5.0])
        XCTAssertEqual(result, 1.3348e-11, accuracy: 1.3348e-13, "Failed: mech_school_g_formula solving for g")
    }

    func test_mech_school_g_formula_G() throws {
        let result = try sut.calculate(rule: "g * R * R / M", variables: ["g": 9.8, "M": 5.0, "R": 5.0])
        XCTAssertEqual(result, 49.0, accuracy: 0.01, "Failed: mech_school_g_formula solving for G")
    }

    func test_mech_school_g_formula_M() throws {
        let result = try sut.calculate(rule: "g * R * R / G", variables: ["g": 9.8, "G": 6.674e-11, "R": 5.0])
        XCTAssertEqual(result, 3670961941863.95, accuracy: 3670961.94186395, "Failed: mech_school_g_formula solving for M")
    }

    func test_mech_school_g_formula_R() throws {
        let result = try sut.calculate(rule: "sqrt(G * M / g)", variables: ["g": 9.8, "G": 6.674e-11, "M": 5.0])
        XCTAssertEqual(result, 5.835325218714314e-06, accuracy: 5.835325218714314e-08, "Failed: mech_school_g_formula solving for R")
    }

    // MARK: - Torque (mech_uni_torque)

    func test_mech_uni_torque_M() throws {
        let result = try sut.calculate(rule: "F * r * sin(alpha)", variables: ["F": 5.0, "r": 2.0, "alpha": 0.5])
        XCTAssertEqual(result, 4.79425538604203, accuracy: 0.01, "Failed: mech_uni_torque solving for M")
    }

    func test_mech_uni_torque_F() throws {
        let result = try sut.calculate(rule: "M / (r * sin(alpha))", variables: ["M": 5.0, "r": 2.0, "alpha": 0.5])
        XCTAssertEqual(result, 5.21457410733372, accuracy: 0.01, "Failed: mech_uni_torque solving for F")
    }

    func test_mech_uni_torque_r() throws {
        let result = try sut.calculate(rule: "M / (F * sin(alpha))", variables: ["M": 5.0, "F": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 2.085829642933488, accuracy: 0.01, "Failed: mech_uni_torque solving for r")
    }

    func test_mech_uni_torque_alpha() throws {
        let result = try sut.calculate(rule: "asin(M / (F * r))", variables: ["M": 5.0, "F": 5.0, "r": 2.0])
        XCTAssertEqual(result, 0.5235987755982988, accuracy: 0.005235987755982988, "Failed: mech_uni_torque solving for alpha")
    }

    // MARK: - Angular Velocity (mech_uni_angular_velocity)

    func test_mech_uni_angular_velocity_omega() throws {
        let result = try sut.calculate(rule: "dphi / dt", variables: ["dphi": 0.5, "dt": 5.0])
        XCTAssertEqual(result, 0.1, accuracy: 0.001, "Failed: mech_uni_angular_velocity solving for omega")
    }

    func test_mech_uni_angular_velocity_dphi() throws {
        let result = try sut.calculate(rule: "omega * dt", variables: ["omega": 10.0, "dt": 5.0])
        XCTAssertEqual(result, 50.0, accuracy: 0.01, "Failed: mech_uni_angular_velocity solving for dphi")
    }

    func test_mech_uni_angular_velocity_dt() throws {
        let result = try sut.calculate(rule: "dphi / omega", variables: ["omega": 10.0, "dphi": 0.5])
        XCTAssertEqual(result, 0.05, accuracy: 0.0005, "Failed: mech_uni_angular_velocity solving for dt")
    }

    // MARK: - Linear and Angular Velocity Relation (mech_uni_linear_angular)

    func test_mech_uni_linear_angular_v() throws {
        let result = try sut.calculate(rule: "omega * r", variables: ["omega": 10.0, "r": 5.0])
        XCTAssertEqual(result, 50.0, accuracy: 0.01, "Failed: mech_uni_linear_angular solving for v")
    }

    func test_mech_uni_linear_angular_omega() throws {
        let result = try sut.calculate(rule: "v / r", variables: ["v": 10.0, "r": 5.0])
        XCTAssertEqual(result, 2.0, accuracy: 0.01, "Failed: mech_uni_linear_angular solving for omega")
    }

    func test_mech_uni_linear_angular_r() throws {
        let result = try sut.calculate(rule: "v / omega", variables: ["v": 10.0, "omega": 10.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: mech_uni_linear_angular solving for r")
    }

    // MARK: - Isobaric Process (Gay-Lussac's Law) (thermo_school_isobaric)

    func test_thermo_school_isobaric_V1() throws {
        let result = try sut.calculate(rule: "(V2 * T1) / T2", variables: ["T1": 300.0, "V2": 5.0, "T2": 300.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: thermo_school_isobaric solving for V1")
    }

    func test_thermo_school_isobaric_T1() throws {
        let result = try sut.calculate(rule: "(V1 * T2) / V2", variables: ["V1": 5.0, "V2": 5.0, "T2": 300.0])
        XCTAssertEqual(result, 300.0, accuracy: 0.01, "Failed: thermo_school_isobaric solving for T1")
    }

    func test_thermo_school_isobaric_V2() throws {
        let result = try sut.calculate(rule: "(V1 * T2) / T1", variables: ["V1": 5.0, "T1": 300.0, "T2": 300.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: thermo_school_isobaric solving for V2")
    }

    func test_thermo_school_isobaric_T2() throws {
        let result = try sut.calculate(rule: "(V2 * T1) / V1", variables: ["V1": 5.0, "T1": 300.0, "V2": 5.0])
        XCTAssertEqual(result, 300.0, accuracy: 0.01, "Failed: thermo_school_isobaric solving for T2")
    }

    // MARK: - Isochoric Process (Charles's Law) (thermo_school_isochoric)

    func test_thermo_school_isochoric_P1() throws {
        let result = try sut.calculate(rule: "(P2 * T1) / T2", variables: ["T1": 300.0, "P2": 101325.0, "T2": 300.0])
        XCTAssertEqual(result, 101325.0, accuracy: 0.01, "Failed: thermo_school_isochoric solving for P1")
    }

    func test_thermo_school_isochoric_T1() throws {
        let result = try sut.calculate(rule: "(P1 * T2) / P2", variables: ["P1": 101325.0, "P2": 101325.0, "T2": 300.0])
        XCTAssertEqual(result, 300.0, accuracy: 0.01, "Failed: thermo_school_isochoric solving for T1")
    }

    func test_thermo_school_isochoric_P2() throws {
        let result = try sut.calculate(rule: "(P1 * T2) / T1", variables: ["P1": 101325.0, "T1": 300.0, "T2": 300.0])
        XCTAssertEqual(result, 101325.0, accuracy: 0.01, "Failed: thermo_school_isochoric solving for P2")
    }

    func test_thermo_school_isochoric_T2() throws {
        let result = try sut.calculate(rule: "(P2 * T1) / P1", variables: ["P1": 101325.0, "T1": 300.0, "P2": 101325.0])
        XCTAssertEqual(result, 300.0, accuracy: 0.01, "Failed: thermo_school_isochoric solving for T2")
    }

    // MARK: - First Law of Thermodynamics (thermo_school_first_law)

    func test_thermo_school_first_law_Q() throws {
        let result = try sut.calculate(rule: "DeltaU + A", variables: ["DeltaU": 300.0, "A": 200.0])
        XCTAssertEqual(result, 500.0, accuracy: 0.01, "Failed: thermo_school_first_law solving for Q")
    }

    func test_thermo_school_first_law_DeltaU() throws {
        let result = try sut.calculate(rule: "Q - A", variables: ["Q": 500.0, "A": 200.0])
        XCTAssertEqual(result, 300.0, accuracy: 0.01, "Failed: thermo_school_first_law solving for DeltaU")
    }

    func test_thermo_school_first_law_A() throws {
        let result = try sut.calculate(rule: "Q - DeltaU", variables: ["Q": 500.0, "DeltaU": 300.0])
        XCTAssertEqual(result, 200.0, accuracy: 0.01, "Failed: thermo_school_first_law solving for A")
    }

    // MARK: - Heat Engine Efficiency (thermo_school_efficiency)

    func test_thermo_school_efficiency_eta() throws {
        let result = try sut.calculate(rule: "(Q1 - Q2) / Q1", variables: ["Q1": 1000.0, "Q2": 600.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: thermo_school_efficiency solving for eta")
    }

    func test_thermo_school_efficiency_Q1() throws {
        let result = try sut.calculate(rule: "Q2 / (1 - eta)", variables: ["eta": 0.4, "Q2": 600.0])
        XCTAssertEqual(result, 1000.0, accuracy: 0.01, "Failed: thermo_school_efficiency solving for Q1")
    }

    func test_thermo_school_efficiency_Q2() throws {
        let result = try sut.calculate(rule: "Q1 * (1 - eta)", variables: ["eta": 0.4, "Q1": 1000.0])
        XCTAssertEqual(result, 600.0, accuracy: 0.01, "Failed: thermo_school_efficiency solving for Q2")
    }

    // MARK: - Heat for Temperature Change (thermo_school_heat_capacity)

    func test_thermo_school_heat_capacity_Q() throws {
        let result = try sut.calculate(rule: "c * m * DeltaT", variables: ["c": 5.0, "m": 2.0, "DeltaT": 300.0])
        XCTAssertEqual(result, 3000.0, accuracy: 0.01, "Failed: thermo_school_heat_capacity solving for Q")
    }

    func test_thermo_school_heat_capacity_c() throws {
        let result = try sut.calculate(rule: "Q / (m * DeltaT)", variables: ["Q": 5.0, "m": 2.0, "DeltaT": 300.0])
        XCTAssertEqual(result, 0.008333333333333333, accuracy: 8.333333333333333e-05, "Failed: thermo_school_heat_capacity solving for c")
    }

    func test_thermo_school_heat_capacity_m() throws {
        let result = try sut.calculate(rule: "Q / (c * DeltaT)", variables: ["Q": 5.0, "c": 5.0, "DeltaT": 300.0])
        XCTAssertEqual(result, 0.0033333333333333335, accuracy: 3.3333333333333335e-05, "Failed: thermo_school_heat_capacity solving for m")
    }

    func test_thermo_school_heat_capacity_DeltaT() throws {
        let result = try sut.calculate(rule: "Q / (c * m)", variables: ["Q": 5.0, "c": 5.0, "m": 2.0])
        XCTAssertEqual(result, 0.5, accuracy: 0.005, "Failed: thermo_school_heat_capacity solving for DeltaT")
    }

    // MARK: - Heat of Combustion (thermo_school_combustion)

    func test_thermo_school_combustion_Q() throws {
        let result = try sut.calculate(rule: "q * m", variables: ["q": 5.0, "m": 2.0])
        XCTAssertEqual(result, 10.0, accuracy: 0.01, "Failed: thermo_school_combustion solving for Q")
    }

    func test_thermo_school_combustion_q() throws {
        let result = try sut.calculate(rule: "Q / m", variables: ["Q": 5.0, "m": 2.0])
        XCTAssertEqual(result, 2.5, accuracy: 0.01, "Failed: thermo_school_combustion solving for q")
    }

    func test_thermo_school_combustion_m() throws {
        let result = try sut.calculate(rule: "Q / q", variables: ["Q": 5.0, "q": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: thermo_school_combustion solving for m")
    }

    // MARK: - Heat of Fusion (thermo_school_melting)

    func test_thermo_school_melting_Q() throws {
        let result = try sut.calculate(rule: "lambda * m", variables: ["lambda": 334000.0, "m": 2.0])
        XCTAssertEqual(result, 668000.0, accuracy: 0.01, "Failed: thermo_school_melting solving for Q")
    }

    func test_thermo_school_melting_lambda() throws {
        let result = try sut.calculate(rule: "Q / m", variables: ["Q": 668000.0, "m": 2.0])
        XCTAssertEqual(result, 334000.0, accuracy: 0.01, "Failed: thermo_school_melting solving for lambda")
    }

    func test_thermo_school_melting_m() throws {
        let result = try sut.calculate(rule: "Q / lambda", variables: ["Q": 668000.0, "lambda": 334000.0])
        XCTAssertEqual(result, 2.0, accuracy: 0.01, "Failed: thermo_school_melting solving for m")
    }

    // MARK: - Heat of Vaporization (thermo_school_vaporization)

    func test_thermo_school_vaporization_Q() throws {
        let result = try sut.calculate(rule: "L * m", variables: ["L": 5.0, "m": 2.0])
        XCTAssertEqual(result, 10.0, accuracy: 0.01, "Failed: thermo_school_vaporization solving for Q")
    }

    func test_thermo_school_vaporization_L() throws {
        let result = try sut.calculate(rule: "Q / m", variables: ["Q": 5.0, "m": 2.0])
        XCTAssertEqual(result, 2.5, accuracy: 0.01, "Failed: thermo_school_vaporization solving for L")
    }

    func test_thermo_school_vaporization_m() throws {
        let result = try sut.calculate(rule: "Q / L", variables: ["Q": 5.0, "L": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: thermo_school_vaporization solving for m")
    }

    // MARK: - Van der Waals Equation (1 mole) (thermo_uni_van_der_waals)

    func test_thermo_uni_van_der_waals_P() throws {
        let result = try sut.calculate(rule: "(R * T) / (V - b) - a / (V * V)", variables: ["a": 0.1358, "V": 0.0224, "b": 3.64e-05, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 111258.80231995296, accuracy: 0.01, "Failed: thermo_uni_van_der_waals solving for P")
    }

    func test_thermo_uni_van_der_waals_T() throws {
        let result = try sut.calculate(rule: "((P + a / (V * V)) * (V - b)) / R", variables: ["P": 101325.0, "a": 0.1358, "V": 0.0224, "b": 3.64e-05, "R": 8.314])
        XCTAssertEqual(result, 273.27933827730334, accuracy: 0.01, "Failed: thermo_uni_van_der_waals solving for T")
    }

    func test_thermo_uni_van_der_waals_R() throws {
        let result = try sut.calculate(rule: "8.314", variables: ["P": 101325.0, "a": 0.1358, "V": 0.0224, "b": 3.64e-05, "T": 300.0])
        XCTAssertEqual(result, 8.314, accuracy: 0.01, "Failed: thermo_uni_van_der_waals solving for R")
    }

    func test_thermo_uni_van_der_waals_a() throws {
        let result = try sut.calculate(rule: "(R * T / (V - b) - P) * V * V", variables: ["P": 101325.0, "V": 0.0224, "b": 3.64e-05, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 5.120184652059592, accuracy: 0.01, "Failed: thermo_uni_van_der_waals solving for a")
    }

    func test_thermo_uni_van_der_waals_b() throws {
        let result = try sut.calculate(rule: "V - R * T / (P + a / (V * V))", variables: ["P": 101325.0, "a": 0.1358, "V": 0.0224, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, -0.0021502643642679273, accuracy: 2.1502643642679273e-05, "Failed: thermo_uni_van_der_waals solving for b")
    }

    func test_thermo_uni_van_der_waals_V() throws {
        let result = try sut.calculate(rule: "R * T / P + b", variables: ["P": 101325.0, "a": 0.1358, "b": 3.64e-05, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 0.02465224011843079, accuracy: 0.0002465224011843079, "Failed: thermo_uni_van_der_waals solving for V")
    }

    // MARK: - Coulomb's Law (em_school_coulomb_law)

    func test_em_school_coulomb_law_F() throws {
        let result = try sut.calculate(rule: "k * q1 * q2 / (r * r)", variables: ["k": 5.0, "q1": 5.0, "q2": 5.0, "r": 2.0])
        XCTAssertEqual(result, 31.25, accuracy: 0.01, "Failed: em_school_coulomb_law solving for F")
    }

    func test_em_school_coulomb_law_k() throws {
        let result = try sut.calculate(rule: "F * r * r / (q1 * q2)", variables: ["F": 5.0, "q1": 5.0, "q2": 5.0, "r": 2.0])
        XCTAssertEqual(result, 0.8, accuracy: 0.008, "Failed: em_school_coulomb_law solving for k")
    }

    func test_em_school_coulomb_law_q1() throws {
        let result = try sut.calculate(rule: "F * r * r / (k * q2)", variables: ["F": 5.0, "k": 5.0, "q2": 5.0, "r": 2.0])
        XCTAssertEqual(result, 0.8, accuracy: 0.008, "Failed: em_school_coulomb_law solving for q1")
    }

    func test_em_school_coulomb_law_q2() throws {
        let result = try sut.calculate(rule: "F * r * r / (k * q1)", variables: ["F": 5.0, "k": 5.0, "q1": 5.0, "r": 2.0])
        XCTAssertEqual(result, 0.8, accuracy: 0.008, "Failed: em_school_coulomb_law solving for q2")
    }

    func test_em_school_coulomb_law_r() throws {
        let result = try sut.calculate(rule: "sqrt(k * q1 * q2 / F)", variables: ["F": 5.0, "k": 5.0, "q1": 5.0, "q2": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: em_school_coulomb_law solving for r")
    }

    // MARK: - Electric Field Strength (em_school_electric_field)

    func test_em_school_electric_field_E() throws {
        let result = try sut.calculate(rule: "F / q", variables: ["F": 5.0, "q": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_electric_field solving for E")
    }

    func test_em_school_electric_field_F() throws {
        let result = try sut.calculate(rule: "E * q", variables: ["E": 5.0, "q": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: em_school_electric_field solving for F")
    }

    func test_em_school_electric_field_q() throws {
        let result = try sut.calculate(rule: "F / E", variables: ["E": 5.0, "F": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_electric_field solving for q")
    }

    // MARK: - Capacitance (em_school_capacitance)

    func test_em_school_capacitance_C() throws {
        let result = try sut.calculate(rule: "q / U", variables: ["q": 5.0, "U": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_capacitance solving for C")
    }

    func test_em_school_capacitance_q() throws {
        let result = try sut.calculate(rule: "C * U", variables: ["C": 5.0, "U": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: em_school_capacitance solving for q")
    }

    func test_em_school_capacitance_U() throws {
        let result = try sut.calculate(rule: "q / C", variables: ["C": 5.0, "q": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_capacitance solving for U")
    }

    // MARK: - Capacitor Energy (em_school_capacitor_energy)

    func test_em_school_capacitor_energy_W() throws {
        let result = try sut.calculate(rule: "0.5 * C * U * U", variables: ["C": 5.0, "U": 5.0])
        XCTAssertEqual(result, 62.5, accuracy: 0.01, "Failed: em_school_capacitor_energy solving for W")
    }

    func test_em_school_capacitor_energy_C() throws {
        let result = try sut.calculate(rule: "(2 * W) / (U * U)", variables: ["W": 5.0, "U": 5.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: em_school_capacitor_energy solving for C")
    }

    func test_em_school_capacitor_energy_U() throws {
        let result = try sut.calculate(rule: "sqrt((2 * W) / C)", variables: ["W": 5.0, "C": 5.0])
        XCTAssertEqual(result, 1.4142135623730951, accuracy: 0.01, "Failed: em_school_capacitor_energy solving for U")
    }

    // MARK: - Electric Power (em_school_electric_power)

    func test_em_school_electric_power_P() throws {
        let result = try sut.calculate(rule: "U * I", variables: ["U": 5.0, "I": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: em_school_electric_power solving for P")
    }

    func test_em_school_electric_power_U() throws {
        let result = try sut.calculate(rule: "P / I", variables: ["P": 5.0, "I": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_electric_power solving for U")
    }

    func test_em_school_electric_power_I() throws {
        let result = try sut.calculate(rule: "P / U", variables: ["P": 5.0, "U": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_electric_power solving for I")
    }

    // MARK: - Electric Work (em_school_electric_work)

    func test_em_school_electric_work_A() throws {
        let result = try sut.calculate(rule: "U * I * t", variables: ["U": 5.0, "I": 5.0, "t": 5.0])
        XCTAssertEqual(result, 125.0, accuracy: 0.01, "Failed: em_school_electric_work solving for A")
    }

    func test_em_school_electric_work_U() throws {
        let result = try sut.calculate(rule: "A / (I * t)", variables: ["A": 5.0, "I": 5.0, "t": 5.0])
        XCTAssertEqual(result, 0.2, accuracy: 0.002, "Failed: em_school_electric_work solving for U")
    }

    func test_em_school_electric_work_I() throws {
        let result = try sut.calculate(rule: "A / (U * t)", variables: ["A": 5.0, "U": 5.0, "t": 5.0])
        XCTAssertEqual(result, 0.2, accuracy: 0.002, "Failed: em_school_electric_work solving for I")
    }

    func test_em_school_electric_work_t() throws {
        let result = try sut.calculate(rule: "A / (U * I)", variables: ["A": 5.0, "U": 5.0, "I": 5.0])
        XCTAssertEqual(result, 0.2, accuracy: 0.002, "Failed: em_school_electric_work solving for t")
    }

    // MARK: - Joule-Lenz Law (em_school_joule_lenz)

    func test_em_school_joule_lenz_Q() throws {
        let result = try sut.calculate(rule: "I * I * R * t", variables: ["I": 5.0, "R": 5.0, "t": 5.0])
        XCTAssertEqual(result, 625.0, accuracy: 0.01, "Failed: em_school_joule_lenz solving for Q")
    }

    func test_em_school_joule_lenz_I() throws {
        let result = try sut.calculate(rule: "sqrt(Q / (R * t))", variables: ["Q": 5.0, "R": 5.0, "t": 5.0])
        XCTAssertEqual(result, 0.4472135954999579, accuracy: 0.00447213595499958, "Failed: em_school_joule_lenz solving for I")
    }

    func test_em_school_joule_lenz_R() throws {
        let result = try sut.calculate(rule: "Q / (I * I * t)", variables: ["Q": 5.0, "I": 5.0, "t": 5.0])
        XCTAssertEqual(result, 0.04, accuracy: 0.0004, "Failed: em_school_joule_lenz solving for R")
    }

    func test_em_school_joule_lenz_t() throws {
        let result = try sut.calculate(rule: "Q / (I * I * R)", variables: ["Q": 5.0, "I": 5.0, "R": 5.0])
        XCTAssertEqual(result, 0.04, accuracy: 0.0004, "Failed: em_school_joule_lenz solving for t")
    }

    // MARK: - Series Resistance (em_school_series_resistance)

    func test_em_school_series_resistance_R() throws {
        let result = try sut.calculate(rule: "R1 + R2", variables: ["R1": 6.0, "R2": 9.0])
        XCTAssertEqual(result, 15.0, accuracy: 0.01, "Failed: em_school_series_resistance solving for R")
    }

    func test_em_school_series_resistance_R1() throws {
        let result = try sut.calculate(rule: "R - R2", variables: ["R": 15.0, "R2": 9.0])
        XCTAssertEqual(result, 6.0, accuracy: 0.01, "Failed: em_school_series_resistance solving for R1")
    }

    func test_em_school_series_resistance_R2() throws {
        let result = try sut.calculate(rule: "R - R1", variables: ["R": 15.0, "R1": 6.0])
        XCTAssertEqual(result, 9.0, accuracy: 0.01, "Failed: em_school_series_resistance solving for R2")
    }

    // MARK: - Parallel Resistance (em_school_parallel_resistance)

    func test_em_school_parallel_resistance_R() throws {
        let result = try sut.calculate(rule: "1 / (1/R1 + 1/R2)", variables: ["R1": 3.0, "R2": 6.0])
        XCTAssertEqual(result, 2.0, accuracy: 0.01, "Failed: em_school_parallel_resistance solving for R")
    }

    func test_em_school_parallel_resistance_R1() throws {
        let result = try sut.calculate(rule: "1 / (1/R - 1/R2)", variables: ["R": 2.0, "R2": 6.0])
        XCTAssertEqual(result, 2.9999999999999996, accuracy: 0.01, "Failed: em_school_parallel_resistance solving for R1")
    }

    func test_em_school_parallel_resistance_R2() throws {
        let result = try sut.calculate(rule: "1 / (1/R - 1/R1)", variables: ["R": 2.0, "R1": 3.0])
        XCTAssertEqual(result, 5.999999999999999, accuracy: 0.01, "Failed: em_school_parallel_resistance solving for R2")
    }

    // MARK: - Ampere Force (em_school_ampere_force)

    func test_em_school_ampere_force_F() throws {
        let result = try sut.calculate(rule: "B * I * l * sin(alpha)", variables: ["B": 5.0, "I": 5.0, "l": 2.0, "alpha": 0.5])
        XCTAssertEqual(result, 23.971276930210152, accuracy: 0.01, "Failed: em_school_ampere_force solving for F")
    }

    func test_em_school_ampere_force_B() throws {
        let result = try sut.calculate(rule: "F / (I * l * sin(alpha))", variables: ["F": 5.0, "I": 5.0, "l": 2.0, "alpha": 0.5])
        XCTAssertEqual(result, 1.042914821466744, accuracy: 0.01, "Failed: em_school_ampere_force solving for B")
    }

    func test_em_school_ampere_force_I() throws {
        let result = try sut.calculate(rule: "F / (B * l * sin(alpha))", variables: ["F": 5.0, "B": 5.0, "l": 2.0, "alpha": 0.5])
        XCTAssertEqual(result, 1.042914821466744, accuracy: 0.01, "Failed: em_school_ampere_force solving for I")
    }

    func test_em_school_ampere_force_l() throws {
        let result = try sut.calculate(rule: "F / (B * I * sin(alpha))", variables: ["F": 5.0, "B": 5.0, "I": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 0.4171659285866976, accuracy: 0.004171659285866976, "Failed: em_school_ampere_force solving for l")
    }

    func test_em_school_ampere_force_alpha() throws {
        let result = try sut.calculate(rule: "asin(F / (B * I * l))", variables: ["F": 5.0, "B": 5.0, "I": 5.0, "l": 2.0])
        XCTAssertEqual(result, 0.1001674211615598, accuracy: 0.001001674211615598, "Failed: em_school_ampere_force solving for alpha")
    }

    // MARK: - Lorentz Force (em_school_lorentz_force)

    func test_em_school_lorentz_force_F() throws {
        let result = try sut.calculate(rule: "q * v * B * sin(alpha)", variables: ["q": 5.0, "v": 10.0, "B": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 119.85638465105075, accuracy: 0.01, "Failed: em_school_lorentz_force solving for F")
    }

    func test_em_school_lorentz_force_q() throws {
        let result = try sut.calculate(rule: "F / (v * B * sin(alpha))", variables: ["F": 5.0, "v": 10.0, "B": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 0.2085829642933488, accuracy: 0.002085829642933488, "Failed: em_school_lorentz_force solving for q")
    }

    func test_em_school_lorentz_force_v() throws {
        let result = try sut.calculate(rule: "F / (q * B * sin(alpha))", variables: ["F": 5.0, "q": 5.0, "B": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 0.4171659285866976, accuracy: 0.004171659285866976, "Failed: em_school_lorentz_force solving for v")
    }

    func test_em_school_lorentz_force_B() throws {
        let result = try sut.calculate(rule: "F / (q * v * sin(alpha))", variables: ["F": 5.0, "q": 5.0, "v": 10.0, "alpha": 0.5])
        XCTAssertEqual(result, 0.2085829642933488, accuracy: 0.002085829642933488, "Failed: em_school_lorentz_force solving for B")
    }

    func test_em_school_lorentz_force_alpha() throws {
        let result = try sut.calculate(rule: "asin(F / (q * v * B))", variables: ["F": 5.0, "q": 5.0, "v": 10.0, "B": 5.0])
        XCTAssertEqual(result, 0.02000133357339049, accuracy: 0.00020001333573390492, "Failed: em_school_lorentz_force solving for alpha")
    }

    // MARK: - Magnetic Flux (em_school_magnetic_flux)

    func test_em_school_magnetic_flux_Phi() throws {
        let result = try sut.calculate(rule: "B * S * cos(alpha)", variables: ["B": 5.0, "S": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 21.939564047259317, accuracy: 0.01, "Failed: em_school_magnetic_flux solving for Phi")
    }

    func test_em_school_magnetic_flux_B() throws {
        let result = try sut.calculate(rule: "Phi / (S * cos(alpha))", variables: ["Phi": 5.0, "S": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 1.139493927324549, accuracy: 0.01, "Failed: em_school_magnetic_flux solving for B")
    }

    func test_em_school_magnetic_flux_S() throws {
        let result = try sut.calculate(rule: "Phi / (B * cos(alpha))", variables: ["Phi": 5.0, "B": 5.0, "alpha": 0.5])
        XCTAssertEqual(result, 1.139493927324549, accuracy: 0.01, "Failed: em_school_magnetic_flux solving for S")
    }

    func test_em_school_magnetic_flux_alpha() throws {
        let result = try sut.calculate(rule: "acos(Phi / (B * S))", variables: ["Phi": 5.0, "B": 5.0, "S": 5.0])
        XCTAssertEqual(result, 1.3694384060045657, accuracy: 0.01, "Failed: em_school_magnetic_flux solving for alpha")
    }

    // MARK: - Induced EMF (em_school_emf_induction)

    func test_em_school_emf_induction_epsilon() throws {
        let result = try sut.calculate(rule: "dPhi / dt", variables: ["dPhi": 5.0, "dt": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_emf_induction solving for epsilon")
    }

    func test_em_school_emf_induction_dPhi() throws {
        let result = try sut.calculate(rule: "epsilon * dt", variables: ["epsilon": 5.0, "dt": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: em_school_emf_induction solving for dPhi")
    }

    func test_em_school_emf_induction_dt() throws {
        let result = try sut.calculate(rule: "dPhi / epsilon", variables: ["epsilon": 5.0, "dPhi": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_school_emf_induction solving for dt")
    }

    // MARK: - Snell's Law (optics_school_snell_law)

    func test_optics_school_snell_law_n1() throws {
        let result = try sut.calculate(rule: "(n2 * sin(alpha2)) / sin(alpha1)", variables: ["alpha1": 0.5, "n2": 1.0, "alpha2": 0.5])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: optics_school_snell_law solving for n1")
    }

    func test_optics_school_snell_law_alpha1() throws {
        let result = try sut.calculate(rule: "asin((n2 * sin(alpha2)) / n1)", variables: ["n1": 1.5, "n2": 1.0, "alpha2": 0.5])
        XCTAssertEqual(result, 0.32532528522279924, accuracy: 0.0032532528522279925, "Failed: optics_school_snell_law solving for alpha1")
    }

    func test_optics_school_snell_law_n2() throws {
        let result = try sut.calculate(rule: "(n1 * sin(alpha1)) / sin(alpha2)", variables: ["n1": 1.5, "alpha1": 0.5, "alpha2": 0.5])
        XCTAssertEqual(result, 1.5, accuracy: 0.01, "Failed: optics_school_snell_law solving for n2")
    }

    func test_optics_school_snell_law_alpha2() throws {
        let result = try sut.calculate(rule: "asin((n1 * sin(alpha1)) / n2)", variables: ["n1": 1.5, "alpha1": 0.5, "n2": 1.0])
        XCTAssertEqual(result, 0.802561439713572, accuracy: 0.00802561439713572, "Failed: optics_school_snell_law solving for alpha2")
    }

    // MARK: - Diffraction Grating (optics_school_diffraction_grating)

    func test_optics_school_diffraction_grating_d() throws {
        let result = try sut.calculate(rule: "(n_ord * lambda) / sin(theta)", variables: ["theta": 0.3, "n_ord": 2.0, "lambda": 5e-07])
        XCTAssertEqual(result, 3.3838633618241227e-06, accuracy: 3.383863361824123e-08, "Failed: optics_school_diffraction_grating solving for d")
    }

    func test_optics_school_diffraction_grating_theta() throws {
        let result = try sut.calculate(rule: "asin((n_ord * lambda) / d)", variables: ["d": 1e-05, "n_ord": 2.0, "lambda": 5e-07])
        XCTAssertEqual(result, 0.10016742116155979, accuracy: 0.0010016742116155978, "Failed: optics_school_diffraction_grating solving for theta")
    }

    func test_optics_school_diffraction_grating_n_ord() throws {
        let result = try sut.calculate(rule: "(d * sin(theta)) / lambda", variables: ["d": 1e-05, "theta": 0.3, "lambda": 5e-07])
        XCTAssertEqual(result, 5.910404133226791, accuracy: 0.01, "Failed: optics_school_diffraction_grating solving for n_ord")
    }

    func test_optics_school_diffraction_grating_lambda() throws {
        let result = try sut.calculate(rule: "(d * sin(theta)) / n_ord", variables: ["d": 1e-05, "theta": 0.3, "n_ord": 2.0])
        XCTAssertEqual(result, 1.4776010333066978e-06, accuracy: 1.4776010333066978e-08, "Failed: optics_school_diffraction_grating solving for lambda")
    }

    // MARK: - Photon Energy (optics_uni_photon_energy)

    func test_optics_uni_photon_energy_E() throws {
        let result = try sut.calculate(rule: "h * nu", variables: ["h": 6.626e-34, "nu": 500.0])
        XCTAssertEqual(result, 3.313e-31, accuracy: 3.313e-33, "Failed: optics_uni_photon_energy solving for E")
    }

    func test_optics_uni_photon_energy_h() throws {
        let result = try sut.calculate(rule: "E / nu", variables: ["E": 5.0, "nu": 500.0])
        XCTAssertEqual(result, 0.01, accuracy: 0.0001, "Failed: optics_uni_photon_energy solving for h")
    }

    func test_optics_uni_photon_energy_nu() throws {
        let result = try sut.calculate(rule: "E / h", variables: ["E": 5.0, "h": 6.626e-34])
        XCTAssertEqual(result, 7.546030787805615e+33, accuracy: 7.546030787805614e+27, "Failed: optics_uni_photon_energy solving for nu")
    }

    // MARK: - Photoelectric Effect (Einstein) (optics_uni_photoelectric)

    func test_optics_uni_photoelectric_nu() throws {
        let result = try sut.calculate(rule: "(Avyh + 0.5 * m * v * v) / h", variables: ["h": 6.626e-34, "Avyh": 3e-19, "m": 9.109e-31, "v": 500000.0])
        XCTAssertEqual(result, 624603833383640.2, accuracy: 624603833.3836402, "Failed: optics_uni_photoelectric solving for nu")
    }

    func test_optics_uni_photoelectric_Avyh() throws {
        let result = try sut.calculate(rule: "h * nu - 0.5 * m * v * v", variables: ["h": 6.626e-34, "nu": 1000000000000000.0, "m": 9.109e-31, "v": 500000.0])
        XCTAssertEqual(result, 5.487375e-19, accuracy: 5.487375e-21, "Failed: optics_uni_photoelectric solving for Avyh")
    }

    func test_optics_uni_photoelectric_v() throws {
        let result = try sut.calculate(rule: "sqrt((2 * (h * nu - Avyh)) / m)", variables: ["h": 6.626e-34, "nu": 1000000000000000.0, "Avyh": 3e-19, "m": 9.109e-31])
        XCTAssertEqual(result, 892264.3610371008, accuracy: 0.01, "Failed: optics_uni_photoelectric solving for v")
    }

    func test_optics_uni_photoelectric_m() throws {
        let result = try sut.calculate(rule: "(2 * (h * nu - Avyh)) / (v * v)", variables: ["h": 6.626e-34, "nu": 1000000000000000.0, "Avyh": 3e-19, "v": 500000.0])
        XCTAssertEqual(result, 2.9007999999999997e-30, accuracy: 2.9008e-32, "Failed: optics_uni_photoelectric solving for m")
    }

    func test_optics_uni_photoelectric_h() throws {
        let result = try sut.calculate(rule: "(Avyh + 0.5 * m * v * v) / nu", variables: ["nu": 1000000000000000.0, "Avyh": 3e-19, "m": 9.109e-31, "v": 500000.0])
        XCTAssertEqual(result, 4.138625e-34, accuracy: 4.1386249999999995e-36, "Failed: optics_uni_photoelectric solving for h")
    }

    // MARK: - De Broglie Wavelength (optics_uni_de_broglie)

    func test_optics_uni_de_broglie_lambda() throws {
        let result = try sut.calculate(rule: "h / p", variables: ["h": 6.626e-34, "p": 6.626e-24])
        XCTAssertEqual(result, 9.999999999999999e-11, accuracy: 1e-12, "Failed: optics_uni_de_broglie solving for lambda")
    }

    func test_optics_uni_de_broglie_h() throws {
        let result = try sut.calculate(rule: "lambda * p", variables: ["lambda": 1e-10, "p": 6.626e-24])
        XCTAssertEqual(result, 6.626000000000001e-34, accuracy: 6.626000000000001e-36, "Failed: optics_uni_de_broglie solving for h")
    }

    func test_optics_uni_de_broglie_p() throws {
        let result = try sut.calculate(rule: "h / lambda", variables: ["lambda": 1e-10, "h": 6.626e-34])
        XCTAssertEqual(result, 6.625999999999999e-24, accuracy: 6.625999999999999e-26, "Failed: optics_uni_de_broglie solving for p")
    }

    // MARK: - Period of Simple Pendulum (osc_school_period_pendulum)

    func test_osc_school_period_pendulum_T() throws {
        let result = try sut.calculate(rule: "2 * 3.141592653589793 * sqrt(L / g)", variables: ["L": 2.0, "g": 9.8])
        XCTAssertEqual(result, 2.838453790227457, accuracy: 0.01, "Failed: osc_school_period_pendulum solving for T")
    }

    func test_osc_school_period_pendulum_L() throws {
        let result = try sut.calculate(rule: "(T / (2 * 3.141592653589793)) ** 2 * g", variables: ["T": 0.02, "g": 9.8])
        XCTAssertEqual(result, 9.929475996949104e-05, accuracy: 9.929475996949103e-07, "Failed: osc_school_period_pendulum solving for L")
    }

    func test_osc_school_period_pendulum_g() throws {
        let result = try sut.calculate(rule: "L / (T / (2 * 3.141592653589793)) ** 2", variables: ["T": 0.02, "L": 2.0])
        XCTAssertEqual(result, 197392.08802178712, accuracy: 0.01, "Failed: osc_school_period_pendulum solving for g")
    }

    // MARK: - Period of Spring Pendulum (osc_school_period_spring)

    func test_osc_school_period_spring_T() throws {
        let result = try sut.calculate(rule: "2 * 3.141592653589793 * sqrt(m / k)", variables: ["m": 2.0, "k": 5.0])
        XCTAssertEqual(result, 3.9738353063184406, accuracy: 0.01, "Failed: osc_school_period_spring solving for T")
    }

    func test_osc_school_period_spring_m() throws {
        let result = try sut.calculate(rule: "(T / (2 * 3.141592653589793)) ** 2 * k", variables: ["T": 0.02, "k": 5.0])
        XCTAssertEqual(result, 5.06605918211689e-05, accuracy: 5.06605918211689e-07, "Failed: osc_school_period_spring solving for m")
    }

    func test_osc_school_period_spring_k() throws {
        let result = try sut.calculate(rule: "m / (T / (2 * 3.141592653589793)) ** 2", variables: ["T": 0.02, "m": 2.0])
        XCTAssertEqual(result, 197392.08802178712, accuracy: 0.01, "Failed: osc_school_period_spring solving for k")
    }

    // MARK: - Oscillation Frequency (osc_school_frequency)

    func test_osc_school_frequency_f() throws {
        let result = try sut.calculate(rule: "1 / T", variables: ["T": 0.02])
        XCTAssertEqual(result, 50.0, accuracy: 0.01, "Failed: osc_school_frequency solving for f")
    }

    func test_osc_school_frequency_T() throws {
        let result = try sut.calculate(rule: "1 / f", variables: ["f": 500.0])
        XCTAssertEqual(result, 0.002, accuracy: 2e-05, "Failed: osc_school_frequency solving for T")
    }

    // MARK: - Angular Frequency (osc_school_angular_frequency)

    func test_osc_school_angular_frequency_omega() throws {
        let result = try sut.calculate(rule: "2 * 3.141592653589793 * f", variables: ["f": 500.0])
        XCTAssertEqual(result, 3141.592653589793, accuracy: 0.01, "Failed: osc_school_angular_frequency solving for omega")
    }

    func test_osc_school_angular_frequency_f() throws {
        let result = try sut.calculate(rule: "omega / (2 * 3.141592653589793)", variables: ["omega": 500.0])
        XCTAssertEqual(result, 79.57747154594767, accuracy: 0.01, "Failed: osc_school_angular_frequency solving for f")
    }

    // MARK: - Harmonic Oscillation (osc_school_harmonic_displacement)

    func test_osc_school_harmonic_displacement_x() throws {
        let result = try sut.calculate(rule: "A * cos(omega * t)", variables: ["A": 5.0, "omega": 2.0, "t": 0.5])
        XCTAssertEqual(result, 2.701511529340699, accuracy: 0.01, "Failed: osc_school_harmonic_displacement solving for x")
    }

    func test_osc_school_harmonic_displacement_A() throws {
        let result = try sut.calculate(rule: "x / cos(omega * t)", variables: ["x": 3.0, "omega": 2.0, "t": 0.5])
        XCTAssertEqual(result, 5.552447153042777, accuracy: 0.01, "Failed: osc_school_harmonic_displacement solving for A")
    }

    func test_osc_school_harmonic_displacement_t() throws {
        let result = try sut.calculate(rule: "acos(x / A) / omega", variables: ["x": 3.0, "A": 5.0, "omega": 2.0])
        XCTAssertEqual(result, 0.46364760900080615, accuracy: 0.004636476090008061, "Failed: osc_school_harmonic_displacement solving for t")
    }

    func test_osc_school_harmonic_displacement_omega() throws {
        let result = try sut.calculate(rule: "acos(x / A) / t", variables: ["x": 3.0, "A": 5.0, "t": 0.5])
        XCTAssertEqual(result, 1.8545904360032246, accuracy: 0.01, "Failed: osc_school_harmonic_displacement solving for omega")
    }

    // MARK: - Total Energy of Oscillation (osc_uni_energy_oscillation)

    func test_osc_uni_energy_oscillation_E() throws {
        let result = try sut.calculate(rule: "k * A ** 2 / 2", variables: ["k": 5.0, "A": 5.0])
        XCTAssertEqual(result, 62.5, accuracy: 0.01, "Failed: osc_uni_energy_oscillation solving for E")
    }

    func test_osc_uni_energy_oscillation_k() throws {
        let result = try sut.calculate(rule: "2 * E / A ** 2", variables: ["E": 5.0, "A": 5.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: osc_uni_energy_oscillation solving for k")
    }

    func test_osc_uni_energy_oscillation_A() throws {
        let result = try sut.calculate(rule: "sqrt(2 * E / k)", variables: ["E": 5.0, "k": 5.0])
        XCTAssertEqual(result, 1.4142135623730951, accuracy: 0.01, "Failed: osc_uni_energy_oscillation solving for A")
    }

    // MARK: - Damped Oscillation Amplitude (osc_uni_damped_oscillation)

    func test_osc_uni_damped_oscillation_A_t() throws {
        let result = try sut.calculate(rule: "A_0 * exp(-beta * t)", variables: ["A_0": 5.0, "beta": 0.1, "t": 5.0])
        XCTAssertEqual(result, 3.032653298563167, accuracy: 0.01, "Failed: osc_uni_damped_oscillation solving for A_t")
    }

    func test_osc_uni_damped_oscillation_A_0() throws {
        let result = try sut.calculate(rule: "A_t / exp(-beta * t)", variables: ["A_t": 3.0, "beta": 0.1, "t": 5.0])
        XCTAssertEqual(result, 4.946163812100385, accuracy: 0.01, "Failed: osc_uni_damped_oscillation solving for A_0")
    }

    func test_osc_uni_damped_oscillation_beta() throws {
        let result = try sut.calculate(rule: "-log(A_t / A_0) / t", variables: ["A_t": 3.0, "A_0": 5.0, "t": 5.0])
        XCTAssertEqual(result, 0.10216512475319814, accuracy: 0.0010216512475319814, "Failed: osc_uni_damped_oscillation solving for beta")
    }

    func test_osc_uni_damped_oscillation_t() throws {
        let result = try sut.calculate(rule: "-log(A_t / A_0) / beta", variables: ["A_t": 3.0, "A_0": 5.0, "beta": 0.1])
        XCTAssertEqual(result, 5.108256237659907, accuracy: 0.01, "Failed: osc_uni_damped_oscillation solving for t")
    }

    // MARK: - Wave Velocity (osc_school_wave_velocity)

    func test_osc_school_wave_velocity_v() throws {
        let result = try sut.calculate(rule: "lambda * f", variables: ["lambda": 0.5, "f": 680.0])
        XCTAssertEqual(result, 340.0, accuracy: 0.01, "Failed: osc_school_wave_velocity solving for v")
    }

    func test_osc_school_wave_velocity_lambda() throws {
        let result = try sut.calculate(rule: "v / f", variables: ["v": 340.0, "f": 680.0])
        XCTAssertEqual(result, 0.5, accuracy: 0.005, "Failed: osc_school_wave_velocity solving for lambda")
    }

    func test_osc_school_wave_velocity_f() throws {
        let result = try sut.calculate(rule: "v / lambda", variables: ["v": 340.0, "lambda": 0.5])
        XCTAssertEqual(result, 680.0, accuracy: 0.01, "Failed: osc_school_wave_velocity solving for f")
    }

    // MARK: - Wavelength via Period (osc_school_wave_period)

    func test_osc_school_wave_period_lambda() throws {
        let result = try sut.calculate(rule: "v * T", variables: ["v": 340.0, "T": 0.0014705882352941176, "f": 680.0])
        XCTAssertEqual(result, 0.5, accuracy: 0.005, "Failed: osc_school_wave_period solving for lambda")
    }

    func test_osc_school_wave_period_v() throws {
        let result = try sut.calculate(rule: "lambda / T", variables: ["lambda": 0.5, "T": 0.0014705882352941176, "f": 680.0])
        XCTAssertEqual(result, 340.0, accuracy: 0.01, "Failed: osc_school_wave_period solving for v")
    }

    func test_osc_school_wave_period_T() throws {
        let result = try sut.calculate(rule: "lambda / v", variables: ["lambda": 0.5, "v": 340.0, "f": 680.0])
        XCTAssertEqual(result, 0.0014705882352941176, accuracy: 1.4705882352941177e-05, "Failed: osc_school_wave_period solving for T")
    }

    // MARK: - Standing Wave Length (osc_uni_standing_wave)

    func test_osc_uni_standing_wave_L() throws {
        let result = try sut.calculate(rule: "n * lambda / 2", variables: ["n": 3.0, "lambda": 1.0])
        XCTAssertEqual(result, 1.5, accuracy: 0.01, "Failed: osc_uni_standing_wave solving for L")
    }

    func test_osc_uni_standing_wave_n() throws {
        let result = try sut.calculate(rule: "2 * L / lambda", variables: ["L": 1.5, "lambda": 1.0])
        XCTAssertEqual(result, 3.0, accuracy: 0.01, "Failed: osc_uni_standing_wave solving for n")
    }

    func test_osc_uni_standing_wave_lambda() throws {
        let result = try sut.calculate(rule: "2 * L / n", variables: ["L": 1.5, "n": 3.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: osc_uni_standing_wave solving for lambda")
    }

    // MARK: - Wave Intensity (osc_uni_wave_intensity)

    func test_osc_uni_wave_intensity_I() throws {
        let result = try sut.calculate(rule: "P / S", variables: ["P": 5.0, "S": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: osc_uni_wave_intensity solving for I")
    }

    func test_osc_uni_wave_intensity_P() throws {
        let result = try sut.calculate(rule: "I * S", variables: ["I": 5.0, "S": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: osc_uni_wave_intensity solving for P")
    }

    func test_osc_uni_wave_intensity_S() throws {
        let result = try sut.calculate(rule: "P / I", variables: ["I": 5.0, "P": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: osc_uni_wave_intensity solving for S")
    }

    // MARK: - Speed of Sound in Air (osc_school_sound_speed)

    func test_osc_school_sound_speed_v() throws {
        let result = try sut.calculate(rule: "331 + 0.6 * T_C", variables: ["T_C": 300.0])
        XCTAssertEqual(result, 511.0, accuracy: 0.01, "Failed: osc_school_sound_speed solving for v")
    }

    func test_osc_school_sound_speed_T_C() throws {
        let result = try sut.calculate(rule: "(v - 331) / 0.6", variables: ["v": 10.0])
        XCTAssertEqual(result, -535.0, accuracy: 0.01, "Failed: osc_school_sound_speed solving for T_C")
    }

    // MARK: - Doppler Effect (Sound) (osc_uni_doppler)

    func test_osc_uni_doppler_f_obs() throws {
        let result = try sut.calculate(rule: "f * (v + v_o) / (v + v_s)", variables: ["f": 500.0, "v": 340.0, "v_o": 10.0, "v_s": 5.0])
        XCTAssertEqual(result, 507.2463768115942, accuracy: 0.01, "Failed: osc_uni_doppler solving for f_obs")
    }

    func test_osc_uni_doppler_f() throws {
        let result = try sut.calculate(rule: "f_obs * (v + v_s) / (v + v_o)", variables: ["f_obs": 550.0, "v": 340.0, "v_o": 10.0, "v_s": 5.0])
        XCTAssertEqual(result, 542.1428571428571, accuracy: 0.01, "Failed: osc_uni_doppler solving for f")
    }

    func test_osc_uni_doppler_v_o() throws {
        let result = try sut.calculate(rule: "f_obs * (v + v_s) / f - v", variables: ["f_obs": 550.0, "f": 500.0, "v": 340.0, "v_s": 5.0])
        XCTAssertEqual(result, 39.5, accuracy: 0.01, "Failed: osc_uni_doppler solving for v_o")
    }

    func test_osc_uni_doppler_v_s() throws {
        let result = try sut.calculate(rule: "f * (v + v_o) / f_obs - v", variables: ["f_obs": 550.0, "f": 500.0, "v": 340.0, "v_o": 10.0])
        XCTAssertEqual(result, -21.818181818181813, accuracy: 0.01, "Failed: osc_uni_doppler solving for v_s")
    }

    func test_osc_uni_doppler_v() throws {
        let result = try sut.calculate(rule: "(f_obs * v_s - f * v_o) / (f - f_obs)", variables: ["f_obs": 550.0, "f": 500.0, "v_o": 10.0, "v_s": 5.0])
        XCTAssertEqual(result, 45.0, accuracy: 0.01, "Failed: osc_uni_doppler solving for v")
    }

    // MARK: - Sound Intensity Level (osc_uni_sound_intensity_level)

    func test_osc_uni_sound_intensity_level_L_dB() throws {
        let result = try sut.calculate(rule: "10 * log10(I / I_0)", variables: ["I": 1e-06, "I_0": 1e-12])
        XCTAssertEqual(result, 60.0, accuracy: 0.01, "Failed: osc_uni_sound_intensity_level solving for L_dB")
    }

    func test_osc_uni_sound_intensity_level_I() throws {
        let result = try sut.calculate(rule: "I_0 * 10 ** (L_dB / 10)", variables: ["L_dB": 60.0, "I_0": 1e-12])
        XCTAssertEqual(result, 1e-06, accuracy: 1e-08, "Failed: osc_uni_sound_intensity_level solving for I")
    }

    func test_osc_uni_sound_intensity_level_I_0() throws {
        let result = try sut.calculate(rule: "I / 10 ** (L_dB / 10)", variables: ["L_dB": 60.0, "I": 1e-06])
        XCTAssertEqual(result, 1e-12, accuracy: 1e-14, "Failed: osc_uni_sound_intensity_level solving for I_0")
    }

    // MARK: - Mass–Energy Equivalence (modern_uni_mass_energy)

    func test_modern_uni_mass_energy_E() throws {
        let result = try sut.calculate(rule: "m * c ** 2", variables: ["m": 2.0, "c": 300000000.0])
        XCTAssertEqual(result, 1.8e+17, accuracy: 180000000000.0, "Failed: modern_uni_mass_energy solving for E")
    }

    func test_modern_uni_mass_energy_m() throws {
        let result = try sut.calculate(rule: "E / c ** 2", variables: ["E": 5.0, "c": 300000000.0])
        XCTAssertEqual(result, 5.555555555555556e-17, accuracy: 5.5555555555555565e-19, "Failed: modern_uni_mass_energy solving for m")
    }

    func test_modern_uni_mass_energy_c() throws {
        let result = try sut.calculate(rule: "sqrt(E / m)", variables: ["E": 5.0, "m": 2.0])
        XCTAssertEqual(result, 1.5811388300841898, accuracy: 0.01, "Failed: modern_uni_mass_energy solving for c")
    }

    // MARK: - Time Dilation (modern_uni_time_dilation)

    func test_modern_uni_time_dilation_dt() throws {
        let result = try sut.calculate(rule: "dt_0 / sqrt(1 - (v / c) ** 2)", variables: ["dt_0": 5.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 5.303300858899107, accuracy: 0.01, "Failed: modern_uni_time_dilation solving for dt")
    }

    func test_modern_uni_time_dilation_dt_0() throws {
        let result = try sut.calculate(rule: "dt * sqrt(1 - (v / c) ** 2)", variables: ["dt": 5.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 4.714045207910317, accuracy: 0.01, "Failed: modern_uni_time_dilation solving for dt_0")
    }

    // SKIP: test_modern_uni_time_dilation_v - extreme value: 0.0

    func test_modern_uni_time_dilation_c() throws {
        let result = try sut.calculate(rule: "299792458", variables: ["dt": 5.0, "dt_0": 5.0, "v": 100000000.0])
        XCTAssertEqual(result, 299792458, accuracy: 299.792458, "Failed: modern_uni_time_dilation solving for c")
    }

    // MARK: - Length Contraction (modern_uni_length_contraction)

    func test_modern_uni_length_contraction_L() throws {
        let result = try sut.calculate(rule: "L_0 * sqrt(1 - (v / c) ** 2)", variables: ["L_0": 2.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 1.8856180831641267, accuracy: 0.01, "Failed: modern_uni_length_contraction solving for L")
    }

    func test_modern_uni_length_contraction_L_0() throws {
        let result = try sut.calculate(rule: "L / sqrt(1 - (v / c) ** 2)", variables: ["L": 2.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 2.1213203435596424, accuracy: 0.01, "Failed: modern_uni_length_contraction solving for L_0")
    }

    // SKIP: test_modern_uni_length_contraction_v - extreme value: 0.0

    func test_modern_uni_length_contraction_c() throws {
        let result = try sut.calculate(rule: "299792458", variables: ["L": 2.0, "L_0": 2.0, "v": 100000000.0])
        XCTAssertEqual(result, 299792458, accuracy: 299.792458, "Failed: modern_uni_length_contraction solving for c")
    }

    // MARK: - Relativistic Momentum (modern_uni_relativistic_momentum)

    func test_modern_uni_relativistic_momentum_p() throws {
        let result = try sut.calculate(rule: "m * v / sqrt(1 - (v / c) ** 2)", variables: ["m": 2.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 212132034.35596427, accuracy: 212.13203435596427, "Failed: modern_uni_relativistic_momentum solving for p")
    }

    func test_modern_uni_relativistic_momentum_m() throws {
        let result = try sut.calculate(rule: "p * sqrt(1 - (v / c) ** 2) / v", variables: ["p": 5.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 4.714045207910317e-08, accuracy: 4.714045207910317e-10, "Failed: modern_uni_relativistic_momentum solving for m")
    }

    func test_modern_uni_relativistic_momentum_v() throws {
        let result = try sut.calculate(rule: "p / sqrt(m ** 2 + (p / c) ** 2)", variables: ["p": 5.0, "m": 2.0, "c": 300000000.0])
        XCTAssertEqual(result, 2.5, accuracy: 0.01, "Failed: modern_uni_relativistic_momentum solving for v")
    }

    func test_modern_uni_relativistic_momentum_c() throws {
        let result = try sut.calculate(rule: "299792458", variables: ["p": 5.0, "m": 2.0, "v": 100000000.0])
        XCTAssertEqual(result, 299792458, accuracy: 299.792458, "Failed: modern_uni_relativistic_momentum solving for c")
    }

    // MARK: - Total Relativistic Energy (modern_uni_relativistic_energy)

    func test_modern_uni_relativistic_energy_E() throws {
        let result = try sut.calculate(rule: "m * c ** 2 / sqrt(1 - (v / c) ** 2)", variables: ["m": 2.0, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 1.9091883092036784e+17, accuracy: 190918830920.36783, "Failed: modern_uni_relativistic_energy solving for E")
    }

    func test_modern_uni_relativistic_energy_m() throws {
        let result = try sut.calculate(rule: "E * sqrt(1 - (v / c) ** 2) / c ** 2", variables: ["E": 2e+17, "v": 100000000.0, "c": 300000000.0])
        XCTAssertEqual(result, 2.095131203515696, accuracy: 0.01, "Failed: modern_uni_relativistic_energy solving for m")
    }

    func test_modern_uni_relativistic_energy_v() throws {
        let result = try sut.calculate(rule: "c * sqrt(1 - (m * c ** 2 / E) ** 2)", variables: ["E": 2e+17, "m": 2.0, "c": 300000000.0])
        XCTAssertEqual(result, 130766968.30622019, accuracy: 130.76696830622018, "Failed: modern_uni_relativistic_energy solving for v")
    }

    func test_modern_uni_relativistic_energy_c() throws {
        let result = try sut.calculate(rule: "299792458", variables: ["E": 2e+17, "m": 2.0, "v": 100000000.0])
        XCTAssertEqual(result, 299792458, accuracy: 299.792458, "Failed: modern_uni_relativistic_energy solving for c")
    }

    // MARK: - Radioactive Decay Law (modern_uni_radioactive_decay)

    func test_modern_uni_radioactive_decay_N() throws {
        let result = try sut.calculate(rule: "N_0 * exp(-lambda * t)", variables: ["N_0": 1000.0, "lambda": 0.1, "t": 6.931])
        XCTAssertEqual(result, 500.02359083648275, accuracy: 0.01, "Failed: modern_uni_radioactive_decay solving for N")
    }

    func test_modern_uni_radioactive_decay_N_0() throws {
        let result = try sut.calculate(rule: "N / exp(-lambda * t)", variables: ["N": 500.0, "lambda": 0.1, "t": 6.931])
        XCTAssertEqual(result, 999.9528205530397, accuracy: 0.01, "Failed: modern_uni_radioactive_decay solving for N_0")
    }

    func test_modern_uni_radioactive_decay_lambda() throws {
        let result = try sut.calculate(rule: "-log(N / N_0) / t", variables: ["N": 500.0, "N_0": 1000.0, "t": 6.931])
        XCTAssertEqual(result, 0.1000068071793313, accuracy: 0.001000068071793313, "Failed: modern_uni_radioactive_decay solving for lambda")
    }

    func test_modern_uni_radioactive_decay_t() throws {
        let result = try sut.calculate(rule: "-log(N / N_0) / lambda", variables: ["N": 500.0, "N_0": 1000.0, "lambda": 0.1])
        XCTAssertEqual(result, 6.931471805599452, accuracy: 0.01, "Failed: modern_uni_radioactive_decay solving for t")
    }

    // MARK: - Half-Life (modern_uni_half_life)

    func test_modern_uni_half_life_T_half() throws {
        let result = try sut.calculate(rule: "0.6931471805599453 / lambda", variables: ["lambda": 0.1])
        XCTAssertEqual(result, 6.931471805599452, accuracy: 0.01, "Failed: modern_uni_half_life solving for T_half")
    }

    func test_modern_uni_half_life_lambda() throws {
        let result = try sut.calculate(rule: "0.6931471805599453 / T_half", variables: ["T_half": 6.931])
        XCTAssertEqual(result, 0.1000068071793313, accuracy: 0.001000068071793313, "Failed: modern_uni_half_life solving for lambda")
    }

    // MARK: - Nuclear Binding Energy (modern_uni_binding_energy)

    func test_modern_uni_binding_energy_E_b() throws {
        let result = try sut.calculate(rule: "dm * c ** 2", variables: ["dm": 5.0, "c": 300000000.0])
        XCTAssertEqual(result, 4.5e+17, accuracy: 450000000000.0, "Failed: modern_uni_binding_energy solving for E_b")
    }

    func test_modern_uni_binding_energy_dm() throws {
        let result = try sut.calculate(rule: "E_b / c ** 2", variables: ["E_b": 5.0, "c": 300000000.0])
        XCTAssertEqual(result, 5.555555555555556e-17, accuracy: 5.5555555555555565e-19, "Failed: modern_uni_binding_energy solving for dm")
    }

    func test_modern_uni_binding_energy_c() throws {
        let result = try sut.calculate(rule: "sqrt(E_b / dm)", variables: ["E_b": 5.0, "dm": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: modern_uni_binding_energy solving for c")
    }

    // MARK: - Radioactive Activity (modern_uni_activity)

    func test_modern_uni_activity_A() throws {
        let result = try sut.calculate(rule: "lambda * N", variables: ["lambda": 0.1, "N": 500.0])
        XCTAssertEqual(result, 50.0, accuracy: 0.01, "Failed: modern_uni_activity solving for A")
    }

    func test_modern_uni_activity_lambda() throws {
        let result = try sut.calculate(rule: "A / N", variables: ["A": 50.0, "N": 500.0])
        XCTAssertEqual(result, 0.1, accuracy: 0.001, "Failed: modern_uni_activity solving for lambda")
    }

    func test_modern_uni_activity_N() throws {
        let result = try sut.calculate(rule: "A / lambda", variables: ["A": 50.0, "lambda": 0.1])
        XCTAssertEqual(result, 500.0, accuracy: 0.01, "Failed: modern_uni_activity solving for N")
    }

    // MARK: - Bernoulli's Equation (simplified) (mech_uni_bernoulli)

    func test_mech_uni_bernoulli_P_total() throws {
        let result = try sut.calculate(rule: "P + rho * v ** 2 / 2 + rho * g * h", variables: ["P": 101325.0, "rho": 1000.0, "v": 10.0, "g": 9.8, "h": 2.0])
        XCTAssertEqual(result, 170925.0, accuracy: 0.01, "Failed: mech_uni_bernoulli solving for P_total")
    }

    func test_mech_uni_bernoulli_P() throws {
        let result = try sut.calculate(rule: "P_total - rho * v ** 2 / 2 - rho * g * h", variables: ["P_total": 200000.0, "rho": 1000.0, "v": 10.0, "g": 9.8, "h": 2.0])
        XCTAssertEqual(result, 130400.0, accuracy: 0.01, "Failed: mech_uni_bernoulli solving for P")
    }

    func test_mech_uni_bernoulli_v() throws {
        let result = try sut.calculate(rule: "sqrt(2 * (P_total - P - rho * g * h) / rho)", variables: ["P_total": 200000.0, "P": 101325.0, "rho": 1000.0, "g": 9.8, "h": 2.0])
        XCTAssertEqual(result, 12.575770354137356, accuracy: 0.01, "Failed: mech_uni_bernoulli solving for v")
    }

    func test_mech_uni_bernoulli_h() throws {
        let result = try sut.calculate(rule: "(P_total - P - rho * v ** 2 / 2) / (rho * g)", variables: ["P_total": 200000.0, "P": 101325.0, "rho": 1000.0, "v": 10.0, "g": 9.8])
        XCTAssertEqual(result, 4.966836734693878, accuracy: 0.01, "Failed: mech_uni_bernoulli solving for h")
    }

    func test_mech_uni_bernoulli_g() throws {
        let result = try sut.calculate(rule: "(P_total - P - rho * v ** 2 / 2) / (rho * h)", variables: ["P_total": 200000.0, "P": 101325.0, "rho": 1000.0, "v": 10.0, "h": 2.0])
        XCTAssertEqual(result, 24.3375, accuracy: 0.01, "Failed: mech_uni_bernoulli solving for g")
    }

    func test_mech_uni_bernoulli_rho() throws {
        let result = try sut.calculate(rule: "(P_total - P) / (v ** 2 / 2 + g * h)", variables: ["P_total": 200000.0, "P": 101325.0, "v": 10.0, "g": 9.8, "h": 2.0])
        XCTAssertEqual(result, 1417.7442528735633, accuracy: 0.01, "Failed: mech_uni_bernoulli solving for rho")
    }

    // MARK: - Continuity Equation (mech_uni_continuity)

    func test_mech_uni_continuity_A_1() throws {
        let result = try sut.calculate(rule: "A_2 * v_2 / v_1", variables: ["v_1": 10.0, "A_2": 5.0, "v_2": 10.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: mech_uni_continuity solving for A_1")
    }

    func test_mech_uni_continuity_v_1() throws {
        let result = try sut.calculate(rule: "A_2 * v_2 / A_1", variables: ["A_1": 5.0, "A_2": 5.0, "v_2": 10.0])
        XCTAssertEqual(result, 10.0, accuracy: 0.01, "Failed: mech_uni_continuity solving for v_1")
    }

    func test_mech_uni_continuity_A_2() throws {
        let result = try sut.calculate(rule: "A_1 * v_1 / v_2", variables: ["A_1": 5.0, "v_1": 10.0, "v_2": 10.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: mech_uni_continuity solving for A_2")
    }

    func test_mech_uni_continuity_v_2() throws {
        let result = try sut.calculate(rule: "A_1 * v_1 / A_2", variables: ["A_1": 5.0, "v_1": 10.0, "A_2": 5.0])
        XCTAssertEqual(result, 10.0, accuracy: 0.01, "Failed: mech_uni_continuity solving for v_2")
    }

    // MARK: - Carnot Efficiency (thermo_uni_carnot)

    // SKIP: test_thermo_uni_carnot_eta - extreme value: 0.0

    func test_thermo_uni_carnot_T_C() throws {
        let result = try sut.calculate(rule: "T_H * (1 - eta)", variables: ["eta": 0.4, "T_H": 300.0])
        XCTAssertEqual(result, 180.0, accuracy: 0.01, "Failed: thermo_uni_carnot solving for T_C")
    }

    func test_thermo_uni_carnot_T_H() throws {
        let result = try sut.calculate(rule: "T_C / (1 - eta)", variables: ["eta": 0.4, "T_C": 300.0])
        XCTAssertEqual(result, 500.0, accuracy: 0.01, "Failed: thermo_uni_carnot solving for T_H")
    }

    // MARK: - Fourier's Law of Heat Conduction (thermo_uni_fourier)

    func test_thermo_uni_fourier_Q() throws {
        let result = try sut.calculate(rule: "k_t * A * dT * t / d", variables: ["k_t": 0.6, "A": 5.0, "dT": 300.0, "t": 5.0, "d": 5.0])
        XCTAssertEqual(result, 900.0, accuracy: 0.01, "Failed: thermo_uni_fourier solving for Q")
    }

    func test_thermo_uni_fourier_k_t() throws {
        let result = try sut.calculate(rule: "Q * d / (A * dT * t)", variables: ["Q": 5.0, "A": 5.0, "dT": 300.0, "t": 5.0, "d": 5.0])
        XCTAssertEqual(result, 0.0033333333333333335, accuracy: 3.3333333333333335e-05, "Failed: thermo_uni_fourier solving for k_t")
    }

    func test_thermo_uni_fourier_A() throws {
        let result = try sut.calculate(rule: "Q * d / (k_t * dT * t)", variables: ["Q": 5.0, "k_t": 0.6, "dT": 300.0, "t": 5.0, "d": 5.0])
        XCTAssertEqual(result, 0.027777777777777776, accuracy: 0.0002777777777777778, "Failed: thermo_uni_fourier solving for A")
    }

    func test_thermo_uni_fourier_dT() throws {
        let result = try sut.calculate(rule: "Q * d / (k_t * A * t)", variables: ["Q": 5.0, "k_t": 0.6, "A": 5.0, "t": 5.0, "d": 5.0])
        XCTAssertEqual(result, 1.6666666666666667, accuracy: 0.01, "Failed: thermo_uni_fourier solving for dT")
    }

    func test_thermo_uni_fourier_t() throws {
        let result = try sut.calculate(rule: "Q * d / (k_t * A * dT)", variables: ["Q": 5.0, "k_t": 0.6, "A": 5.0, "dT": 300.0, "d": 5.0])
        XCTAssertEqual(result, 0.027777777777777776, accuracy: 0.0002777777777777778, "Failed: thermo_uni_fourier solving for t")
    }

    func test_thermo_uni_fourier_d() throws {
        let result = try sut.calculate(rule: "k_t * A * dT * t / Q", variables: ["Q": 5.0, "k_t": 0.6, "A": 5.0, "dT": 300.0, "t": 5.0])
        XCTAssertEqual(result, 900.0, accuracy: 0.01, "Failed: thermo_uni_fourier solving for d")
    }

    // MARK: - Solenoid Inductance (em_uni_solenoid_inductance)

    func test_em_uni_solenoid_inductance_L_ind() throws {
        let result = try sut.calculate(rule: "mu_0 * N ** 2 * A / l", variables: ["mu_0": 1.2566e-06, "N": 5.0, "A": 5.0, "l": 2.0])
        XCTAssertEqual(result, 7.853749999999999e-05, accuracy: 7.85375e-07, "Failed: em_uni_solenoid_inductance solving for L_ind")
    }

    func test_em_uni_solenoid_inductance_N() throws {
        let result = try sut.calculate(rule: "sqrt(L_ind * l / (mu_0 * A))", variables: ["L_ind": 5.0, "mu_0": 1.2566e-06, "A": 5.0, "l": 2.0])
        XCTAssertEqual(result, 1261.5848648268866, accuracy: 0.01, "Failed: em_uni_solenoid_inductance solving for N")
    }

    func test_em_uni_solenoid_inductance_A() throws {
        let result = try sut.calculate(rule: "L_ind * l / (mu_0 * N ** 2)", variables: ["L_ind": 5.0, "mu_0": 1.2566e-06, "N": 5.0, "l": 2.0])
        XCTAssertEqual(result, 318319.27423205477, accuracy: 0.01, "Failed: em_uni_solenoid_inductance solving for A")
    }

    func test_em_uni_solenoid_inductance_l() throws {
        let result = try sut.calculate(rule: "mu_0 * N ** 2 * A / L_ind", variables: ["L_ind": 5.0, "mu_0": 1.2566e-06, "N": 5.0, "A": 5.0])
        XCTAssertEqual(result, 3.1414999999999997e-05, accuracy: 3.1415e-07, "Failed: em_uni_solenoid_inductance solving for l")
    }

    func test_em_uni_solenoid_inductance_mu_0() throws {
        let result = try sut.calculate(rule: "L_ind * l / (N ** 2 * A)", variables: ["L_ind": 5.0, "N": 5.0, "A": 5.0, "l": 2.0])
        XCTAssertEqual(result, 0.08, accuracy: 0.0008, "Failed: em_uni_solenoid_inductance solving for mu_0")
    }

    // MARK: - Energy of Magnetic Field in Inductor (em_uni_magnetic_energy)

    func test_em_uni_magnetic_energy_W() throws {
        let result = try sut.calculate(rule: "L_ind * I ** 2 / 2", variables: ["L_ind": 5.0, "I": 5.0])
        XCTAssertEqual(result, 62.5, accuracy: 0.01, "Failed: em_uni_magnetic_energy solving for W")
    }

    func test_em_uni_magnetic_energy_L_ind() throws {
        let result = try sut.calculate(rule: "2 * W / I ** 2", variables: ["W": 5.0, "I": 5.0])
        XCTAssertEqual(result, 0.4, accuracy: 0.004, "Failed: em_uni_magnetic_energy solving for L_ind")
    }

    func test_em_uni_magnetic_energy_I() throws {
        let result = try sut.calculate(rule: "sqrt(2 * W / L_ind)", variables: ["W": 5.0, "L_ind": 5.0])
        XCTAssertEqual(result, 1.4142135623730951, accuracy: 0.01, "Failed: em_uni_magnetic_energy solving for I")
    }

    // MARK: - Lens Magnification (optics_school_magnification)

    func test_optics_school_magnification_Gamma() throws {
        let result = try sut.calculate(rule: "H / h", variables: ["H": 5.0, "h": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: optics_school_magnification solving for Gamma")
    }

    func test_optics_school_magnification_H() throws {
        let result = try sut.calculate(rule: "Gamma * h", variables: ["Gamma": 5.0, "h": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: optics_school_magnification solving for H")
    }

    func test_optics_school_magnification_h() throws {
        let result = try sut.calculate(rule: "H / Gamma", variables: ["Gamma": 5.0, "H": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: optics_school_magnification solving for h")
    }

    // MARK: - Thin Film Interference Maximum (optics_uni_thin_film)

    func test_optics_uni_thin_film_n() throws {
        let result = try sut.calculate(rule: "m * lambda / (2 * d)", variables: ["d": 0.0005, "m": 3.0, "lambda": 5e-07])
        XCTAssertEqual(result, 0.0015, accuracy: 1.5e-05, "Failed: optics_uni_thin_film solving for n")
    }

    func test_optics_uni_thin_film_d() throws {
        let result = try sut.calculate(rule: "m * lambda / (2 * n)", variables: ["n": 1.5, "m": 3.0, "lambda": 5e-07])
        XCTAssertEqual(result, 5e-07, accuracy: 5e-09, "Failed: optics_uni_thin_film solving for d")
    }

    func test_optics_uni_thin_film_m() throws {
        let result = try sut.calculate(rule: "2 * n * d / lambda", variables: ["n": 1.5, "d": 0.0005, "lambda": 5e-07])
        XCTAssertEqual(result, 3000.0, accuracy: 0.01, "Failed: optics_uni_thin_film solving for m")
    }

    func test_optics_uni_thin_film_lambda() throws {
        let result = try sut.calculate(rule: "2 * n * d / m", variables: ["n": 1.5, "d": 0.0005, "m": 3.0])
        XCTAssertEqual(result, 0.0005, accuracy: 5e-06, "Failed: optics_uni_thin_film solving for lambda")
    }

    // MARK: - Displacement Current (em_university_displacement_current)

    func test_em_university_displacement_current_Id() throws {
        let result = try sut.calculate(rule: "eps0 * dPhiE / dt", variables: ["eps0": 8.854e-12, "dPhiE": 5.0, "dt": 5.0])
        XCTAssertEqual(result, 8.854e-12, accuracy: 8.854e-14, "Failed: em_university_displacement_current solving for Id")
    }

    func test_em_university_displacement_current_eps0() throws {
        let result = try sut.calculate(rule: "Id * dt / dPhiE", variables: ["Id": 5.0, "dPhiE": 5.0, "dt": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: em_university_displacement_current solving for eps0")
    }

    func test_em_university_displacement_current_dPhiE() throws {
        let result = try sut.calculate(rule: "Id * dt / eps0", variables: ["Id": 5.0, "eps0": 8.854e-12, "dt": 5.0])
        XCTAssertEqual(result, 2823582561554.1, accuracy: 2823582.5615541, "Failed: em_university_displacement_current solving for dPhiE")
    }

    func test_em_university_displacement_current_dt() throws {
        let result = try sut.calculate(rule: "eps0 * dPhiE / Id", variables: ["Id": 5.0, "eps0": 8.854e-12, "dPhiE": 5.0])
        XCTAssertEqual(result, 8.854e-12, accuracy: 8.854e-14, "Failed: em_university_displacement_current solving for dt")
    }

    // MARK: - Electromagnetic Wave Speed (em_university_em_wave_speed)

    func test_em_university_em_wave_speed_c() throws {
        let result = try sut.calculate(rule: "1 / sqrt(eps0 * mu0)", variables: ["eps0": 8.854e-12, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 299800058.6604658, accuracy: 299.80005866046577, "Failed: em_university_em_wave_speed solving for c")
    }

    func test_em_university_em_wave_speed_eps0() throws {
        let result = try sut.calculate(rule: "1 / (c * c * mu0)", variables: ["c": 300000000.0, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 8.842202062001522e-12, accuracy: 8.842202062001522e-14, "Failed: em_university_em_wave_speed solving for eps0")
    }

    func test_em_university_em_wave_speed_mu0() throws {
        let result = try sut.calculate(rule: "1 / (c * c * eps0)", variables: ["c": 300000000.0, "eps0": 8.854e-12])
        XCTAssertEqual(result, 1.2549255829129335e-06, accuracy: 1.2549255829129335e-08, "Failed: em_university_em_wave_speed solving for mu0")
    }

    // MARK: - E–B Relation in EM Wave (em_university_eb_relation)

    func test_em_university_eb_relation_E() throws {
        let result = try sut.calculate(rule: "c * B", variables: ["c": 300000000.0, "B": 5.0])
        XCTAssertEqual(result, 1500000000.0, accuracy: 1500.0, "Failed: em_university_eb_relation solving for E")
    }

    func test_em_university_eb_relation_c() throws {
        let result = try sut.calculate(rule: "E / B", variables: ["E": 5.0, "B": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: em_university_eb_relation solving for c")
    }

    func test_em_university_eb_relation_B() throws {
        let result = try sut.calculate(rule: "E / c", variables: ["E": 5.0, "c": 300000000.0])
        XCTAssertEqual(result, 1.6666666666666667e-08, accuracy: 1.6666666666666669e-10, "Failed: em_university_eb_relation solving for B")
    }

    // MARK: - EM Field Energy Density (em_university_em_energy_density)

    func test_em_university_em_energy_density_w() throws {
        let result = try sut.calculate(rule: "eps0 * E * E / 2 + B * B / (2 * mu0)", variables: ["eps0": 8.854e-12, "E": 100.0, "B": 3.33e-07, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 8.83926325003979e-08, accuracy: 8.83926325003979e-10, "Failed: em_university_em_energy_density solving for w")
    }

    func test_em_university_em_energy_density_E() throws {
        let result = try sut.calculate(rule: "sqrt((w - B * B / (2 * mu0)) * 2 / eps0)", variables: ["w": 1e-06, "eps0": 8.854e-12, "B": 3.33e-07, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 464.67181243162287, accuracy: 0.01, "Failed: em_university_em_energy_density solving for E")
    }

    func test_em_university_em_energy_density_B() throws {
        let result = try sut.calculate(rule: "sqrt((w - eps0 * E * E / 2) * 2 * mu0)", variables: ["w": 1e-06, "eps0": 8.854e-12, "E": 100.0, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 1.549819549496005e-06, accuracy: 1.549819549496005e-08, "Failed: em_university_em_energy_density solving for B")
    }

    func test_em_university_em_energy_density_eps0() throws {
        let result = try sut.calculate(rule: "(w - B * B / (2 * mu0)) * 2 / (E * E)", variables: ["w": 1e-06, "E": 100.0, "B": 3.33e-07, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 1.911754734999204e-10, accuracy: 1.911754734999204e-12, "Failed: em_university_em_energy_density solving for eps0")
    }

    func test_em_university_em_energy_density_mu0() throws {
        let result = try sut.calculate(rule: "B * B / (2 * (w - eps0 * E * E / 2))", variables: ["w": 1e-06, "eps0": 8.854e-12, "E": 100.0, "B": 3.33e-07])
        XCTAssertEqual(result, 5.801272325866091e-08, accuracy: 5.801272325866091e-10, "Failed: em_university_em_energy_density solving for mu0")
    }

    // MARK: - Poynting Vector (Intensity) (em_university_poynting_vector)

    func test_em_university_poynting_vector_S() throws {
        let result = try sut.calculate(rule: "E * B / mu0", variables: ["E": 5.0, "B": 5.0, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 19894954.639503423, accuracy: 19.89495463950342, "Failed: em_university_poynting_vector solving for S")
    }

    func test_em_university_poynting_vector_E() throws {
        let result = try sut.calculate(rule: "S * mu0 / B", variables: ["S": 5.0, "B": 5.0, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 1.2566e-06, accuracy: 1.2566e-08, "Failed: em_university_poynting_vector solving for E")
    }

    func test_em_university_poynting_vector_B() throws {
        let result = try sut.calculate(rule: "S * mu0 / E", variables: ["S": 5.0, "E": 5.0, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 1.2566e-06, accuracy: 1.2566e-08, "Failed: em_university_poynting_vector solving for B")
    }

    func test_em_university_poynting_vector_mu0() throws {
        let result = try sut.calculate(rule: "E * B / S", variables: ["S": 5.0, "E": 5.0, "B": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: em_university_poynting_vector solving for mu0")
    }

    // MARK: - Wave Impedance of Free Space (em_university_wave_impedance)

    func test_em_university_wave_impedance_Z0() throws {
        let result = try sut.calculate(rule: "sqrt(mu0 / eps0)", variables: ["mu0": 1.2566e-06, "eps0": 8.854e-12])
        XCTAssertEqual(result, 376.72875371274125, accuracy: 0.01, "Failed: em_university_wave_impedance solving for Z0")
    }

    func test_em_university_wave_impedance_mu0() throws {
        let result = try sut.calculate(rule: "Z0 * Z0 * eps0", variables: ["Z0": 5.0, "eps0": 8.854e-12])
        XCTAssertEqual(result, 2.2135e-10, accuracy: 2.2135e-12, "Failed: em_university_wave_impedance solving for mu0")
    }

    func test_em_university_wave_impedance_eps0() throws {
        let result = try sut.calculate(rule: "mu0 / (Z0 * Z0)", variables: ["Z0": 5.0, "mu0": 1.2566e-06])
        XCTAssertEqual(result, 5.0264e-08, accuracy: 5.0264e-10, "Failed: em_university_wave_impedance solving for eps0")
    }

    // MARK: - Intensity from Point Source (em_university_intensity_point_source)

    func test_em_university_intensity_point_source_I() throws {
        let result = try sut.calculate(rule: "P / (4 * 3.141592653589793 * r * r)", variables: ["P": 5.0, "r": 2.0])
        XCTAssertEqual(result, 0.0994718394324346, accuracy: 0.0009947183943243459, "Failed: em_university_intensity_point_source solving for I")
    }

    func test_em_university_intensity_point_source_P() throws {
        let result = try sut.calculate(rule: "I * 4 * 3.141592653589793 * r * r", variables: ["I": 5.0, "r": 2.0])
        XCTAssertEqual(result, 251.32741228718345, accuracy: 0.01, "Failed: em_university_intensity_point_source solving for P")
    }

    func test_em_university_intensity_point_source_r() throws {
        let result = try sut.calculate(rule: "sqrt(P / (4 * 3.141592653589793 * I))", variables: ["I": 5.0, "P": 5.0])
        XCTAssertEqual(result, 0.28209479177387814, accuracy: 0.0028209479177387815, "Failed: em_university_intensity_point_source solving for r")
    }

    // MARK: - EM Wave Speed in Medium (em_university_em_wave_in_medium)

    func test_em_university_em_wave_in_medium_v() throws {
        let result = try sut.calculate(rule: "c / sqrt(epsilon * mu)", variables: ["c": 300000000.0, "epsilon": 5.0, "mu": 5.0])
        XCTAssertEqual(result, 60000000.0, accuracy: 60.0, "Failed: em_university_em_wave_in_medium solving for v")
    }

    func test_em_university_em_wave_in_medium_c() throws {
        let result = try sut.calculate(rule: "v * sqrt(epsilon * mu)", variables: ["v": 10.0, "epsilon": 5.0, "mu": 5.0])
        XCTAssertEqual(result, 50.0, accuracy: 0.01, "Failed: em_university_em_wave_in_medium solving for c")
    }

    func test_em_university_em_wave_in_medium_epsilon() throws {
        let result = try sut.calculate(rule: "c * c / (v * v * mu)", variables: ["v": 10.0, "c": 300000000.0, "mu": 5.0])
        XCTAssertEqual(result, 180000000000000.0, accuracy: 180000000.0, "Failed: em_university_em_wave_in_medium solving for epsilon")
    }

    func test_em_university_em_wave_in_medium_mu() throws {
        let result = try sut.calculate(rule: "c * c / (v * v * epsilon)", variables: ["v": 10.0, "c": 300000000.0, "epsilon": 5.0])
        XCTAssertEqual(result, 180000000000000.0, accuracy: 180000000.0, "Failed: em_university_em_wave_in_medium solving for mu")
    }

    // MARK: - Radiation Pressure (em_university_radiation_pressure)

    func test_em_university_radiation_pressure_p() throws {
        let result = try sut.calculate(rule: "I / c * (1 + rho)", variables: ["I": 300.0, "c": 300000000.0, "rho": 0.5])
        XCTAssertEqual(result, 1.5e-06, accuracy: 1.5000000000000002e-08, "Failed: em_university_radiation_pressure solving for p")
    }

    func test_em_university_radiation_pressure_I() throws {
        let result = try sut.calculate(rule: "p * c / (1 + rho)", variables: ["p": 1e-06, "c": 300000000.0, "rho": 0.5])
        XCTAssertEqual(result, 200.0, accuracy: 0.01, "Failed: em_university_radiation_pressure solving for I")
    }

    func test_em_university_radiation_pressure_c() throws {
        let result = try sut.calculate(rule: "I * (1 + rho) / p", variables: ["p": 1e-06, "I": 300.0, "rho": 0.5])
        XCTAssertEqual(result, 450000000.0, accuracy: 450.0, "Failed: em_university_radiation_pressure solving for c")
    }

    // SKIP: test_em_university_radiation_pressure_rho - extreme value: 0.0

    // MARK: - Mean Kinetic Energy of a Molecule (mol_mean_kinetic_energy)

    func test_mol_mean_kinetic_energy_Ek() throws {
        let result = try sut.calculate(rule: "(3/2) * k * T", variables: ["k": 1.381e-23, "T": 300.0])
        XCTAssertEqual(result, 6.2144999999999995e-21, accuracy: 6.2145e-23, "Failed: mol_mean_kinetic_energy solving for Ek")
    }

    func test_mol_mean_kinetic_energy_T() throws {
        let result = try sut.calculate(rule: "Ek / ((3/2) * k)", variables: ["Ek": 5.0, "k": 1.381e-23])
        XCTAssertEqual(result, 2.413709872073377e+23, accuracy: 2.413709872073377e+17, "Failed: mol_mean_kinetic_energy solving for T")
    }

    func test_mol_mean_kinetic_energy_k() throws {
        let result = try sut.calculate(rule: "Ek / ((3/2) * T)", variables: ["Ek": 5.0, "T": 300.0])
        XCTAssertEqual(result, 0.011111111111111112, accuracy: 0.00011111111111111112, "Failed: mol_mean_kinetic_energy solving for k")
    }

    // MARK: - Root-Mean-Square Speed (mol_rms_speed)

    func test_mol_rms_speed_vrms() throws {
        let result = try sut.calculate(rule: "function.sqrt(3 * R * T / M)", variables: ["R": 8.314, "T": 300.0, "M": 5.0])
        XCTAssertEqual(result, 38.68488076755569, accuracy: 0.01, "Failed: mol_rms_speed solving for vrms")
    }

    func test_mol_rms_speed_T() throws {
        let result = try sut.calculate(rule: "(vrms * vrms * M) / (3 * R)", variables: ["vrms": 10.0, "R": 8.314, "M": 5.0])
        XCTAssertEqual(result, 20.046507898324112, accuracy: 0.01, "Failed: mol_rms_speed solving for T")
    }

    func test_mol_rms_speed_M() throws {
        let result = try sut.calculate(rule: "(3 * R * T) / (vrms * vrms)", variables: ["vrms": 10.0, "R": 8.314, "T": 300.0])
        XCTAssertEqual(result, 74.82600000000001, accuracy: 0.01, "Failed: mol_rms_speed solving for M")
    }

    func test_mol_rms_speed_R() throws {
        let result = try sut.calculate(rule: "(vrms * vrms * M) / (3 * T)", variables: ["vrms": 10.0, "T": 300.0, "M": 5.0])
        XCTAssertEqual(result, 0.5555555555555556, accuracy: 0.005555555555555556, "Failed: mol_rms_speed solving for R")
    }

    // MARK: - Mean Free Path (mol_mean_free_path)

    func test_mol_mean_free_path_lam() throws {
        let result = try sut.calculate(rule: "(k * T) / (1.41421356 * 3.14159265 * d * d * P)", variables: ["k": 1.381e-23, "T": 300.0, "d": 5.0, "P": 101325.0])
        XCTAssertEqual(result, 3.6812341557958288e-28, accuracy: 3.681234155795829e-30, "Failed: mol_mean_free_path solving for lam")
    }

    func test_mol_mean_free_path_T() throws {
        let result = try sut.calculate(rule: "(lam * 1.41421356 * 3.14159265 * d * d * P) / k", variables: ["lam": 2.0, "k": 1.381e-23, "d": 5.0, "P": 101325.0])
        XCTAssertEqual(result, 1.6298881695839551e+30, accuracy: 1.629888169583955e+24, "Failed: mol_mean_free_path solving for T")
    }

    func test_mol_mean_free_path_P() throws {
        let result = try sut.calculate(rule: "(k * T) / (1.41421356 * 3.14159265 * d * d * lam)", variables: ["lam": 2.0, "k": 1.381e-23, "T": 300.0, "d": 5.0])
        XCTAssertEqual(result, 1.8650052541800618e-23, accuracy: 1.8650052541800618e-25, "Failed: mol_mean_free_path solving for P")
    }

    func test_mol_mean_free_path_d() throws {
        let result = try sut.calculate(rule: "function.sqrt((k * T) / (1.41421356 * 3.14159265 * lam * P))", variables: ["lam": 2.0, "k": 1.381e-23, "T": 300.0, "P": 101325.0])
        XCTAssertEqual(result, 6.783467177443101e-14, accuracy: 6.783467177443101e-16, "Failed: mol_mean_free_path solving for d")
    }

    func test_mol_mean_free_path_k() throws {
        let result = try sut.calculate(rule: "(lam * 1.41421356 * 3.14159265 * d * d * P) / T", variables: ["lam": 2.0, "T": 300.0, "d": 5.0, "P": 101325.0])
        XCTAssertEqual(result, 75029.18540651473, accuracy: 0.01, "Failed: mol_mean_free_path solving for k")
    }

    // MARK: - Molecular Concentration (mol_concentration)

    func test_mol_concentration_n() throws {
        let result = try sut.calculate(rule: "P / (k * T)", variables: ["P": 101325.0, "k": 1.381e-23, "T": 300.0])
        XCTAssertEqual(result, 2.4456915278783493e+25, accuracy: 2.4456915278783492e+19, "Failed: mol_concentration solving for n")
    }

    func test_mol_concentration_P() throws {
        let result = try sut.calculate(rule: "n * k * T", variables: ["n": 5.0, "k": 1.381e-23, "T": 300.0])
        XCTAssertEqual(result, 2.0715e-20, accuracy: 2.0715e-22, "Failed: mol_concentration solving for P")
    }

    func test_mol_concentration_T() throws {
        let result = try sut.calculate(rule: "P / (n * k)", variables: ["n": 5.0, "P": 101325.0, "k": 1.381e-23])
        XCTAssertEqual(result, 1.4674149167270094e+27, accuracy: 1.4674149167270094e+21, "Failed: mol_concentration solving for T")
    }

    func test_mol_concentration_k() throws {
        let result = try sut.calculate(rule: "P / (n * T)", variables: ["n": 5.0, "P": 101325.0, "T": 300.0])
        XCTAssertEqual(result, 67.55, accuracy: 0.01, "Failed: mol_concentration solving for k")
    }

    // MARK: - Bohr Orbit Radius (atomic_bohr_radius)

    func test_atomic_bohr_radius_rn() throws {
        let result = try sut.calculate(rule: "a0 * n * n", variables: ["a0": 5.29e-11, "n": 3.0])
        XCTAssertEqual(result, 4.761e-10, accuracy: 4.7610000000000004e-12, "Failed: atomic_bohr_radius solving for rn")
    }

    func test_atomic_bohr_radius_n() throws {
        let result = try sut.calculate(rule: "function.sqrt(rn / a0)", variables: ["rn": 5.0, "a0": 5.29e-11])
        XCTAssertEqual(result, 307437.7309506728, accuracy: 0.01, "Failed: atomic_bohr_radius solving for n")
    }

    func test_atomic_bohr_radius_a0() throws {
        let result = try sut.calculate(rule: "rn / (n * n)", variables: ["rn": 5.0, "n": 3.0])
        XCTAssertEqual(result, 0.5555555555555556, accuracy: 0.005555555555555556, "Failed: atomic_bohr_radius solving for a0")
    }

    // MARK: - Hydrogen Atom Energy Level (atomic_hydrogen_energy)

    func test_atomic_hydrogen_energy_En() throws {
        let result = try sut.calculate(rule: "-13.6 / (n * n)", variables: ["n": 3.0])
        XCTAssertEqual(result, -1.511111111111111, accuracy: 0.01, "Failed: atomic_hydrogen_energy solving for En")
    }

    func test_atomic_hydrogen_energy_n() throws {
        let result = try sut.calculate(rule: "function.sqrt(-13.6 / En)", variables: ["En": -1.511])
        XCTAssertEqual(result, 3.000110300200416, accuracy: 0.01, "Failed: atomic_hydrogen_energy solving for n")
    }

    // MARK: - Rydberg Formula (atomic_rydberg)

    func test_atomic_rydberg_lam() throws {
        let result = try sut.calculate(rule: "1 / (Rinf * (1/(n1*n1) - 1/(n2*n2)))", variables: ["Rinf": 10970000.0, "n1": 2.0, "n2": 3.0])
        XCTAssertEqual(result, 6.563354603463993e-07, accuracy: 6.563354603463993e-09, "Failed: atomic_rydberg solving for lam")
    }

    func test_atomic_rydberg_n1() throws {
        let result = try sut.calculate(rule: "function.sqrt(1 / (1/(n2*n2) + 1/(Rinf * lam)))", variables: ["lam": 6.563e-07, "Rinf": 10970000.0, "n2": 3.0])
        XCTAssertEqual(result, 1.9999699836218974, accuracy: 0.01, "Failed: atomic_rydberg solving for n1")
    }

    func test_atomic_rydberg_n2() throws {
        let result = try sut.calculate(rule: "function.sqrt(1 / (1/(n1*n1) - 1/(Rinf * lam)))", variables: ["lam": 6.563e-07, "Rinf": 10970000.0, "n1": 2.0])
        XCTAssertEqual(result, 3.000101312688655, accuracy: 0.01, "Failed: atomic_rydberg solving for n2")
    }

    func test_atomic_rydberg_Rinf() throws {
        let result = try sut.calculate(rule: "1 / (lam * (1/(n1*n1) - 1/(n2*n2)))", variables: ["lam": 6.563e-07, "n1": 2.0, "n2": 3.0])
        XCTAssertEqual(result, 10970592.71674539, accuracy: 10.970592716745388, "Failed: atomic_rydberg solving for Rinf")
    }

    // MARK: - de Broglie Wavelength (atomic_de_broglie)

    func test_atomic_de_broglie_lam() throws {
        let result = try sut.calculate(rule: "h / (m * v)", variables: ["h": 6.626e-34, "m": 9.109e-31, "v": 7274000.0])
        XCTAssertEqual(result, 1.0000171146907345e-10, accuracy: 1.0000171146907345e-12, "Failed: atomic_de_broglie solving for lam")
    }

    func test_atomic_de_broglie_m() throws {
        let result = try sut.calculate(rule: "h / (lam * v)", variables: ["lam": 1e-10, "h": 6.626e-34, "v": 7274000.0])
        XCTAssertEqual(result, 9.109155897717899e-31, accuracy: 9.109155897717899e-33, "Failed: atomic_de_broglie solving for m")
    }

    func test_atomic_de_broglie_v() throws {
        let result = try sut.calculate(rule: "h / (lam * m)", variables: ["lam": 1e-10, "h": 6.626e-34, "m": 9.109e-31])
        XCTAssertEqual(result, 7274124.492260402, accuracy: 7.274124492260402, "Failed: atomic_de_broglie solving for v")
    }

    func test_atomic_de_broglie_h() throws {
        let result = try sut.calculate(rule: "lam * m * v", variables: ["lam": 1e-10, "m": 9.109e-31, "v": 7274000.0])
        XCTAssertEqual(result, 6.6258865999999995e-34, accuracy: 6.6258866e-36, "Failed: atomic_de_broglie solving for h")
    }

    // MARK: - Critical Temperature (real_gas_critical_temp)

    func test_real_gas_critical_temp_Tc() throws {
        let result = try sut.calculate(rule: "(8 * a) / (27 * R * b)", variables: ["a": 0.3658, "R": 8.314, "b": 4.286e-05])
        XCTAssertEqual(result, 304.16394832610405, accuracy: 0.01, "Failed: real_gas_critical_temp solving for Tc")
    }

    func test_real_gas_critical_temp_a() throws {
        let result = try sut.calculate(rule: "(Tc * 27 * R * b) / 8", variables: ["Tc": 400.0, "R": 8.314, "b": 4.286e-05])
        XCTAssertEqual(result, 0.48105635399999996, accuracy: 0.00481056354, "Failed: real_gas_critical_temp solving for a")
    }

    func test_real_gas_critical_temp_b() throws {
        let result = try sut.calculate(rule: "(8 * a) / (27 * R * Tc)", variables: ["Tc": 400.0, "a": 0.3658, "R": 8.314])
        XCTAssertEqual(result, 3.259116706314205e-05, accuracy: 3.259116706314205e-07, "Failed: real_gas_critical_temp solving for b")
    }

    func test_real_gas_critical_temp_R() throws {
        let result = try sut.calculate(rule: "(8 * a) / (27 * Tc * b)", variables: ["Tc": 400.0, "a": 0.3658, "b": 4.286e-05])
        XCTAssertEqual(result, 6.322047665958072, accuracy: 0.01, "Failed: real_gas_critical_temp solving for R")
    }

    // MARK: - Critical Pressure (real_gas_critical_pressure)

    func test_real_gas_critical_pressure_Pc() throws {
        let result = try sut.calculate(rule: "a / (27 * b * b)", variables: ["a": 0.3658, "b": 4.286e-05])
        XCTAssertEqual(result, 7375230.594911423, accuracy: 7.3752305949114225, "Failed: real_gas_critical_pressure solving for Pc")
    }

    func test_real_gas_critical_pressure_a() throws {
        let result = try sut.calculate(rule: "Pc * 27 * b * b", variables: ["Pc": 3650000.0, "b": 4.286e-05])
        XCTAssertEqual(result, 0.18103433958, accuracy: 0.0018103433958, "Failed: real_gas_critical_pressure solving for a")
    }

    func test_real_gas_critical_pressure_b() throws {
        let result = try sut.calculate(rule: "function.sqrt(a / (27 * Pc))", variables: ["Pc": 3650000.0, "a": 0.3658])
        XCTAssertEqual(result, 6.0924719206997974e-05, accuracy: 6.092471920699798e-07, "Failed: real_gas_critical_pressure solving for b")
    }

    // MARK: - Reynolds Number (fluid_dyn_reynolds)

    func test_fluid_dyn_reynolds_Re() throws {
        let result = try sut.calculate(rule: "(rho * v * L) / mu", variables: ["rho": 1000.0, "v": 10.0, "L": 2.0, "mu": 0.001])
        XCTAssertEqual(result, 20000000.0, accuracy: 20.0, "Failed: fluid_dyn_reynolds solving for Re")
    }

    func test_fluid_dyn_reynolds_v() throws {
        let result = try sut.calculate(rule: "(Re * mu) / (rho * L)", variables: ["Re": 5.0, "rho": 1000.0, "L": 2.0, "mu": 0.001])
        XCTAssertEqual(result, 2.5e-06, accuracy: 2.5000000000000002e-08, "Failed: fluid_dyn_reynolds solving for v")
    }

    func test_fluid_dyn_reynolds_rho() throws {
        let result = try sut.calculate(rule: "(Re * mu) / (v * L)", variables: ["Re": 5.0, "v": 10.0, "L": 2.0, "mu": 0.001])
        XCTAssertEqual(result, 0.00025, accuracy: 2.5e-06, "Failed: fluid_dyn_reynolds solving for rho")
    }

    func test_fluid_dyn_reynolds_L() throws {
        let result = try sut.calculate(rule: "(Re * mu) / (rho * v)", variables: ["Re": 5.0, "rho": 1000.0, "v": 10.0, "mu": 0.001])
        XCTAssertEqual(result, 5e-07, accuracy: 5e-09, "Failed: fluid_dyn_reynolds solving for L")
    }

    func test_fluid_dyn_reynolds_mu() throws {
        let result = try sut.calculate(rule: "(rho * v * L) / Re", variables: ["Re": 5.0, "rho": 1000.0, "v": 10.0, "L": 2.0])
        XCTAssertEqual(result, 4000.0, accuracy: 0.01, "Failed: fluid_dyn_reynolds solving for mu")
    }

    // MARK: - Stokes' Drag Force (fluid_dyn_stokes)

    func test_fluid_dyn_stokes_F() throws {
        let result = try sut.calculate(rule: "6 * 3.14159265 * mu * r * v", variables: ["mu": 0.001, "r": 5.0, "v": 10.0])
        XCTAssertEqual(result, 0.9424777950000002, accuracy: 0.009424777950000003, "Failed: fluid_dyn_stokes solving for F")
    }

    func test_fluid_dyn_stokes_mu() throws {
        let result = try sut.calculate(rule: "F / (6 * 3.14159265 * r * v)", variables: ["F": 5.0, "r": 5.0, "v": 10.0])
        XCTAssertEqual(result, 0.00530516477579188, accuracy: 5.30516477579188e-05, "Failed: fluid_dyn_stokes solving for mu")
    }

    func test_fluid_dyn_stokes_r() throws {
        let result = try sut.calculate(rule: "F / (6 * 3.14159265 * mu * v)", variables: ["F": 5.0, "mu": 0.001, "v": 10.0])
        XCTAssertEqual(result, 26.525823878959393, accuracy: 0.01, "Failed: fluid_dyn_stokes solving for r")
    }

    func test_fluid_dyn_stokes_v() throws {
        let result = try sut.calculate(rule: "F / (6 * 3.14159265 * mu * r)", variables: ["F": 5.0, "mu": 0.001, "r": 5.0])
        XCTAssertEqual(result, 53.051647757918786, accuracy: 0.01, "Failed: fluid_dyn_stokes solving for v")
    }

    // MARK: - Poiseuille's Law (fluid_dyn_poiseuille)

    func test_fluid_dyn_poiseuille_Q() throws {
        let result = try sut.calculate(rule: "(3.14159265 * r * r * r * r * dP) / (8 * mu * L)", variables: ["r": 0.001, "dP": 1000.0, "mu": 0.001, "L": 0.1])
        XCTAssertEqual(result, 3.9269908125e-06, accuracy: 3.9269908125000004e-08, "Failed: fluid_dyn_poiseuille solving for Q")
    }

    func test_fluid_dyn_poiseuille_dP() throws {
        let result = try sut.calculate(rule: "(Q * 8 * mu * L) / (3.14159265 * r * r * r * r)", variables: ["Q": 1e-06, "r": 0.001, "mu": 0.001, "L": 0.1])
        XCTAssertEqual(result, 254.64790923801021, accuracy: 0.01, "Failed: fluid_dyn_poiseuille solving for dP")
    }

    func test_fluid_dyn_poiseuille_mu() throws {
        let result = try sut.calculate(rule: "(3.14159265 * r * r * r * r * dP) / (8 * Q * L)", variables: ["Q": 1e-06, "r": 0.001, "dP": 1000.0, "L": 0.1])
        XCTAssertEqual(result, 0.0039269908125000004, accuracy: 3.9269908125e-05, "Failed: fluid_dyn_poiseuille solving for mu")
    }

    func test_fluid_dyn_poiseuille_L() throws {
        let result = try sut.calculate(rule: "(3.14159265 * r * r * r * r * dP) / (8 * mu * Q)", variables: ["Q": 1e-06, "r": 0.001, "dP": 1000.0, "mu": 0.001])
        XCTAssertEqual(result, 0.39269908125, accuracy: 0.0039269908125000004, "Failed: fluid_dyn_poiseuille solving for L")
    }

    func test_fluid_dyn_poiseuille_r() throws {
        let result = try sut.calculate(rule: "function.pow((8 * mu * L * Q) / (3.14159265 * dP), 0.25)", variables: ["Q": 1e-06, "dP": 1000.0, "mu": 0.001, "L": 0.1])
        XCTAssertEqual(result, 0.0007103706811885904, accuracy: 7.103706811885905e-06, "Failed: fluid_dyn_poiseuille solving for r")
    }

    // MARK: - Optical Power of a Lens (optics_optical_power)

    func test_optics_optical_power_D() throws {
        let result = try sut.calculate(rule: "1 / F", variables: ["F": 2.0])
        XCTAssertEqual(result, 0.5, accuracy: 0.005, "Failed: optics_optical_power solving for D")
    }

    func test_optics_optical_power_F() throws {
        let result = try sut.calculate(rule: "1 / D", variables: ["D": 5.0])
        XCTAssertEqual(result, 0.2, accuracy: 0.002, "Failed: optics_optical_power solving for F")
    }

    // MARK: - Total Internal Reflection (optics_total_internal_reflection)

    func test_optics_total_internal_reflection_thetac() throws {
        let result = try sut.calculate(rule: "function.asin(n2 / n1)", variables: ["n1": 1.5, "n2": 1.0])
        XCTAssertEqual(result, 0.7297276562269663, accuracy: 0.007297276562269663, "Failed: optics_total_internal_reflection solving for thetac")
    }

    func test_optics_total_internal_reflection_n2() throws {
        let result = try sut.calculate(rule: "n1 * function.sin(thetac)", variables: ["thetac": 0.5, "n1": 1.5])
        XCTAssertEqual(result, 0.7191383079063045, accuracy: 0.007191383079063045, "Failed: optics_total_internal_reflection solving for n2")
    }

    func test_optics_total_internal_reflection_n1() throws {
        let result = try sut.calculate(rule: "n2 / function.sin(thetac)", variables: ["thetac": 0.5, "n2": 1.0])
        XCTAssertEqual(result, 2.085829642933488, accuracy: 0.01, "Failed: optics_total_internal_reflection solving for n1")
    }

    // MARK: - Lens Magnification (optics_magnification)

    func test_optics_magnification_G() throws {
        let result = try sut.calculate(rule: "f / d", variables: ["f": 2.0, "d": 2.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: optics_magnification solving for G")
    }

    func test_optics_magnification_f() throws {
        let result = try sut.calculate(rule: "G * d", variables: ["G": 6.674e-11, "d": 2.0])
        XCTAssertEqual(result, 1.3348e-10, accuracy: 1.3348e-12, "Failed: optics_magnification solving for f")
    }

    func test_optics_magnification_d() throws {
        let result = try sut.calculate(rule: "f / G", variables: ["G": 6.674e-11, "f": 2.0])
        XCTAssertEqual(result, 29967036260.113876, accuracy: 29967.036260113877, "Failed: optics_magnification solving for d")
    }

    // MARK: - Malus's Law (optics_malus_law)

    func test_optics_malus_law_I() throws {
        let result = try sut.calculate(rule: "I0 * function.cos(theta) * function.cos(theta)", variables: ["I0": 100.0, "theta": 0.8])
        XCTAssertEqual(result, 48.54002388493556, accuracy: 0.01, "Failed: optics_malus_law solving for I")
    }

    func test_optics_malus_law_I0() throws {
        let result = try sut.calculate(rule: "I / (function.cos(theta) * function.cos(theta))", variables: ["I": 48.54002388493556, "theta": 0.8])
        XCTAssertEqual(result, 100.0, accuracy: 0.01, "Failed: optics_malus_law solving for I0")
    }

    func test_optics_malus_law_theta() throws {
        let result = try sut.calculate(rule: "function.acos(function.sqrt(I / I0))", variables: ["I": 48.54002388493556, "I0": 100.0])
        XCTAssertEqual(result, 0.8, accuracy: 0.008, "Failed: optics_malus_law solving for theta")
    }

    // MARK: - Brewster's Angle (optics_brewster_angle)

    func test_optics_brewster_angle_thetaB() throws {
        let result = try sut.calculate(rule: "function.atan(n2 / n1)", variables: ["n1": 1.5, "n2": 1.0])
        XCTAssertEqual(result, 0.5880026035475675, accuracy: 0.005880026035475675, "Failed: optics_brewster_angle solving for thetaB")
    }

    func test_optics_brewster_angle_n2() throws {
        let result = try sut.calculate(rule: "n1 * function.tan(thetaB)", variables: ["thetaB": 0.5, "n1": 1.5])
        XCTAssertEqual(result, 0.8194537347656857, accuracy: 0.008194537347656858, "Failed: optics_brewster_angle solving for n2")
    }

    func test_optics_brewster_angle_n1() throws {
        let result = try sut.calculate(rule: "n2 / function.tan(thetaB)", variables: ["thetaB": 0.5, "n2": 1.0])
        XCTAssertEqual(result, 1.830487721712452, accuracy: 0.01, "Failed: optics_brewster_angle solving for n1")
    }

    // MARK: - Wien's Displacement Law (optics_wien_law)

    func test_optics_wien_law_lamMax() throws {
        let result = try sut.calculate(rule: "bw / T", variables: ["bw": 0.002898, "T": 300.0])
        XCTAssertEqual(result, 9.66e-06, accuracy: 9.66e-08, "Failed: optics_wien_law solving for lamMax")
    }

    func test_optics_wien_law_T() throws {
        let result = try sut.calculate(rule: "bw / lamMax", variables: ["lamMax": 2.0, "bw": 0.002898])
        XCTAssertEqual(result, 0.001449, accuracy: 1.449e-05, "Failed: optics_wien_law solving for T")
    }

    func test_optics_wien_law_bw() throws {
        let result = try sut.calculate(rule: "lamMax * T", variables: ["lamMax": 2.0, "T": 300.0])
        XCTAssertEqual(result, 600.0, accuracy: 0.01, "Failed: optics_wien_law solving for bw")
    }

    // MARK: - Stefan-Boltzmann Law (optics_stefan_boltzmann)

    func test_optics_stefan_boltzmann_P() throws {
        let result = try sut.calculate(rule: "sigma * A * T * T * T * T", variables: ["sigma": 5.67e-08, "A": 5.0, "T": 300.0])
        XCTAssertEqual(result, 2296.3500000000004, accuracy: 0.01, "Failed: optics_stefan_boltzmann solving for P")
    }

    func test_optics_stefan_boltzmann_T() throws {
        let result = try sut.calculate(rule: "function.pow(P / (sigma * A), 0.25)", variables: ["P": 5.0, "sigma": 5.67e-08, "A": 5.0])
        XCTAssertEqual(result, 64.8043613937988, accuracy: 0.01, "Failed: optics_stefan_boltzmann solving for T")
    }

    func test_optics_stefan_boltzmann_A() throws {
        let result = try sut.calculate(rule: "P / (sigma * T * T * T * T)", variables: ["P": 5.0, "sigma": 5.67e-08, "T": 300.0])
        XCTAssertEqual(result, 0.010886842162562329, accuracy: 0.00010886842162562329, "Failed: optics_stefan_boltzmann solving for A")
    }

    func test_optics_stefan_boltzmann_sigma() throws {
        let result = try sut.calculate(rule: "P / (A * T * T * T * T)", variables: ["P": 5.0, "A": 5.0, "T": 300.0])
        XCTAssertEqual(result, 1.2345679012345679e-10, accuracy: 1.234567901234568e-12, "Failed: optics_stefan_boltzmann solving for sigma")
    }

    // MARK: - Radioactive Activity (nuclear_activity)

    func test_nuclear_activity_Ac() throws {
        let result = try sut.calculate(rule: "(0.693147 * N) / Thalf", variables: ["N": 1000000000000000.0, "Thalf": 693100000.0])
        XCTAssertEqual(result, 1000067.8112826432, accuracy: 1.000067811282643, "Failed: nuclear_activity solving for Ac")
    }

    func test_nuclear_activity_N() throws {
        let result = try sut.calculate(rule: "(Ac * Thalf) / 0.693147", variables: ["Ac": 1000000.0, "Thalf": 693100000.0])
        XCTAssertEqual(result, 999932193315415.1, accuracy: 999932193.315415, "Failed: nuclear_activity solving for N")
    }

    func test_nuclear_activity_Thalf() throws {
        let result = try sut.calculate(rule: "(0.693147 * N) / Ac", variables: ["Ac": 1000000.0, "N": 1000000000000000.0])
        XCTAssertEqual(result, 693147000.0, accuracy: 693.1469999999999, "Failed: nuclear_activity solving for Thalf")
    }

    // MARK: - Binding Energy per Nucleon (nuclear_binding_energy_per_nucleon)

    func test_nuclear_binding_energy_per_nucleon_eps() throws {
        let result = try sut.calculate(rule: "Eb / Anuc", variables: ["Eb": 5.0, "Anuc": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: nuclear_binding_energy_per_nucleon solving for eps")
    }

    func test_nuclear_binding_energy_per_nucleon_Eb() throws {
        let result = try sut.calculate(rule: "eps * Anuc", variables: ["eps": 5.0, "Anuc": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: nuclear_binding_energy_per_nucleon solving for Eb")
    }

    func test_nuclear_binding_energy_per_nucleon_Anuc() throws {
        let result = try sut.calculate(rule: "Eb / eps", variables: ["eps": 5.0, "Eb": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: nuclear_binding_energy_per_nucleon solving for Anuc")
    }

    // MARK: - Torque (Moment of Force) (statics_moment_of_force)

    func test_statics_moment_of_force_M() throws {
        let result = try sut.calculate(rule: "F * d", variables: ["F": 5.0, "d": 5.0])
        XCTAssertEqual(result, 25.0, accuracy: 0.01, "Failed: statics_moment_of_force solving for M")
    }

    func test_statics_moment_of_force_F() throws {
        let result = try sut.calculate(rule: "M / d", variables: ["M": 5.0, "d": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: statics_moment_of_force solving for F")
    }

    func test_statics_moment_of_force_d() throws {
        let result = try sut.calculate(rule: "M / F", variables: ["M": 5.0, "F": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: statics_moment_of_force solving for d")
    }

    // MARK: - Lever Rule (statics_lever_rule)

    func test_statics_lever_rule_F1() throws {
        let result = try sut.calculate(rule: "(F2 * l2) / l1", variables: ["l1": 5.0, "F2": 5.0, "l2": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: statics_lever_rule solving for F1")
    }

    func test_statics_lever_rule_l1() throws {
        let result = try sut.calculate(rule: "(F2 * l2) / F1", variables: ["F1": 5.0, "F2": 5.0, "l2": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: statics_lever_rule solving for l1")
    }

    func test_statics_lever_rule_F2() throws {
        let result = try sut.calculate(rule: "(F1 * l1) / l2", variables: ["F1": 5.0, "l1": 5.0, "l2": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: statics_lever_rule solving for F2")
    }

    func test_statics_lever_rule_l2() throws {
        let result = try sut.calculate(rule: "(F1 * l1) / F2", variables: ["F1": 5.0, "l1": 5.0, "F2": 5.0])
        XCTAssertEqual(result, 5.0, accuracy: 0.01, "Failed: statics_lever_rule solving for l2")
    }

    // MARK: - Pressure (statics_pressure)

    func test_statics_pressure_P() throws {
        let result = try sut.calculate(rule: "F / S", variables: ["F": 5.0, "S": 5.0])
        XCTAssertEqual(result, 1.0, accuracy: 0.01, "Failed: statics_pressure solving for P")
    }

    func test_statics_pressure_F() throws {
        let result = try sut.calculate(rule: "P * S", variables: ["P": 101325.0, "S": 5.0])
        XCTAssertEqual(result, 506625.0, accuracy: 0.01, "Failed: statics_pressure solving for F")
    }

    func test_statics_pressure_S() throws {
        let result = try sut.calculate(rule: "F / P", variables: ["P": 101325.0, "F": 5.0])
        XCTAssertEqual(result, 4.934616333580064e-05, accuracy: 4.934616333580064e-07, "Failed: statics_pressure solving for S")
    }

}