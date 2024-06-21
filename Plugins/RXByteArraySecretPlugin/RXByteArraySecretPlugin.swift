import PackagePlugin
import Foundation

private enum Constant {

    static let toolName = "GenerateSecretCommand"
    static var acceptableSecretsFolder = ".rxByteArraySecrets"
    static let rxByteArrayConfigFileName = "config.json"
}

@main
struct RXByteArraySecretPlugin: BuildToolPlugin {

    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        guard let target = target as? SourceModuleTarget else {
            return []
        }
        let generatorTool = try context.tool(named: Constant.toolName)
        let secretsDir = target.directory.appending(Constant.acceptableSecretsFolder)
        let directoryURL = URL(fileURLWithPath: secretsDir.string)
        let contents = try? FileManager.default.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: nil
        )
        let jsonFilePaths = contents?.compactMap { url -> Path? in
            guard url.pathExtension.lowercased() == "json" else {
                return nil
            }

            return secretsDir.appending(url.lastPathComponent)
        }
        guard let jsonFilePaths,
              jsonFilePaths != [] else {
            return []
        }

        return jsonFilePaths.compactMap { file -> Command? in
            createBuildCommand(
                for: file,
                in: context.pluginWorkDirectory,
                with: generatorTool.path
            )
        }
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin

extension RXByteArraySecretPlugin: XcodeBuildToolPlugin {

    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let generatorTool = try context.tool(named: Constant.toolName)
        let secretsDir = context.xcodeProject.directory.appending(Constant.acceptableSecretsFolder)
        let configFile = secretsDir.appending(Constant.rxByteArrayConfigFileName)
        guard let secretDirURL = URL(string: secretsDir.string, relativeTo: nil) else {
            return []
        }
        var secretFileList = try FileManager.default.contentsOfDirectory(
            at: secretDirURL,
            includingPropertiesForKeys: nil,
            options: []
        ).filter {
            $0.pathExtension == "json"
            && $0.lastPathComponent != Constant.rxByteArrayConfigFileName
        }
        if let configData = try? Data(contentsOf: URL(fileURLWithPath: configFile.string)),
           let config = try? JSONDecoder().decode(RXByteArraySecretFileConfig.self, from: configData) {
            let targetSecretMap = config.targetSecretMap.first { $0.targetName == target.displayName }
            guard let targetSecretMap else {
                print(target.displayName)
                throw RXByteArraySecretFilePluginError.configForTargetIsNotPresent
            }
            secretFileList = secretFileList.filter { url in
                targetSecretMap.secretFileNameList.contains { secretFileName in
                    url.lastPathComponent.contains(secretFileName)
                }
            }
        }

        let filteredSecretFilePathList = secretFileList.map { url in
            secretsDir.appending(url.lastPathComponent)
        }
        return filteredSecretFilePathList.compactMap { file -> Command? in
            createBuildCommand(
                for: file,
                in: context.pluginWorkDirectory,
                with: generatorTool.path
            )
        }
    }
}
#endif

// MARK: Helper Methods

private extension RXByteArraySecretPlugin {

    /// Shared function that returns a configured build command if the input files is one that should be processed.
    func createBuildCommand(
        for input: Path,
        in outputDirectoryPath: Path,
        with generatorToolPath: Path
    ) -> Command? {
        let base = input.stem
        let output = outputDirectoryPath.appending(["\(base).swift"])
        return .buildCommand(
            displayName: "Running RXByteArray Secret File Generation",
            executable: generatorToolPath,
            arguments: [
                "rxByteArraySecret",
                "-j", "\(input)",
                "-o", "\(output)"
            ],
            environment: [:],
            inputFiles: [input],
            outputFiles: [output]
        )


    }
}
