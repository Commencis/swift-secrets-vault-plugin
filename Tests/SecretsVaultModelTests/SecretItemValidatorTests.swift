@testable import SecretsVaultModel
import XCTest

private enum Constant {
    
    static var validSecrets: [SecretItem] {
        [SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"]),
         SecretItem(value: "This is Release Secret", flags: ["RELEASE"]),
         SecretItem(value: "This is default Secret", flags: nil)]
    }

    static var secretWithInvalidValue: SecretItem {
        SecretItem(value: "", flags: ["DEBUG", "TEST"])
    }

    static var secretsWithInvalidFlags: [SecretItem] {
        [SecretItem(value: "Duplicate Flags", flags: ["DEBUG", "DEBUG"]),
         SecretItem(value: "Empty Flag", flags: ["DEBUG", ""]),
         SecretItem(value: "Flag with unexpected value", flags: ["DEBUG", "INTERNAL-TEST"])]
    }
}

final class SecretItemValidatorTests: XCTestCase {

    func testValidSecretsValidationSucceeds() {
        for secret in Constant.validSecrets {
            let sut = SecretItemValidator(secret: secret)
            XCTAssertNoThrow(try sut.validate())
        }
    }

    func testEmptySecretValueValidationFails() throws {
        let sut = SecretItemValidator(secret: Constant.secretWithInvalidValue)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretItemValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .emptySecretValue:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }

    func testInvalidFlagFormatValidationFails() {
        for secret in Constant.secretsWithInvalidFlags {
            let sut = SecretItemValidator(secret: secret)
            XCTAssertThrowsError(try sut.validate()) { error in
                guard let error = error as? SecretItemValidationError else {
                    XCTFail("Unexpected Error")
                    return
                }

                switch error {
                case .invalidFlagFormat:
                    // Success case
                    break
                default:
                    XCTFail("Unexpected Error")
                }
            }
        }
    }
}
