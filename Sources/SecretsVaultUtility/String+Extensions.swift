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
