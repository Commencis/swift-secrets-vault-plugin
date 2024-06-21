import Foundation

/// An enumeration representing possible validation errors for a secret item.
///
/// This enumeration defines the various errors that can occur when validating a secret item,
/// such as an empty secret value, an invalid flag format, or a duplicate flag.
public enum SecretItemValidationError: Error {

    /// Error indicating that the secret value is empty.
    case emptySecretValue

    /// Error indicating that the flag format is invalid.
    /// Flags should not contain whitespace.
    case invalidFlagFormat

    /// Error indicating that a duplicate flag has been found.
    case duplicateFlag

    /// A textual description of the validation error.
    ///
    /// This provides a human-readable description of the error that can be used for logging
    /// or displaying error messages to the user.
    public var description: String {
        switch self {
        case .emptySecretValue:
            "Secret value cannot be empty."
        case .invalidFlagFormat:
            "Invalid flag format. Flags should not contain whitespace."
        case .duplicateFlag:
            "Duplicate flag found. Each flag must be unique."
        }
    }
}

