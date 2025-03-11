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
