import Foundation 

enum FileError: Error {
    case customError(String)
}

enum GradeError: Error {
    case wrongGradesCount
    case emptyArray
}