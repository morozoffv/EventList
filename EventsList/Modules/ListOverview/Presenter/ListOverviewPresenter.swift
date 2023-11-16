import Foundation

protocol ListOverviewPresenterProtocol {
    var eventItems: [EventItem] { get }
    var title: String { get }
    var errorMessage: String { get }
    var sortByDateButtonTitle: String { get }
    var sortByPriceButtonTitle: String { get }
    var upcomingButtonTitle: String { get }
    func loadEvents()
    func toggleSortEvents<T: Comparable>(by keyPath: KeyPath<EventItem, T>)
    func filterUpcoming()
    func showDetails(for item: EventItem)
}

protocol ListOverviewPresenterOutput: NSObjectProtocol {
    func eventsUpdated()
    func presentError()
}

protocol ListOverviewCoordinatorDelegate: NSObjectProtocol {
    func routeToEventDetails(eventId: String)
}

final class ListOverviewPresenter: ListOverviewPresenterProtocol {
    
    weak var output: ListOverviewPresenterOutput?
    weak var coordinatorDelegate: ListOverviewCoordinatorDelegate?
    
    private(set) var eventItems: [EventItem] = [] {
        didSet {
            mainQueue.async { self.output?.eventsUpdated() }
        }
    }
    
    private(set) var title: String = "Events"
    private(set) var errorMessage: String = "Couldn't fetch events :( Try again."
    private(set) var sortByDateButtonTitle: String = "Sort by date"
    private(set) var sortByPriceButtonTitle: String = "Sort by price"
    private(set) var upcomingButtonTitle: String = "Upcoming"
    
    private let api: EventsListAPIProtocol
    private let mainQueue: DispatchQueueType
    
    private var loadedEventItems: [EventItem] = []
    private var sortAscendingForKeypath: [PartialKeyPath<EventItem> : Bool] = [:]
            
    init(api: EventsListAPIProtocol, mainQueue: DispatchQueueType = DispatchQueue.main) {
        self.api = api
        self.mainQueue = mainQueue
    }
        
    func loadEvents() {
        let endpoint = EventsEndpoint()
        api.execute(endpoint: endpoint) { [weak self] (result: Result<EventsModel, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.loadedEventItems = model.events.map { EventItem(model: $0) }
                self.eventItems = self.loadedEventItems
            case .failure(_):
                self.mainQueue.async { self.output?.presentError() }
            }
        }
    }
    
    func toggleSortEvents<T: Comparable>(by keyPath: KeyPath<EventItem, T>) {
        let isSortAscending = toggleSortDirection(for: keyPath)
        sortAscendingForKeypath[keyPath] = isSortAscending
        let compare: ((T, T) -> Bool) = isSortAscending ? (<) : (>)
        eventItems = loadedEventItems.sorted(by: keyPath, compare: compare)
    }
    
    func filterUpcoming() {
        let calendar = Calendar.current
        eventItems = loadedEventItems.filter { calendar.isDateInToday($0.date) }
    }
    
    func showDetails(for item: EventItem) {
        coordinatorDelegate?.routeToEventDetails(eventId: item.id)
    }
    
    private func toggleSortDirection<T>(for keyPath: KeyPath<EventItem, T>) -> Bool {
        if let isSortAscending = sortAscendingForKeypath[keyPath] {
            return !isSortAscending
        } else {
            return true
        }
    }
}

private extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>,
                               compare: (_ lhs: T, _ rhs: T) -> Bool) -> [Element] {
        sorted { a, b in
            compare(a[keyPath: keyPath], b[keyPath: keyPath])
        }
    }
}
