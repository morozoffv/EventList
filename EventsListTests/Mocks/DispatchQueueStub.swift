import XCTest
@testable import EventsList

final class DispatchQueueStub: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
