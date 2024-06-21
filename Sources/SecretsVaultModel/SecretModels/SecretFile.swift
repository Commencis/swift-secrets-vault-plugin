import Foundation

/// A struct representing a secret file.
///
/// This struct conforms to `Codable` and `Sendable` protocols, making it suitable for
/// encoding/decoding and safe for concurrency.
/// - Parameters:
///   - declarationName: The name of the secret declaration.
///   - secretDeclarations: A list of secret declarations.
public struct SecretFile: Codable, Sendable {

    /// The name of the secret declaration.
    public let declarationName: String

    /// A list of secret declarations.
    public let secretDeclarations: [SecretDeclaration]

    /// Initializes a new instance of `SecretFile`.
    /// - Parameters:
    ///   - declarationName: The name of the secret declaration.
    ///   - secretDeclarations: A list of secret declarations.
    public init(declarationName: String, secretDeclarations: [SecretDeclaration]) {
        self.declarationName = declarationName
        self.secretDeclarations = secretDeclarations
    }
}
