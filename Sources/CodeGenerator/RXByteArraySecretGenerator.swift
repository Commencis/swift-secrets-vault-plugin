import Foundation
import SecretsVaultModel

/// A utility struct for generating a reversed and XOR-ed byte array based on a secret and optional XOR value.
public struct RXByteArraySecretGenerator {

    /// The secret items used in the code generation.
    public let secrets: [SecretItem]

    /// The optional XOR value to be applied during code generation.
    public let xorValue: UInt8

    /// A boolean value indicating whether the strict mode is enabled or not.
    public let strict: Bool

    /// Initializes a new instance of the `RXByteArrayGenerator` struct.
    /// - Parameters:
    ///   - secrets: The secret items used in the code generation.
    ///   - strict: A boolean value indicating whether to force the secret to exist in all flags.
    ///   - xorValue: The optional XOR value to be applied during code generation. If set to `nil`, a random XOR value will be applied.
    public init(secrets: [SecretItem], strict: Bool, xorValue: UInt8? = nil) {
        self.secrets = secrets
        self.strict = strict
        self.xorValue = xorValue ?? UInt8.random(in: 0...255)
    }
}

// MARK: - CodeGenerator

extension RXByteArraySecretGenerator {

    /// Generates a reversed and XOR-ed byte array based on the provided secret and XOR value.
    ///
    /// - Returns: A string representation of the generated code.
    public func generateCode() throws -> String {
        try validateSecrets(secrets)
        let computedPropertyBody = generateComputedPropertyBody(secrets: secrets, xorValue: xorValue)
        let shiftedBodyString = computedPropertyBody.replacingOccurrences(
            of: String.newLine,
            with: String.newLine + .singleTab)

        return """
var value: [UInt8] {
    \(shiftedBodyString)
}

let originalArray = value.reversed().map {
    $0 ^ \(xorValue)
}
let originalString = String(bytes: originalArray, encoding: .utf8) ?? ""
return originalString
"""
    }
}

// MARK: - Helper Methods

private extension RXByteArraySecretGenerator {

    func validateSecrets(_ secrets: [SecretItem]) throws {
        for secret in secrets {
            let validator = SecretItemValidator(secret: secret)
            try validator.validate()
        }
    }

    func generateComputedPropertyBody(secrets: [SecretItem], xorValue: UInt8) -> String {
        var mutableSecrets = secrets
        let elseBlockIndex = mutableSecrets.firstIndex { item in
            item.flags == nil || item.flags == []
        }

        let elseBlock: SecretItem? = if let elseBlockIndex {
            mutableSecrets.remove(at: elseBlockIndex)
        } else {
            nil
        }
        let ifBlockIndex = mutableSecrets.firstIndex { item in
            item.flags != nil && item.flags != []
        }
        let ifBlock: SecretItem? = if let ifBlockIndex {
            mutableSecrets.remove(at: ifBlockIndex)
        } else {
            nil
        }
        let elseIfBlocks = mutableSecrets

        // MARK: - Start Generating Code
        var generatedRXByteArrayBody: String = ""
        if let ifBlock {
            let rxByteArray = Array(ifBlock.value.stringToByteArray(xorValue: xorValue).reversed())
            generatedRXByteArrayBody += "#if \((ifBlock.flags.orEmpty).joined(separator: " || "))"
            + .newLine
            + "\(rxByteArray)"
            + .newLine
        }
        if !elseIfBlocks.isEmpty {
            for elseIfBlock in elseIfBlocks {
                let rxByteArray = Array(elseIfBlock.value.stringToByteArray(xorValue: xorValue).reversed())
                generatedRXByteArrayBody += "#elseif "
                + "\((elseIfBlock.flags.orEmpty).joined(separator: " || "))"
                + .newLine
                + "\(rxByteArray)"
                + .newLine
            }
        }
        if ifBlock != nil {
            generatedRXByteArrayBody += "#else" + .newLine
        }
        if let elseBlock {
            let rxByteArray = Array(elseBlock.value.stringToByteArray(xorValue: xorValue).reversed())
            generatedRXByteArrayBody += "\(rxByteArray)"
        } else {
            generatedRXByteArrayBody += strict
            ? "#error(\"Secret does not exist\")"
            : "[]"
        }
        if ifBlock != nil {
            generatedRXByteArrayBody += .newLine + "#endif"
        }
        return generatedRXByteArrayBody
    }
}
