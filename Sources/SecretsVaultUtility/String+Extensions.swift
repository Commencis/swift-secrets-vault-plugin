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

import Foundation

// MARK: - Constants

extension String {

    public static let newLine = "\n"
    public static let singleTab = "    "
}

// MARK: - Methods

extension String {

    public func stringToByteArray(xorValue: UInt8? = nil) -> [UInt8] {
        let byteArray: [UInt8] = self.utf8.map { char in
            if let xorValue {
                // Apply XOR operation if a value is provided
                char ^ xorValue
            } else {
                char
            }
        }
        return byteArray
    }
}
