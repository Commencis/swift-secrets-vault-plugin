import Foundation

extension Optional where Wrapped == Bool {

    public var orFalse: Wrapped {
        self ?? false
    }

    public var orTrue: Wrapped {
        self ?? true
    }
}
