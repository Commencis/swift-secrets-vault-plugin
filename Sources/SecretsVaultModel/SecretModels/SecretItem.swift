import Foundation

/// A struct representing a secret item.
///
/// This struct conforms to `Codable` and `Sendable` protocols, making it suitable for
/// encoding/decoding and safe for concurrency.
/// - Parameters:
///   - value: The value of the secret item.
///   - flags: An optional list of flags associated with the secret item.
public struct SecretItem: Codable, Sendable {

    /// The value of the secret item.
    public let value: String

    /// An optional list of flags associated with the secret item.
    public let flags: [String]?

    /// Initializes a new instance of `SecretItem`.
    /// - Parameters:
    ///   - value: The value of the secret item.
    ///   - flags: An optional list of flags associated with the secret item.
    public init(value: String, flags: [String]?) {
        self.value = value
        self.flags = flags
    }
}
