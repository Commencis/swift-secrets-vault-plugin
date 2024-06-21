import Foundation

/// A struct responsible for validating secret declarations.
///
/// This struct provides methods to validate a given secret declaration, ensuring it meets the required criteria
/// such as having valid keys, containing at least one secret, and not having duplicate or improperly flagged secrets.
public struct SecretDeclarationValidator {

    private static let acceptableKeyRegex = "^[a-zA-Z][a-zA-Z0-9_]*$"

    private let secretDeclaration: SecretDeclaration

    /// Initializes a new validator with the given secret declaration.
    /// - Parameter secretDeclaration: The secret declaration to validate.
    public init(secretDeclaration: SecretDeclaration) {
        self.secretDeclaration = secretDeclaration
    }

    /// Validates the secret declaration.
    ///
    /// This method performs various checks to ensure the secret declaration is valid. It throws an error
    /// if any of the validation checks fail.
    ///
    /// - Throws: `SecretDeclarationValidationError` if the validation fails.
    public func validate() throws {
        // Check if the secret group key is valid
        let keyIsValid = secretDeclaration.secretName.range(
            of: Self.acceptableKeyRegex,
            options: .regularExpression
        ) != nil

        guard keyIsValid else {
            throw SecretDeclarationValidationError.invalidSecretDeclarationKey(secretDeclaration.secretName)
        }

        // Check if the secrets list is not empty
        guard !secretDeclaration.secrets.isEmpty else {
            throw SecretDeclarationValidationError.noSecrets
        }

        // Count the number of secrets with no flags
        let secretsWithNoFlagsCount = secretDeclaration.secrets.filter {
            $0.flags == nil
        }.count

        // Check if there are more than one secret with no flags
        if secretsWithNoFlagsCount > 1 {
            throw SecretDeclarationValidationError.multipleSecretsWithNoFlags
        }

        let allFlags = secretDeclaration.secrets.flatMap { item in
            item.flags ?? []
        }
        let uniqueFlags = Set(allFlags)
        if uniqueFlags.count != allFlags.count {
            throw SecretDeclarationValidationError.multipleSecretsShareSameFlag
        }
    }
}
