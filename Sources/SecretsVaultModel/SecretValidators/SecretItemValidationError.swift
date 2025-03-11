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

/// An enumeration representing possible validation errors for a secret item.
///
/// This enumeration defines the various errors that can occur when validating a secret item,
/// such as an empty secret value, an invalid flag format, or a duplicate flag.
public enum SecretItemValidationError: Error {

    /// Error indicating that the secret value is empty.
    case emptySecretValue

    /// Error indicating that the flag format is invalid.
    /// Flags should not contain whitespace.
    case invalidFlagFormat

    /// Error indicating that a duplicate flag has been found.
    case duplicateFlag

    /// A textual description of the validation error.
    ///
    /// This provides a human-readable description of the error that can be used for logging
    /// or displaying error messages to the user.
    public var description: String {
        switch self {
        case .emptySecretValue:
            "Secret value cannot be empty."
        case .invalidFlagFormat:
            "Invalid flag format. Flags should not contain whitespace."
        case .duplicateFlag:
            "Duplicate flag found. Each flag must be unique."
        }
    }
}

