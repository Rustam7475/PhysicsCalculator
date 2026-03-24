import XCTest
@testable import PhysicsCalculator

final class UnitConverterTests: XCTestCase {
    
    // MARK: - Category Data Tests
    
    func testAllCategories_HaveAtLeastTwoUnits() {
        for category in UnitCategory.all {
            XCTAssertGreaterThanOrEqual(category.units.count, 2,
                "Category \(category.id) should have at least 2 units")
        }
    }
    
    func testAllCategories_HaveUniqueIds() {
        let ids = UnitCategory.all.map(\.id)
        XCTAssertEqual(ids.count, Set(ids).count, "Category IDs should be unique")
    }
    
    func testAllCategories_HaveLocalizedNames() {
        for category in UnitCategory.all {
            XCTAssertFalse(category.nameRu.isEmpty, "\(category.id) missing Russian name")
            XCTAssertFalse(category.nameEn.isEmpty, "\(category.id) missing English name")
            XCTAssertFalse(category.nameDe.isEmpty, "\(category.id) missing German name")
            XCTAssertFalse(category.nameEs.isEmpty, "\(category.id) missing Spanish name")
            XCTAssertFalse(category.nameFr.isEmpty, "\(category.id) missing French name")
            XCTAssertFalse(category.nameZh.isEmpty, "\(category.id) missing Chinese name")
        }
    }
    
    func testAllUnits_HaveLocalizedNames() {
        for category in UnitCategory.all {
            for unit in category.units {
                XCTAssertFalse(unit.nameRu.isEmpty, "\(unit.symbol) missing Russian name")
                XCTAssertFalse(unit.nameEn.isEmpty, "\(unit.symbol) missing English name")
            }
        }
    }
    
    func testAllUnits_HavePositiveToSI() {
        for category in UnitCategory.all {
            if category.id == "temperature" { continue }
            for unit in category.units {
                XCTAssertGreaterThan(unit.toSI, 0, "\(unit.symbol) should have positive toSI factor")
            }
        }
    }
    
    func testCategoryCount() {
        XCTAssertEqual(UnitCategory.all.count, 13)
    }
    
    // MARK: - Length Conversion Tests
    
    func testKilometerToMeter() {
        let km = UnitCategory.length.units.first { $0.symbol == "км" }!
        let m = UnitCategory.length.units.first { $0.symbol == "м" }!
        let result = (1.0 * km.toSI) / m.toSI
        XCTAssertEqual(result, 1000.0, accuracy: 0.001)
    }
    
    func testMileToKilometer() {
        let mi = UnitCategory.length.units.first { $0.symbol == "mi" }!
        let km = UnitCategory.length.units.first { $0.symbol == "км" }!
        let result = (1.0 * mi.toSI) / km.toSI
        XCTAssertEqual(result, 1.609344, accuracy: 0.001)
    }
    
    func testFootToMeter() {
        let ft = UnitCategory.length.units.first { $0.symbol == "ft" }!
        let m = UnitCategory.length.units.first { $0.symbol == "м" }!
        let result = (1.0 * ft.toSI) / m.toSI
        XCTAssertEqual(result, 0.3048, accuracy: 0.0001)
    }
    
    // MARK: - Mass Conversion Tests
    
    func testKilogramToGram() {
        let kg = UnitCategory.mass.units.first { $0.symbol == "кг" }!
        let g = UnitCategory.mass.units.first { $0.symbol == "г" }!
        let result = (1.0 * kg.toSI) / g.toSI
        XCTAssertEqual(result, 1000.0, accuracy: 0.001)
    }
    
    func testPoundToKilogram() {
        let lb = UnitCategory.mass.units.first { $0.symbol == "lb" }!
        let kg = UnitCategory.mass.units.first { $0.symbol == "кг" }!
        let result = (1.0 * lb.toSI) / kg.toSI
        XCTAssertEqual(result, 0.453592, accuracy: 0.001)
    }
    
    // MARK: - Energy Conversion Tests
    
    func testJouleToCalorie() {
        let j = UnitCategory.energy.units.first { $0.symbol == "Дж" }!
        let cal = UnitCategory.energy.units.first { $0.symbol == "кал" }!
        let result = (1.0 * j.toSI) / cal.toSI
        XCTAssertEqual(result, 1.0 / 4.184, accuracy: 0.001)
    }
    
    func testKWhToJoule() {
        let kwh = UnitCategory.energy.units.first { $0.symbol == "кВт·ч" }!
        let j = UnitCategory.energy.units.first { $0.symbol == "Дж" }!
        let result = (1.0 * kwh.toSI) / j.toSI
        XCTAssertEqual(result, 3.6e6, accuracy: 1.0)
    }
    
    // MARK: - Pressure Conversion Tests
    
    func testAtmosphereToPascal() {
        let atm = UnitCategory.pressure.units.first { $0.symbol == "атм" }!
        let pa = UnitCategory.pressure.units.first { $0.symbol == "Па" }!
        let result = (1.0 * atm.toSI) / pa.toSI
        XCTAssertEqual(result, 101325.0, accuracy: 1.0)
    }
    
    func testBarToAtmosphere() {
        let bar = UnitCategory.pressure.units.first { $0.symbol == "бар" }!
        let atm = UnitCategory.pressure.units.first { $0.symbol == "атм" }!
        let result = (1.0 * bar.toSI) / atm.toSI
        XCTAssertEqual(result, 100000.0 / 101325.0, accuracy: 0.001)
    }
    
    // MARK: - Speed Conversion Tests
    
    func testKmhToMs() {
        let kmh = UnitCategory.speed.units.first { $0.symbol == "км/ч" }!
        let ms = UnitCategory.speed.units.first { $0.symbol == "м/с" }!
        let result = (36.0 * kmh.toSI) / ms.toSI
        XCTAssertEqual(result, 10.0, accuracy: 0.001)
    }
    
    // MARK: - Time Conversion Tests
    
    func testHourToSecond() {
        let h = UnitCategory.time.units.first { $0.symbol == "ч" }!
        let s = UnitCategory.time.units.first { $0.symbol == "с" }!
        let result = (1.0 * h.toSI) / s.toSI
        XCTAssertEqual(result, 3600.0, accuracy: 0.001)
    }
    
    // MARK: - Frequency Tests
    
    func testMHzToHz() {
        let mhz = UnitCategory.frequency.units.first { $0.symbol == "МГц" }!
        let hz = UnitCategory.frequency.units.first { $0.symbol == "Гц" }!
        let result = (1.0 * mhz.toSI) / hz.toSI
        XCTAssertEqual(result, 1e6, accuracy: 1.0)
    }
    
    // MARK: - Identity Tests (SI to SI)
    
    func testIdentityConversion() {
        for category in UnitCategory.all {
            if category.id == "temperature" { continue }
            let siUnit = category.units[0] // first unit is SI base
            let result = (42.0 * siUnit.toSI) / siUnit.toSI
            XCTAssertEqual(result, 42.0, accuracy: 0.0001,
                "\(category.id) identity conversion failed")
        }
    }
}
