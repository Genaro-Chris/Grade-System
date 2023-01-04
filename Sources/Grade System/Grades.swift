enum Grades: String {
    case A,B,C,D,E,F
    
    init?(rawValue: Float) {
        switch rawValue {
        case 0...49:
            self = .F
        case 50...59:
            self = .E
        case 60...69:
            self = .D
        case 70...79:
            self = .C
        case 80...89:
            self = .B
        case 90...100:
            self = .A
        default:
            return nil
        }
    }
}

enum GradeCalc {
    
    static func calculateGrade(of subject: Subjects, with list: [Float]) throws -> (Grades?, Float) {
        switch subject {
            case .English:
                guard list.count == 3 else {
                    throw GradeError.wrongGradesCount
                }
                let term_paper = (25 / 100) * list[0]
                let mid_term = (35 / 100) * list[1]
                let final_exam = (40 / 100) * list[2]
                let finalAvg = term_paper + mid_term + final_exam 
                return (Grades(rawValue: finalAvg), finalAvg)
            case .History:
                guard list.count == 4 else {
                    throw GradeError.wrongGradesCount
                }
                let attendance = (10 / 100) * list[0]
                let project = (30 / 100) * list[1]
                let mid_term = (30 / 100) * list[2]
                let final_exam = (30 / 100) * list[3]
                let finalAvg = attendance + project + mid_term + final_exam
                return (Grades(rawValue: finalAvg), finalAvg)
            case .Math:
                guard list.count == 8 else {
                    throw GradeError.wrongGradesCount
                }
                var quiz: Float = 0.0
                for grade in list[0...4]{
                    quiz += grade
                }
                quiz /= 5
                let quiz_average = (15 / 100) * quiz
                let test_1 = (25 / 100) * list[5]
                let test_2 = (25 / 100) * list[6]
                let final_exam = (35 / 100) * list[7]
                let finalAvg = quiz_average + test_1 + test_2 + final_exam
                return (Grades(rawValue: finalAvg), finalAvg)
        }       
    }
}