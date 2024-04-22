import Foundation

struct RXByteArraySecretFileConfig: Codable, Sendable {

    struct TargetSecretMap: Codable, Sendable {

        let targetName: String
        let secretFileNameList: [String]
    }

    let targetSecretMap: [TargetSecretMap]
}
