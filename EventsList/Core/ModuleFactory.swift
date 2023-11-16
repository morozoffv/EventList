import Foundation
import UIKit

protocol ModuleFactoryProtocol {
    func makeListOverview(coordinator: ListOverviewCoordinatorDelegate) -> UIViewController
    func makeEventDetails(eventId: String, coordinator: EventDetailsCoordinatorDelegate) -> UIViewController
    func makeTicketDetails(model: TicketModel) -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    private let api: EventsListAPIProtocol
    private let cache: CodableStorage
    
    init() {
        let urlSession = URLSessionFactory().makeURLSession()
        let requestManager = RequestManager(urlSession: urlSession)
        let api = EventsListAPI(requestManager: requestManager)
        self.api = api
        
        let path = URL(fileURLWithPath: NSTemporaryDirectory())
        let disk = DiskStorage(path: path)
        let cache = CodableStorage(storage: disk)
        self.cache = cache
    }
    
    func makeListOverview(coordinator: ListOverviewCoordinatorDelegate) -> UIViewController {
        let presenter = ListOverviewPresenter(api: api)
        let vc = ListOverviewViewController(presenter: presenter)
        presenter.output = vc
        presenter.coordinatorDelegate = coordinator
        return vc
    }
    
    func makeEventDetails(eventId: String, coordinator: EventDetailsCoordinatorDelegate) -> UIViewController {
        let presenter = EventDetailsPresenter(api: api, cache: cache, eventId: eventId)
        let vc = EventDetailsViewController(presenter: presenter)
        presenter.output = vc
        presenter.coordinatorDelegate = coordinator
        return vc
    }
    
    func makeTicketDetails(model: TicketModel) -> UIViewController {
        let presenter = TicketDetailsPresenter(model: model)
        let vc = TicketDetailsViewController(presenter: presenter)
        presenter.output = vc
        return vc
    }
}
