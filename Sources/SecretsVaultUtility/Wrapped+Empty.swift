import Foundation

public extension Optional where Wrapped: RangeReplaceableCollection {

    @inlinable var orEmpty: Wrapped {
        self ?? Wrapped()
    }
}
