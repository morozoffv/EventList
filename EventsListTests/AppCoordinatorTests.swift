import XCTest
@testable import EventsList

class AppCoordinatorTests: XCTestCase {
    
    private var appCoordinator: AppCoordinator!
    private var moduleFactorySpy: ModuleFactorySpy!

    override func setUpWithError() throws {
        moduleFactorySpy = ModuleFactorySpy()
        appCoordinator = AppCoordinator(navigationController: UINavigationController(),
                                        moduleFactory: moduleFactorySpy)
    }

    override func tearDownWithError() throws {
        moduleFactorySpy = nil
        appCoordinator = nil
    }
    
    func testStart() {
        // Arrange & Act
        appCoordinator.start()
        
        // Assert
        XCTAssertTrue(moduleFactorySpy.makeListOverviewCalled)
    }
    
    func testEventDetails() {
        // Arrange & Act
        appCoordinator.routeToEventDetails(eventId: "")
        
        // Assert
        XCTAssertTrue(moduleFactorySpy.makeEventDetailsCalled)
    }
    
    func testTicketDetails() {
        // Arrange & Act
        let ticketModel = TicketModel(isSuccessful: true, price: 0, verificationImage: nil, date: Date())
        appCoordinator.routeToTicketDetails(model: ticketModel)
        
        // Assert
        XCTAssertTrue(moduleFactorySpy.makeTicketDetailsCalled)
    }

}

final class ModuleFactorySpy: ModuleFactoryProtocol {
    var makeListOverviewCalled: Bool = false
    var makeEventDetailsCalled: Bool = false
    var makeTicketDetailsCalled: Bool = false

    func makeListOverview(coordinator: ListOverviewCoordinatorDelegate) -> UIViewController {
        makeListOverviewCalled = true
        return UIViewController()
    }
    
    func makeEventDetails(eventId: String, coordinator: EventDetailsCoordinatorDelegate) -> UIViewController {
        makeEventDetailsCalled = true
        return UIViewController()
    }
    
    func makeTicketDetails(model: TicketModel) -> UIViewController {
        makeTicketDetailsCalled = true
        return UIViewController()
    }
}
