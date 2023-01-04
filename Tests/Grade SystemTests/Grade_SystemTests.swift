import XCTest
@testable import Grade_System

final class Grade_SystemTests: XCTestCase {
    func testGrade() throws {
        XCTAssertNil(Grades(rawValue: 650))
        XCTAssertNotNil(Grades(rawValue: 43))
        XCTAssertNotNil(Grades(rawValue: "E"))
        XCTAssertNil(Grades(rawValue: "h"))
    }
    func testGradeCalc() throws {
        XCTAssertThrowsError(try GradeCalc.calculateGrade(of: .English, with: [0, 54,256,737,42]))
        let historygrade = try GradeCalc.calculateGrade(of: .History, with: [95, 76, 72, 88])
        XCTAssertEqual(Grades.B, historygrade.0)
        XCTAssertEqual(80.30, historygrade.1)
        XCTAssertNoThrow(try GradeCalc.calculateGrade(of: .English, with: [0, 737, 42]))
        XCTAssertThrowsError(try GradeCalc.calculateGrade(of: .Math, with: [95, 76, 72, 88, 45, 53, 24]))
        let mathgrade = try GradeCalc.calculateGrade(of: .Math, with: [95, 76, 72, 88, 45, 75, 53, 24])
        XCTAssertNotEqual(Grades.B, mathgrade.0)
        XCTAssertNotEqual(80.30, mathgrade.1)
    }
}
