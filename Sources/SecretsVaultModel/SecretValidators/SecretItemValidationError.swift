import Foundation

public enum SecretItemValidationError: Error {

    case emptySecretValue
    case invalidFlagFormat

    public var description: String {
        switch self {
        case .emptySecretValue:
            "Secret value cannot be empty."
        case .invalidFlagFormat:
            "Invalid flag format. Flags should not contain whitespace."
        }
    }
}
