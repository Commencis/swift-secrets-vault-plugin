import Foundation

public struct SecretDeclValidator {

    private static let acceptableKeyRegex = "^[a-zA-Z][a-zA-Z0-9_]*$"

    private let secretDecl: SecretDeclaration

    public init(secretDecl: SecretDeclaration) {
        self.secretDecl = secretDecl
    }

    public func validate() throws {
        // Check if the secret group key is valid
        let keyIsValid = secretDecl.secretName.range(
            of: Self.acceptableKeyRegex,
            options: .regularExpression
        ) != nil

        guard keyIsValid else {
            throw SecretDeclValidationError.invalidSecretDeclKey(secretDecl.secretName)
        }

        // Check if the secrets list is not empty
        guard !secretDecl.secrets.isEmpty else {
            throw SecretDeclValidationError.noSecrets
        }

        // Count the number of secrets with no flags
        let secretsWithNoFlagsCount = secretDecl.secrets.filter {
            $0.flags == nil
        }.count

        // Check if there are more than one secret with no flags
        if secretsWithNoFlagsCount > 1 {
            throw SecretDeclValidationError.multipleSecretsWithNoFlags
        }

        let allFlags = secretDecl.secrets.flatMap { item in
            item.flags ?? []
        }
        let uniqueFlags = Set(allFlags)
        if uniqueFlags.count != allFlags.count {
            throw SecretDeclValidationError.multipleSecretsShareSameFlag
        }
    }
}
