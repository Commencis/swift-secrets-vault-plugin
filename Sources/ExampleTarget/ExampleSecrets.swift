import Foundation

internal enum ExampleSecret {

    internal static func myEncryptionKey() -> String {
        var value: [UInt8] {
            #if CUSTOM_RELEASE_FLAG
            [109, 79, 104, 82, 109, 93, 70, 29]
            #else
            [28, 91, 109, 92, 100, 127, 27, 94]
            #endif
        }
        
        let originalArray = value.reversed().map {
            $0 ^ 42
        }
        let originalString = String(bytes: originalArray, encoding: .utf8) ?? ""
        return originalString
    }
    internal static func myInternalEndpoint() -> String {
        var value: [UInt8] {
            #if DEBUG
            [9, 23, 16, 75, 9, 4, 11, 23, 0, 17, 11, 12, 75, 0, 8, 10, 22, 74, 74, 95, 22, 21, 17, 17, 13]
            #else
            #error("Secret does not exist")
            #endif
        }
        
        let originalArray = value.reversed().map {
            $0 ^ 101
        }
        let originalString = String(bytes: originalArray, encoding: .utf8) ?? ""
        return originalString
    }
    internal static func myAPIKey() -> String {
        var value: [UInt8] {
            #if DEBUG
            [166, 186, 180, 160, 182, 175, 190, 160, 179, 190, 177, 173, 186, 171, 177, 182]
            #elseif CUSTOM_RELEASE_FLAG
            [166, 186, 180, 160, 182, 175, 190, 160, 187, 176, 173, 175]
            #else
            []
            #endif
        }
        
        let originalArray = value.reversed().map {
            $0 ^ 255
        }
        let originalString = String(bytes: originalArray, encoding: .utf8) ?? ""
        return originalString
    }
}
