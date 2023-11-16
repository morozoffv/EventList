import UIKit

protocol Coordinator {
    func start()
}

final class AppCoordinator: NSObject, Coordinator {
    
    private let navigationController: UINavigationController
    private let moduleFactory: ModuleFactoryProtocol
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        showListOverview()
    }
    
    private func showListOverview() {
        let vc = moduleFactory.makeListOverview(coordinator: self)
        navigationController.setViewControllers([vc], animated: false)
    }
    
    private func showEventDetails(for eventId: String) {
        let vc = moduleFactory.makeEventDetails(eventId: eventId, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    private func showTicketDetails(for model: TicketModel) {
        let vc = moduleFactory.makeTicketDetails(model: model)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension AppCoordinator: ListOverviewCoordinatorDelegate {
    func routeToEventDetails(eventId: String) {
        showEventDetails(for: eventId)
    }
}

extension AppCoordinator: EventDetailsCoordinatorDelegate {
    func routeToTicketDetails(model: TicketModel) {
        showTicketDetails(for: model)
    }
}
