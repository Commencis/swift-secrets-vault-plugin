import Foundation

public struct SecretFileValidator {

    private static let acceptableNameRegex = "^[A-Z][a-zA-Z0-9_]*$"

    private let secretFile: SecretFile

    public init(secretFile: SecretFile) {
        self.secretFile = secretFile
    }

    public func validate() throws {
        // Check if the secret file name is valid
        let keyIsValid = secretFile.declName.range(
            of: Self.acceptableNameRegex,
            options: .regularExpression
        ) != nil

        guard keyIsValid else {
            throw SecretFileValidationError.invalidSecretDeclName(secretFile.declName)
        }

        // Check if the secrets list is not empty
        if secretFile.secretDecls.isEmpty {
            throw SecretFileValidationError.noSecretDecl
        }

        // Check if the secrets groups has unique keys
        let allsecretDeclKeys = secretFile.secretDecls.map { $0.secretName }
        let uniqueKeys = Set(allsecretDeclKeys)
        if uniqueKeys.count != allsecretDeclKeys.count {
            let duplicateKeys = allsecretDeclKeys.filter { declKey in
                !uniqueKeys.contains(declKey)
            }
            throw SecretFileValidationError.moreThanTwoSecretDeclShareKey(duplicateKeys)
        }
    }
}
