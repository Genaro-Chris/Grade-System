import Foundation
import RegexBuilder

@main
public struct Grade_System {
    static var gradesDict: [Grades : Int] = [:]

    public static func main() async throws {
        print("Enter the input filename: ", terminator: "")
        guard let fileInput = readLine() else {
            throw FileError.customError("Input file must be supplied")
        }
        guard let data = FileManager.default.contents(atPath: fileInput),let fileString = String(data: data, encoding: .utf8) else {
            throw FileError.customError("Corrupted data")
        }
        let result = transform(fileString)
        let outputMsg = try process(result)
        print("Enter the output file: ", terminator: "")
        guard let outputFile = readLine() else {
            throw FileError.customError("Input file must be supplied")
        }
        try outputMsg.write(to: URL(fileURLWithPath: outputFile), atomically: true, encoding: .utf8)   
        print("Done :)", terminator: "")     
    }

    static func process(_ student_list: [Subjects: [Student]]) throws -> String {
        """
        Student Grade Summary
        ---------------------

        \( 
            try student_list.sorted { lhs, rhs in
                lhs.key.rawValue < rhs.key.rawValue
            }.map { val in 
                try summary_report(of: val.value, &gradesDict)
            }.reduce("") { initialResult, partialResult in
                initialResult + partialResult + "\n"
            }
        )
        OVERALL GRADE DISTRIBUTION

        \(
            gradesDict.sorted { lhs, rhs in
                lhs.key.rawValue < rhs.key.rawValue
            }.reduce("") { initialResult, partialResult in
                initialResult + "\(partialResult.key):    \(partialResult.value)\n"
            }
        )
        """
    }

    static func format(_ string: String) -> String {
        guard string.count == 42 else {
            return string + repeatElement(" ", count: 42 - string.count)
        }
        return string
    }

    static func transform(_ msg: String) -> [Subjects: [Student]] {
        var students = [Student]()
        var dict_of_subject_to_students: [Subjects: [Student]] = [:]        
        let regex = Regex {
            //Capture(#/[a-zA-Z]]+/#)
            ZeroOrMore(.digit)
            TryCapture {
                OneOrMore(.any, .reluctant)
            } transform: { value in
                value.split(separator: ",").map { value in
                    value.trimmingCharacters(in: .whitespaces)
                }.reversed().reduce("") { initialResult, partialResult in
                    initialResult + partialResult + " "  
                }.replacing("\n", with: "")
            }

            OneOrMore {
                .newlineSequence
            } 
            TryCapture {
                ChoiceOf {
                    Subjects.English.rawValue
                    Subjects.History.rawValue
                    Subjects.Math.rawValue
                } 
            } transform: { value in
                Subjects(rawValue: String(value))
            }
            OneOrMore {
                .whitespace
            }
            Capture { 
                OneOrMore(.any, .reluctant)
            } transform: { value in
                value.split(separator: " ").compactMap { value in
                    Float(value)
                }
            }
            OneOrMore(.newlineSequence)
        }
        let matches = msg.matches(of: regex) 
        for match in matches {
            students.append(Student(name: format(match.1), grades: match.3, subject: match.2))
        } 
        students.forEach { student in
            switch student.subject {
                case .English:
                    var existingValue = dict_of_subject_to_students[.English]
                    existingValue?.append(student)
                    dict_of_subject_to_students.updateValue(existingValue ?? [student], forKey: .English)
                case .History:
                    var existingValue = dict_of_subject_to_students[.History]
                    existingValue?.append(student)
                    dict_of_subject_to_students.updateValue(existingValue ?? [student], forKey: .History)
                case .Math:
                    var existingValue = dict_of_subject_to_students[.History]
                    existingValue?.append(student)
                    dict_of_subject_to_students.updateValue(existingValue ?? [student], forKey: .Math)
            }
        }
        return dict_of_subject_to_students
    }

    static func summary_report(of: [Student], _ gradesDict: inout [Grades: Int]) throws -> String {
        guard let student = of.first else {
            throw GradeError.emptyArray
        }
        var msg = ""
        switch student.subject {
        case .English: 
            msg += "\(student.subject.rawValue.capitalized) CLASS\n\n"
        case .History:
            msg += "\(student.subject.rawValue.capitalized) CLASS\n\n"
        case .Math:
            msg += "\(student.subject.rawValue.capitalized) CLASS\n\n"       
        }
        msg += 
        """
        Student                                   Final   Final   Letter
        Name                                      Exam    Avg     Grade
        -------------------------------------------------------------------------

        """
        try of.forEach { student in
            if let value = gradesDict[try student.grade] {
                gradesDict.updateValue(value + 1, forKey: try student.grade)
            } else {
                gradesDict[try student.grade] = 1
            }
            msg += 
            """
            \(format(student.name))\(student.finalExam)    \(String(format: "%.2f", try student.finalAverage))    \(try student.grade.rawValue)

            """
        }
        return msg
    }
}
