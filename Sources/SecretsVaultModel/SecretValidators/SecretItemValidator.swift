import Foundation

public struct SecretItemValidator {

    private static let acceptableFlagRegex = "^[a-zA-Z][a-zA-Z0-9_]*$"

    private let secret: SecretItem

    public init(secret: SecretItem) {
        self.secret = secret
    }

    public func validate() throws {
        let value = secret.value
        // Check if the value is empty
        guard !value.isEmpty else {
            throw SecretItemValidationError.emptySecretValue
        }

        guard let flags = secret.flags, !flags.isEmpty else {
            return
        }

        // Check for duplicate flags
        guard Set(flags).count == flags.count else {
            throw SecretItemValidationError.duplicateFlag
        }

        // Check for invalid flags
        let invalidFlagExist = flags.contains { flag in
            flag.range(
                of: SecretItemValidator.acceptableFlagRegex,
                options: .regularExpression
            ) == nil
        }
        if invalidFlagExist {
            throw SecretItemValidationError.invalidFlagFormat
        }
    }
}
