@testable import SecretsVaultModel
import XCTest

private enum Constant {

    static var validSecrets: [SecretItem] {
        [SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"]),
         SecretItem(value: "This is Release Secret", flags: ["RELEASE"]),
         SecretItem(value: "This is default Secret", flags: nil)]
    }

    static var validSecretFile: SecretFile {
        SecretFile(
            declName: "ValidsecretDecls",
            secretDecls: [
                SecretDeclaration(secretName: "secretDecl1", secrets: validSecrets, strict: false),
                SecretDeclaration(secretName: "secretDecl2", secrets: validSecrets, strict: false),
                SecretDeclaration(secretName: "secretDecl3", secrets: validSecrets, strict: false)
            ]
        )
    }

    static var invalidSecretFileDeclName: [SecretFile] {
        [SecretFile(
            declName: "validsecretDecls",
            secretDecls: [SecretDeclaration(secretName: "secretDecl1", secrets: validSecrets, strict: false)]),
         SecretFile(
            declName: "1validsecretDecls",
            secretDecls: [SecretDeclaration(secretName: "secretDecl1", secrets: validSecrets, strict: false)]),
         SecretFile(
            declName: "_validsecretDecls",
            secretDecls: [SecretDeclaration(secretName: "secretDecl1", secrets: validSecrets, strict: false)]),
         SecretFile(
            declName: "",
            secretDecls: [SecretDeclaration(secretName: "secretDecl1", secrets: validSecrets, strict: false)])]
    }

    static var invalidSecretFileWithEmptysecretDecl: SecretFile {
        SecretFile(declName: "ValidsecretDecls", secretDecls: [])
    }

    static var invalidSecretFileWithSharedsecretDeclKey: SecretFile {
        SecretFile(
            declName: "ValidsecretDecls",
            secretDecls: [
                SecretDeclaration(secretName: "secretDecl", secrets: validSecrets, strict: false),
                SecretDeclaration(secretName: "secretDecl", secrets: validSecrets, strict: false)
            ]
        )
    }
}

final class SecretFileValidatorTests: XCTestCase {

    func testValidationSucceedsForValidSecretFile() {
        let sut = SecretFileValidator(secretFile: Constant.validSecretFile)
        XCTAssertNoThrow(try sut.validate())
    }

    func testValidationFailsForInvalidSecretDeclName() {
        for secretFile in Constant.invalidSecretFileDeclName {
            let sut = SecretFileValidator(secretFile: secretFile)
            XCTAssertThrowsError(try sut.validate()) { error in
                guard let error = error as? SecretFileValidationError else {
                    XCTFail("Unexpected Error")
                    return
                }

                switch error {
                case .invalidSecretDeclName:
                    // Success case
                    break
                default:
                    XCTFail("Unexpected Error")
                }
            }
        }
    }

    func testValidationFailsForSecretFileWithEmptysecretDecl() throws {
        let sut = SecretFileValidator(secretFile: Constant.invalidSecretFileWithEmptysecretDecl)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretFileValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .noSecretDecl:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }

    func testValidationFailsForTooManySharedGroupKey() {
        let sut = SecretFileValidator(secretFile: Constant.invalidSecretFileWithSharedsecretDeclKey)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretFileValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .moreThanTwoSecretDeclShareKey:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }
}
