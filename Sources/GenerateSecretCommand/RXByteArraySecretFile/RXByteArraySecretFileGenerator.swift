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
        let secretDecls = try secretFile.secretDecls.compactMap { secretDeclaration in
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
        let chainedSecretDecls = secretDecls.joined(separator: String.newLine)
        let shiftedBodyString = chainedSecretDecls.replacingOccurrences(
            of: String.newLine,
            with: String.newLine + .singleTab
        )

        let fileContent = """
import Foundation

internal enum \(secretFile.declName) {

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
        for secretDecl in secretFile.secretDecls {
            let validator = SecretDeclValidator(secretDecl: secretDecl)
            try validator.validate()
        }
    }
}
