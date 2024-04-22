internal enum RXByteArraySecretFilePluginError: Error {

    case configForTargetIsNotPresent
    case invalidConfigFile
    case decodingError(description: String)

    var description: String {
        switch self {
        case .configForTargetIsNotPresent:
            "Configuration file not found."
        case .invalidConfigFile:
            "Invalid configuration file."
        case .decodingError(let description):
            "Decoding error: \(description)"
        }
    }
}
