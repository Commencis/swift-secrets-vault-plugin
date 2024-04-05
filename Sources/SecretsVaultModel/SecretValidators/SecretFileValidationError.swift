import Foundation
import SecretsVaultUtility

public enum SecretFileValidationError: Error {

    case noSecretDecl
    case invalidSecretDeclName(_ declName: String)
    case moreThanTwoSecretDeclShareKey(_ duplicateKeys: [String])

    public var description: String {
        switch self {
        case .noSecretDecl:
            "Secret decl list cannot be empty."
        case .invalidSecretDeclName(let declName):
            "Secret declaration name must be a valid decl name. Current: \(declName)"
        case .moreThanTwoSecretDeclShareKey(let duplicateKeys):
            "Each secret declaration must have a unique access key to be used as a variable decl name."
            + "Duplicate keys:\n \(duplicateKeys.joined(separator: String.newLine))"
        }
    }
}
