@testable import CodeGenerator
import SecretsVaultModel
import XCTest

final class CodeGeneratorTests: XCTestCase {

    func testRXByteArraySecretGenerator() throws {
        let debugTestSecret = SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"])
        let releaseSecret = SecretItem(value: "This is Release Secret", flags: ["RELEASE"])
        let defaultSecret = SecretItem(value: "This is default Secret", flags: nil)

        let sut = RXByteArraySecretGenerator(
            secrets: [debugTestSecret, releaseSecret, defaultSecret],
            strict: false,
            xorValue: 42
        )
        let expected = """
var value: [UInt8] {
    #if DEBUG || TEST
    [94, 79, 88, 73, 79, 121, 10, 94, 89, 79, 126, 10, 12, 10, 77, 95, 72, 79, 110, 10, 89, 67, 10, 89, 67, 66, 126]
    #elseif RELEASE
    [94, 79, 88, 73, 79, 121, 10, 79, 89, 75, 79, 70, 79, 120, 10, 89, 67, 10, 89, 67, 66, 126]
    #else
    [94, 79, 88, 73, 79, 121, 10, 94, 70, 95, 75, 76, 79, 78, 10, 89, 67, 10, 89, 67, 66, 126]
    #endif
}

let originalArray = value.reversed().map {
    $0 ^ 42
}
let originalString = String(bytes: originalArray, encoding: .utf8) ?? ""
return originalString
"""
        let stringResult = try sut.generateCode()
        XCTAssert(stringResult == expected)
    }


    func testRXByteArraySecretGeneratorStrict() throws {
        let debugTestSecret = SecretItem(value: "This is Debug & Test Secret", flags: ["DEBUG", "TEST"])
        let releaseSecret = SecretItem(value: "This is Release Secret", flags: ["RELEASE"])

        let sut = RXByteArraySecretGenerator(
            secrets: [debugTestSecret, releaseSecret],
            strict: true,
            xorValue: 42
        )
        let expected = """
var value: [UInt8] {
    #if DEBUG || TEST
    [94, 79, 88, 73, 79, 121, 10, 94, 89, 79, 126, 10, 12, 10, 77, 95, 72, 79, 110, 10, 89, 67, 10, 89, 67, 66, 126]
    #elseif RELEASE
    [94, 79, 88, 73, 79, 121, 10, 79, 89, 75, 79, 70, 79, 120, 10, 89, 67, 10, 89, 67, 66, 126]
    #else
    #error("Secret does not exist")
    #endif
}

let originalArray = value.reversed().map {
    $0 ^ 42
}
let originalString = String(bytes: originalArray, encoding: .utf8) ?? ""
return originalString
"""
        let stringResult = try sut.generateCode()
        XCTAssert(stringResult == expected)
    }
}
