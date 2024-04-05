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

    static var validsecretDecls: [SecretDeclaration] {
        [SecretDeclaration(secretName: "ValidsecretDecl", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "ValidsecretDecl1", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "Valid_Secret_Group", secrets: validSecrets, xorValue: nil, strict: false)]
    }

    static var secretDeclsWithInvalidKey: [SecretDeclaration] {
        [SecretDeclaration(secretName: "secretDeclWithInvalid Name", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "1secretDeclWithInvalidName", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "secret-GroupWith-Invalid-Name", secrets: validSecrets, xorValue: nil, strict: false),
         SecretDeclaration(secretName: "_secretDeclWithInvalidName", secrets: validSecrets, xorValue: nil, strict: false)]
    }

    static var secretDeclWihtTooManyNoFlags: SecretDeclaration {
        SecretDeclaration(secretName: "secretDeclWtihTooManyNoFlags", secrets: tooManySecretsWithNoFlag, xorValue: nil, strict: false)
    }

    static var secretDeclThatSharesFlag: SecretDeclaration {
        SecretDeclaration(secretName: "secretDeclThatSharesFlag", secrets: tooManySecretsThatSharesFlag, xorValue: nil, strict: false)
    }
}

final class SecretDeclValidatorTests: XCTestCase {

    func testValidationSucceedsForValidsecretDecls() {
        for secretDecl in Constant.validsecretDecls {
            let sut = SecretDeclValidator(secretDecl: secretDecl)
            XCTAssertNoThrow(try sut.validate())
        }
    }

    func testValidationFailsForInvalidKey() {
        for secretDecl in Constant.secretDeclsWithInvalidKey {
            let sut = SecretDeclValidator(secretDecl: secretDecl)
            XCTAssertThrowsError(try sut.validate()) { error in
                guard let error = error as? SecretDeclValidationError else {
                    XCTFail("Unexpected Error")
                    return
                }

                switch error {
                case .invalidSecretDeclKey:
                    // Success case
                    break
                default:
                    XCTFail("Unexpected Error")
                }
            }
        }
    }

    func testValidationFailsForTooManyNoFlags() throws {
        let sut = SecretDeclValidator(secretDecl: Constant.secretDeclWihtTooManyNoFlags)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretDeclValidationError else {
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
        let sut = SecretDeclValidator(secretDecl: Constant.secretDeclThatSharesFlag)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretDeclValidationError else {
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
