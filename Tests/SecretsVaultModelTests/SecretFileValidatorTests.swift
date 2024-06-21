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
            declarationName: "ValidsecretDeclarations",
            secretDeclarations: [
                SecretDeclaration(secretName: "secretDeclaration1", secrets: validSecrets, xorValue: nil, strict: false),
                SecretDeclaration(secretName: "secretDeclaration2", secrets: validSecrets, xorValue: nil, strict: false),
                SecretDeclaration(secretName: "secretDeclaration3", secrets: validSecrets, xorValue: nil, strict: false)
            ]
        )
    }

    static var invalidSecretFileDeclarationName: [SecretFile] {
        [SecretFile(
            declarationName: "validsecretDeclarations",
            secretDeclarations: [SecretDeclaration(secretName: "secretDeclaration1", secrets: validSecrets, xorValue: nil, strict: false)]),
         SecretFile(
            declarationName: "1validsecretDeclarations",
            secretDeclarations: [SecretDeclaration(secretName: "secretDeclaration1", secrets: validSecrets, xorValue: nil, strict: false)]),
         SecretFile(
            declarationName: "_validsecretDeclarations",
            secretDeclarations: [SecretDeclaration(secretName: "secretDeclaration1", secrets: validSecrets, xorValue: nil, strict: false)]),
         SecretFile(
            declarationName: "",
            secretDeclarations: [SecretDeclaration(secretName: "secretDeclaration1", secrets: validSecrets, xorValue: nil, strict: false)])]
    }

    static var invalidSecretFileWithEmptysecretDeclaration: SecretFile {
        SecretFile(declarationName: "ValidsecretDeclarations", secretDeclarations: [])
    }

    static var invalidSecretFileWithSharedsecretDeclarationKey: SecretFile {
        SecretFile(
            declarationName: "ValidsecretDeclarations",
            secretDeclarations: [
                SecretDeclaration(secretName: "secretDeclaration", secrets: validSecrets, xorValue: nil, strict: false),
                SecretDeclaration(secretName: "secretDeclaration", secrets: validSecrets, xorValue: nil, strict: false)
            ]
        )
    }
}

final class SecretFileValidatorTests: XCTestCase {

    func testValidationSucceedsForValidSecretFile() {
        let sut = SecretFileValidator(secretFile: Constant.validSecretFile)
        XCTAssertNoThrow(try sut.validate())
    }

    func testValidationFailsForInvalidSecretDeclarationName() {
        for secretFile in Constant.invalidSecretFileDeclarationName {
            let sut = SecretFileValidator(secretFile: secretFile)
            XCTAssertThrowsError(try sut.validate()) { error in
                guard let error = error as? SecretFileValidationError else {
                    XCTFail("Unexpected Error")
                    return
                }

                switch error {
                case .invalidSecretDeclarationName:
                    // Success case
                    break
                default:
                    XCTFail("Unexpected Error")
                }
            }
        }
    }

    func testValidationFailsForSecretFileWithEmptysecretDeclaration() throws {
        let sut = SecretFileValidator(secretFile: Constant.invalidSecretFileWithEmptysecretDeclaration)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretFileValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .noSecretDeclaration:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }

    func testValidationFailsForTooManySharedGroupKey() {
        let sut = SecretFileValidator(secretFile: Constant.invalidSecretFileWithSharedsecretDeclarationKey)
        XCTAssertThrowsError(try sut.validate()) { error in
            guard let error = error as? SecretFileValidationError else {
                XCTFail("Unexpected Error")
                return
            }

            switch error {
            case .moreThanTwoSecretDeclarationShareKey:
                // Success case
                break
            default:
                XCTFail("Unexpected Error")
            }
        }
    }
}
