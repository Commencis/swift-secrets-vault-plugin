import ArgumentParser
import CodeGenerator
import Foundation
import SecretsVaultModel

internal struct RXByteArraySecretFileCommand: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "rxByteArraySecret",
        abstract: "Generates getter methods that uses Revered XOR Byte Array to access secrets from given json secrets file"
    )

    @Option(name: .shortAndLong, help: "File path for target file")
    var jsonPath: String

    @Option(name: .shortAndLong, help: "File path for target file")
    var output: String

    func run() throws {
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            throw CommandError.unableToReadJSONFile(jsonPath)
        }
        guard let secretFile = try? JSONDecoder().decode(SecretFile.self, from: jsonData) else {
            throw CommandError.unableToDecodeJSON(jsonPath)
        }

        let codeGenerator = RXByteArraySecretFileGenerator(secretFile: secretFile)
        let generatedCode = try codeGenerator.generateCode()
        try generatedCode.write(toFile: output, atomically: true, encoding: .utf8)
    }
}
