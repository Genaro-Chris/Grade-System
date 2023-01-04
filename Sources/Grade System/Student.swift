import Foundation


struct Student {
    var name: String
    let id = UUID().uuidString
    var grades: [Float]
    
    var finalExam: Float {
        grades.last!
    }
    var grade: Grades {
        get throws {
            let (grade, _) = try GradeCalc.calculateGrade(of: subject, with: grades)
            guard let grade else {
                return Grades.F
            }
            return grade
        }
        
    }
    var finalAverage: Float {
        get throws {
            let (_, finalAvg) = try GradeCalc.calculateGrade(of: subject, with: grades)
            return finalAvg
        }
        
    }
    let subject: Subjects
}

enum Subjects: String, CaseIterable {
    case English, History, Math
}

