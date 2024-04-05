import ArgumentParser
import Foundation

@main
internal struct EntryPoint: ParsableCommand {

    static let configuration = CommandConfiguration(
        commandName: "generateSecret",
        abstract: "Generates code from given json secrets file",
        version: "0.0.1-WIP",
        subcommands: [
            RXByteArraySecretFileCommand.self
        ]
    )
}

