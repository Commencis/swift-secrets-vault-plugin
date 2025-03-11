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

/// A struct responsible for validating secret declarations.
///
/// This struct provides methods to validate a given secret declaration, ensuring it meets the required criteria
/// such as having valid keys, containing at least one secret, and not having duplicate or improperly flagged secrets.
public struct SecretDeclarationValidator {

    private static let acceptableKeyRegex = "^[a-zA-Z][a-zA-Z0-9_]*$"

    private let secretDeclaration: SecretDeclaration

    /// Initializes a new validator with the given secret declaration.
    /// - Parameter secretDeclaration: The secret declaration to validate.
    public init(secretDeclaration: SecretDeclaration) {
        self.secretDeclaration = secretDeclaration
    }

    /// Validates the secret declaration.
    ///
    /// This method performs various checks to ensure the secret declaration is valid. It throws an error
    /// if any of the validation checks fail.
    ///
    /// - Throws: `SecretDeclarationValidationError` if the validation fails.
    public func validate() throws {
        // Check if the secret group key is valid
        let keyIsValid = secretDeclaration.secretName.range(
            of: Self.acceptableKeyRegex,
            options: .regularExpression
        ) != nil

        guard keyIsValid else {
            throw SecretDeclarationValidationError.invalidSecretDeclarationKey(secretDeclaration.secretName)
        }

        // Check if the secrets list is not empty
        guard !secretDeclaration.secrets.isEmpty else {
            throw SecretDeclarationValidationError.noSecrets
        }

        // Count the number of secrets with no flags
        let secretsWithNoFlagsCount = secretDeclaration.secrets.filter {
            $0.flags == nil
        }.count

        // Check if there are more than one secret with no flags
        if secretsWithNoFlagsCount > 1 {
            throw SecretDeclarationValidationError.multipleSecretsWithNoFlags
        }

        let allFlags = secretDeclaration.secrets.flatMap { item in
            item.flags.orEmpty
        }
        let uniqueFlags = Set(allFlags)
        if uniqueFlags.count != allFlags.count {
            throw SecretDeclarationValidationError.multipleSecretsShareSameFlag
        }
    }
}
