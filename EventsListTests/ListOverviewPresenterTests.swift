import XCTest
@testable import EventsList

class ListOverviewPresenterTests: XCTestCase {
    
    var presenter: ListOverviewPresenter!
    var api: EventListAPIStub!
    var output: ListOverviewPresenterOutputSpy!
    var mainQueueStub: DispatchQueueStub!

    override func setUpWithError() throws {
        api = EventListAPIStub()
        mainQueueStub = DispatchQueueStub()
        presenter = ListOverviewPresenter(api: api, mainQueue: mainQueueStub)
        output = ListOverviewPresenterOutputSpy()
        presenter.output = output
    }

    override func tearDownWithError() throws {
        api = nil
        output = nil
        mainQueueStub = nil
        presenter = nil
    }

    func testInitialState() throws {
        XCTAssertTrue(presenter.eventItems.isEmpty)
    }
    
    func testEventsLoaded() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        let eventsModel = makeEventsModel()
        api.successResult = eventsModel
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        waitForExpectations(timeout: 1)
        
        // Assert
        XCTAssertTrue(output.areEventsUpdatedCalled)
        XCTAssertTrue(!presenter.eventItems.isEmpty)
        XCTAssertEqual(presenter.eventItems.count, eventsModel.events.count)
        XCTAssertEqual(presenter.eventItems[0].id, eventsModel.events[0].id)
    }
    
    func testToggleSortEventsByDate() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        let eventsModel = makeEventsModel()
        api.successResult = eventsModel
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        presenter.toggleSortEvents(by: \EventItem.date)
        waitForExpectations(timeout: 1)

        // Assert
        XCTAssertTrue(output.areEventsUpdatedCalled)
        XCTAssertTrue(!presenter.eventItems.isEmpty)
        XCTAssertEqual(presenter.eventItems[0].id, "1")
        XCTAssertEqual(presenter.eventItems[5].id, "6")
    }
    
    func testToggleSortEventsByPrice() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        let eventsModel = makeEventsModel()
        api.successResult = eventsModel
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        presenter.toggleSortEvents(by: \EventItem.price)
        waitForExpectations(timeout: 1)

        // Assert
        XCTAssertTrue(output.areEventsUpdatedCalled)
        XCTAssertTrue(!presenter.eventItems.isEmpty)
        XCTAssertEqual(presenter.eventItems[0].id, "1")
        XCTAssertEqual(presenter.eventItems[5].id, "6")
    }
    
    func testDoubleToggleSortEventsByDate() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        let eventsModel = makeEventsModel()
        api.successResult = eventsModel
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        presenter.toggleSortEvents(by: \EventItem.date)
        presenter.toggleSortEvents(by: \EventItem.date)
        waitForExpectations(timeout: 1)

        // Assert
        XCTAssertTrue(output.areEventsUpdatedCalled)
        XCTAssertTrue(!presenter.eventItems.isEmpty)
        XCTAssertEqual(presenter.eventItems[0].id, "6")
        XCTAssertEqual(presenter.eventItems[5].id, "1")
    }
    
    func testDoubleToggleSortEventsByPrice() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        let eventsModel = makeEventsModel()
        api.successResult = eventsModel
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        presenter.toggleSortEvents(by: \EventItem.price)
        presenter.toggleSortEvents(by: \EventItem.price)
        waitForExpectations(timeout: 1)

        // Assert
        XCTAssertTrue(output.areEventsUpdatedCalled)
        XCTAssertTrue(!presenter.eventItems.isEmpty)
        XCTAssertEqual(presenter.eventItems[0].id, "6")
        XCTAssertEqual(presenter.eventItems[5].id, "1")
    }


    func testFilterUpcoming() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        let eventsModel = makeEventsModel()
        api.successResult = eventsModel
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        presenter.filterUpcoming()
        waitForExpectations(timeout: 1)

        // Assert
        XCTAssertTrue(output.areEventsUpdatedCalled)
        XCTAssertTrue(!presenter.eventItems.isEmpty)
        XCTAssertEqual(presenter.eventItems.count, 1)
        XCTAssertEqual(presenter.eventItems[0].id, "6")
    }
    
    func testEventLoadingFailure() {
        // Arrange
        let exp = expectation(description: "Load events completion")
        api.failureResult = EventsListAPI.Error.decodingFailed
        api.completion = {
            exp.fulfill()
        }

        // Act
        presenter.loadEvents()
        waitForExpectations(timeout: 1)
        
        // Assert
        XCTAssertTrue(!output.areEventsUpdatedCalled)
        XCTAssertTrue(output.arePresentErrorCalled)
    }

    
    private func makeEventsModel() -> EventsModel {
        EventsModel(events: [EventModel(id: "1", title: "One", price: 1, date: Date(timeIntervalSinceReferenceDate: 1)),
                             EventModel(id: "3", title: "Three", price: 3, date: Date(timeIntervalSinceReferenceDate: 3)),
                             EventModel(id: "5", title: "Five", price: 5, date: Date(timeIntervalSinceReferenceDate: 5)),
                             EventModel(id: "4", title: "Four", price: 4, date: Date(timeIntervalSinceReferenceDate: 4)),
                             EventModel(id: "6", title: "Six", price: 6, date: Date()),
                             EventModel(id: "2", title: "Two", price: 2, date: Date(timeIntervalSinceReferenceDate: 2)),
                             ])

    }
}
