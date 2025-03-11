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

public struct SecretItemValidator {

    private static let acceptableFlagRegex = "^[a-zA-Z][a-zA-Z0-9_]*$"

    private let secret: SecretItem

    public init(secret: SecretItem) {
        self.secret = secret
    }

    public func validate() throws {
        let value = secret.value
        // Check if the value is empty
        guard !value.isEmpty else {
            throw SecretItemValidationError.emptySecretValue
        }

        guard let flags = secret.flags, !flags.isEmpty else {
            return
        }

        // Check for duplicate flags
        guard Set(flags).count == flags.count else {
            throw SecretItemValidationError.duplicateFlag
        }

        // Check for invalid flags
        let invalidFlagExist = flags.contains { flag in
            flag.range(
                of: SecretItemValidator.acceptableFlagRegex,
                options: .regularExpression
            ) == nil
        }
        if invalidFlagExist {
            throw SecretItemValidationError.invalidFlagFormat
        }
    }
}
