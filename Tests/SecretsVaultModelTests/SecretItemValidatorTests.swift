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
                case .duplicateFlag,
                        .invalidFlagFormat:
                    // Success case
                    break
                default:
                    XCTFail("Unexpected Error")
                }
            }
        }
    }
}
