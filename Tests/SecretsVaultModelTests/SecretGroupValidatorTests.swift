@testable import SecretsVaultModel
import XCTest

private enum Constant {

    static var validSecrets: [SecretItem] {
        [SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"]),
         SecretItem(value: "This is Release Secret", flags: ["RELEASE"]),
         SecretItem(value: "This is default Secret", flags: nil)]
    }

    static var tooManySecretsWithNoFlag: [SecretItem] {
        [SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"]),
         SecretItem(value: "This is default Secret", flags: nil),
         SecretItem(value: "This is another default Secret", flags: nil)]
    }

    static var tooManySecretsThatSharesFlag: [SecretItem] {
        [SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"]),
         SecretItem(value: "This is default Secret", flags: ["TEST", "RELEASE"]),
         SecretItem(value: "This is another default Secret", flags: nil)]
    }

    static var validsecretDeclarations: [SecretDeclaration] {
        [SecretDeclaration(secretName: "ValidsecretDeclaration", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "ValidsecretDeclaration1", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "Valid_Secret_Group", secrets: validSecrets, xorValue: nil, strict: false)]
    }

    static var secretDeclarationsWithInvalidKey: [SecretDeclaration] {
        [SecretDeclaration(secretName: "secretDeclarationWithInvalid Name", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "1secretDeclarationWithInvalidName", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "secret-GroupWith-Invalid-Name", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "_secretDeclarationWithInvalidName", secrets: validSecrets, xorValue: nil, strict: false)]
    }

    static var secretDeclarationWihtTooManyNoFlags: SecretDeclaration {
        SecretDeclaration(secretName: "secretDeclarationWtihTooManyNoFlags", secrets: tooManySecretsWithNoFlag, xorValue: nil, strict: false)
    }

    static var secretDeclarationThatSharesFlag: SecretDeclaration {
        SecretDeclaration(secretName: "secretDeclarationThatSharesFlag", secrets: tooManySecretsThatSharesFlag, xorValue: nil, strict: false)
    }
}

final class SecretDeclarationValidatorTests: XCTestCase {

    func testValidationSucceedsForValidsecretDeclarations() {
        for secretDeclaration in Constant.validsecretDeclarations {
            let sut = SecretDeclarationValidator(secretDeclaration: secretDeclaration)
            XCTAssertNoThrow(try sut.validate())
        }
    }

    func testValidationFailsForInvalidKey() {
        for secretDeclaration in Constant.secretDeclarationsWithInvalidKey {
            let sut = SecretDeclarationValidator(secretDeclaration: secretDeclaration)
            XCTAssertThrowsError(try sut.validate()) { error in
                guard let error = error as? SecretDeclarationValidationError else {
                    XCTFail("Unexpected Error")
                    return
                }

                switch error {
                case .invalidSecretDeclarationKey:
                    // Success case
                    break
                default:
                    XCTFail("Unexpected Error")
                }
            }
        }
    }

    func testValidationFailsForTooManyNoFlags() throws {
        let sut = SecretDeclarationValidator(secretDeclaration: Constant.secretDeclarationWihtTooManyNoFlags)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretDeclarationValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .multipleSecretsWithNoFlags:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }

    func testValidationFailsForTooManySharedFlags() {
        let sut = SecretDeclarationValidator(secretDeclaration: Constant.secretDeclarationThatSharesFlag)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretDeclarationValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .multipleSecretsShareSameFlag:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }
}
