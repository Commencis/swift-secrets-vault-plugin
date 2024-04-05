import XCTest
@testable import SecretsVaultUtility

final class SecretsVaultUtilityTests: XCTestCase {

    func testStringToByteArrayWithoutXOR() {
        let inputString = "Hello, world!"
        let expectedByteArray: [UInt8] = [72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33]

        let byteArray = inputString.stringToByteArray()

        XCTAssertEqual(byteArray, expectedByteArray)
    }

    func testStringToByteArrayWithXOR() {

        let inputString = "Hello, world!"
        let xorValue: UInt8 = 42
        let expectedByteArray: [UInt8] = [98, 79, 70, 70, 69, 6, 10, 93, 69, 88, 70, 78, 11]

        let byteArray = inputString.stringToByteArray(xorValue: xorValue)

        XCTAssertEqual(byteArray, expectedByteArray)
    }

    func testEmptyStringToByteArray() {
        let inputString = ""
        let expectedByteArray: [UInt8] = []

        let byteArray = inputString.stringToByteArray()

        XCTAssertEqual(byteArray, expectedByteArray)
    }
}
