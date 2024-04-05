import Foundation

extension Optional where Wrapped == String {

    public var orEmpty: Wrapped {
        self ?? ""
    }
}
