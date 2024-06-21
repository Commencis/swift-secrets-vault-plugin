import Foundation
import SecretsVaultUtility

/// An enumeration representing possible validation errors for a secret file.
///
/// This enumeration defines the various errors that can occur when validating a secret file,
/// such as having no secret declarations, an invalid secret declaration name, or multiple secret declarations sharing the same key.
public enum SecretFileValidationError: Error {

    /// Error indicating that no secret declaration is present.
    case noSecretDeclaration

    /// Error indicating that a secret declaration name is invalid.
    /// - Parameter declarationName: The name of the invalid declaration.
    case invalidSecretDeclarationName(_ declarationName: String)

    /// Error indicating that more than two secret declarations share the same key.
    /// - Parameter duplicateKeys: The list of duplicate keys.
    case moreThanTwoSecretDeclarationShareKey(_ duplicateKeys: [String])

    /// A textual description of the validation error.
    ///
    /// This provides a human-readable description of the error that can be used for logging
    /// or displaying error messages to the user.
    public var description: String {
        switch self {
        case .noSecretDeclaration:
            "Secret declaration list cannot be empty."
        case .invalidSecretDeclarationName(let declarationName):
            "Secret declaration name must be a valid declaration name. Current: \(declarationName)"
        case .moreThanTwoSecretDeclarationShareKey(let duplicateKeys):
            """
            Each secret declaration must have a unique access key to be used as a variable declaration name.
            Duplicate keys:
            \(duplicateKeys.joined(separator: String.newLine))
            """
        }
    }
}
