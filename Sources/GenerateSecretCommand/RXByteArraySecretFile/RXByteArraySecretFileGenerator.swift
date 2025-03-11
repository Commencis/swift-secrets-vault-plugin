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

import CodeGenerator
import Foundation
import SecretsVaultModel

/// A utility struct for generating a reversed and XOR-ed byte array based on a secret and optional XOR value.
public struct RXByteArraySecretFileGenerator {

    /// The secret items used in the code generation.
    public let secretFile: SecretFile

    public init(secretFile: SecretFile) {
        self.secretFile = secretFile
    }
}

// MARK: - CodeGenerator

extension RXByteArraySecretFileGenerator {

    /// Generates a reversed and XOR-ed byte array based on the provided secret and XOR value.
    ///
    /// - Returns: A string representation of the generated code.
    public func generateCode() throws -> String {
        try validateSecretFile(secretFile)
        let secretDeclarations = try secretFile.secretDeclarations.compactMap { secretDeclaration in
            let rxByteArraySecret = RXByteArraySecretGenerator(secrets: secretDeclaration.secrets,
                                                               strict: secretDeclaration.strict,
                                                               xorValue: secretDeclaration.xorValue)
            let funcBody = try rxByteArraySecret.generateCode()
                .replacingOccurrences(
                    of: String.newLine,
                    with: String.newLine + .singleTab)

            return """
internal static func \(secretDeclaration.secretName)() -> String {
    \(funcBody)
}
"""
        }
        let chainedSecretDeclarations = secretDeclarations.joined(separator: String.newLine)
        let shiftedBodyString = chainedSecretDeclarations.replacingOccurrences(
            of: String.newLine,
            with: String.newLine + .singleTab
        )

        let fileContent = """
import Foundation

internal enum \(secretFile.declarationName) {

    \(shiftedBodyString)
}
"""
        return fileContent + .newLine
    }
}

// MARK: - Helper Methods

private extension RXByteArraySecretFileGenerator {

    func validateSecretFile(_ secretFile: SecretFile) throws {
        let secretFileValidator = SecretFileValidator(secretFile: secretFile)
        try secretFileValidator.validate()
        for secretDeclaration in secretFile.secretDeclarations {
            let validator = SecretDeclarationValidator(secretDeclaration: secretDeclaration)
            try validator.validate()
        }
    }
}
