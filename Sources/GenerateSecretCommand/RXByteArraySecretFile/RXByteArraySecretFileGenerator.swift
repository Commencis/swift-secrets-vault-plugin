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
