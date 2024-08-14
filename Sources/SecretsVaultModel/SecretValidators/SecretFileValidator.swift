import Foundation

/// A struct responsible for validating secret files.
///
/// This struct provides methods to validate a given secret file, ensuring it meets the required criteria
/// such as having valid secret declaration names and unique keys.
public struct SecretFileValidator {

    private static let acceptableNameRegex = "^[A-Z][a-zA-Z0-9_]*$"

    private let secretFile: SecretFile

    /// Initializes a new validator with the given secret file.
    /// - Parameter secretFile: The secret file to validate.
    public init(secretFile: SecretFile) {
        self.secretFile = secretFile
    }

    /// Validates the secret file.
    ///
    /// This method performs various checks to ensure the secret file is valid. It throws an error
    /// if any of the validation checks fail.
    ///
    /// - Throws: `SecretFileValidationError` if the validation fails.
    public func validate() throws {
        // Check if the secret file name is valid
        let keyIsValid = secretFile.declarationName.range(
            of: Self.acceptableNameRegex,
            options: .regularExpression
        ) != nil

        guard keyIsValid else {
            throw SecretFileValidationError.invalidSecretDeclarationName(secretFile.declarationName)
        }

        // Check if the secrets list is not empty
        if secretFile.secretDeclarations.isEmpty {
            throw SecretFileValidationError.noSecretDeclaration
        }

        // Check if the secrets groups has unique keys
        let allSecretDeclarationKeys = secretFile.secretDeclarations.map { $0.secretName }
        let uniqueKeys = Set(allSecretDeclarationKeys)
        if uniqueKeys.count != allSecretDeclarationKeys.count {
            let duplicateKeys = allSecretDeclarationKeys.filter { declKey in
                !uniqueKeys.contains(declKey)
            }
            throw SecretFileValidationError.moreThanTwoSecretDeclarationShareKey(duplicateKeys)
        }
    }
}
