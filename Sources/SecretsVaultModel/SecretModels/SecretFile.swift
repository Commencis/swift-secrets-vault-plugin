import Foundation

public struct SecretFile: Codable, Sendable {

    public let declName: String
    public let secretDecls: [SecretDeclaration]
}
