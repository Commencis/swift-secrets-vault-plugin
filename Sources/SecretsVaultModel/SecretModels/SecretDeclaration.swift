//
// Copyright © 2025 Commencis
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import SecretsVaultUtility

/// A struct representing a secret declaration.
///
/// This struct conforms to `Codable` and `Sendable` protocols, making it suitable for
/// encoding/decoding and safe for concurrency.
/// - Parameters:
///   - secretName: The name of the secret declaration.
///   - xorValue: An optional XOR value for the secret declaration.
///   - secrets: A list of secret items associated with the secret declaration.
///   - strict: A flag indicating if the secret declaration is strict.
public struct SecretDeclaration: Codable, Sendable {

    /// The name of the secret declaration.
    public let secretName: String

    /// An optional XOR value for the secret declaration.
    public let xorValue: UInt8?

    /// A list of secret items associated with the secret declaration.
    public let secrets: [SecretItem]

    /// A flag indicating if the secret declaration is strict.
    public let strict: Bool

    /// Initializes a new instance of `SecretDeclaration`.
    /// - Parameters:
    ///   - secretName: The name of the secret declaration.
    ///   - secrets: A list of secret items associated with the secret declaration.
    ///   - xorValue: An optional XOR value for the secret declaration.
    ///   - strict: A flag indicating if the secret declaration is strict.
    public init(secretName: String, secrets: [SecretItem], xorValue: UInt8?, strict: Bool) {
        self.secretName = secretName
        self.xorValue = xorValue
        self.secrets = secrets
        self.strict = strict
    }

    /// Initializes a new instance of `SecretDeclaration` from a decoder.
    /// - Parameter decoder: The decoder to read data from.
    /// - Throws: An error if any value throws an error during decoding.
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.secretName = try container.decode(String.self, forKey: .secretName)
        self.xorValue = try container.decodeIfPresent(UInt8.self, forKey: .xorValue)
        self.secrets = try container.decode([SecretItem].self, forKey: .secrets)
        self.strict = try container.decodeIfPresent(Bool.self, forKey: .strict).orTrue
    }
}
