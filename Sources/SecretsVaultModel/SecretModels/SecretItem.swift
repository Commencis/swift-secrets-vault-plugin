import Foundation

public struct SecretItem: Codable, Sendable{

    public let value: String
    public let flags: [String]?

    public init(value: String, flags: [String]?) {
        self.value = value
        self.flags = flags
    }
}
