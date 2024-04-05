import Foundation

public enum SecretDeclValidationError: Error {

    case noSecrets
    case invalidSecretDeclKey(_ declName: String)
    case multipleSecretsWithNoFlags
    case multipleSecretsShareSameFlag

    public var description: String {
        switch self {
        case .multipleSecretsShareSameFlag:
            "Multiple secrets cannot share the same flag."
        case .invalidSecretDeclKey(let declName):
            "Secret group key should be valid. Current: \(declName)"
        case .noSecrets:
            "secretDecl must have at least one secret."
        case .multipleSecretsWithNoFlags:
            "There can be only one secret with no flags in any given secret group."
        }
    }
}
