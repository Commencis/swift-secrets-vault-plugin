import Foundation
import SecretsVaultUtility

public struct SecretDeclaration: Codable, Sendable {

    public let secretName: String
    public let secrets: [SecretItem]
    public let strict: Bool

    public init(secretName: String, secrets: [SecretItem], strict: Bool) {
        self.secretName = secretName
        self.secrets = secrets
        self.strict = strict
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.secretName = try container.decode(String.self, forKey: .secretName)
        self.secrets = try container.decode([SecretItem].self, forKey: .secrets)
        self.strict = try container.decodeIfPresent(Bool.self, forKey: .strict).orTrue
    }
}
