//
// Copyright © 2025 Commencis
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

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
