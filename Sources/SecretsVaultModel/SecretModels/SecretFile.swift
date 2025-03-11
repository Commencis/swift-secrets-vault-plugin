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
