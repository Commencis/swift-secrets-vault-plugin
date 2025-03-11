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
