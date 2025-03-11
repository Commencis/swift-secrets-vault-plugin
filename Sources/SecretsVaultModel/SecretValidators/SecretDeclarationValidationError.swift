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

/// An enumeration representing possible validation errors for secret declarations.
///
/// This enumeration defines the various errors that can occur when validating secret declarations,
/// such as having no secrets, an invalid secret declaration key, multiple secrets without flags, or multiple secrets sharing the same flag.
public enum SecretDeclarationValidationError: Error {

    /// Error indicating that no secrets are present.
    case noSecrets

    /// Error indicating that a secret declaration key is invalid.
    /// - Parameter declarationName: The name of the invalid declaration key.
    case invalidSecretDeclarationKey(_ declarationName: String)

    /// Error indicating that multiple secrets have no flags.
    case multipleSecretsWithNoFlags

    /// Error indicating that multiple secrets share the same flag.
    case multipleSecretsShareSameFlag

    /// A textual description of the validation error.
    ///
    /// This provides a human-readable description of the error that can be used for logging
    /// or displaying error messages to the user.
    public var description: String {
        switch self {
        case .noSecrets:
            "Secret declaration must have at least one secret."
        case .invalidSecretDeclarationKey(let declarationName):
            "Secret group key should be valid. Current: \(declarationName)"
        case .multipleSecretsWithNoFlags:
            "There can be only one secret with no flags in any given secret group."
        case .multipleSecretsShareSameFlag:
            "Multiple secrets cannot share the same flag."
        }
    }
}

