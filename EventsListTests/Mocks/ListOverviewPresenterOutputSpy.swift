import XCTest
@testable import EventsList

final class ListOverviewPresenterOutputSpy: NSObject, ListOverviewPresenterOutput {
    var areEventsUpdatedCalled = false
    var arePresentErrorCalled = false
    
    func eventsUpdated() {
        areEventsUpdatedCalled = true
    }
    
    func presentError() {
        arePresentErrorCalled = true
    }
}
