import Foundation

internal enum CommandError: Error {

    case unableToReadJSONFile(_ path: String)
    case unableToDecodeJSON(_ path: String)

    var description: String {
        switch self {
        case .unableToReadJSONFile(let path):
            "Unable to read JSON file at path: \(path)"
        case .unableToDecodeJSON(let path):
            "Unable to decode JSON file at path: \(path)"
        }
    }
}
