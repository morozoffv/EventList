import Foundation

protocol EventDetailsPresenterProtocol {
    var title: String { get }
    var errorMessage: String { get }
    func loadDetails()
    func buyTicket()
}

protocol EventDetailsPresenterProtocolOutput: NSObjectProtocol {
    func eventDetailsLoaded(eventDetails: EventDetailsModel)
    func presentError()
    func startLoading()
    func endLoading()
    func updateBuyButton(buyButtonTitle: String)
}

protocol EventDetailsCoordinatorDelegate: NSObjectProtocol {
    func routeToTicketDetails(model: TicketModel)
}

final class EventDetailsPresenter: EventDetailsPresenterProtocol {
    
    weak var output: EventDetailsPresenterProtocolOutput?
    weak var coordinatorDelegate: EventDetailsCoordinatorDelegate?
    
    private(set) var title: String = "Event Details"
    private(set) var errorMessage: String = "Couldn't fetch details :( Try again."

    private let api: EventsListAPIProtocol
    private let cache: CodableStorage
    private let mainQueue: DispatchQueueType
    private let eventId: String
    private var eventDetails: EventDetailsModel?
    
    init(api: EventsListAPIProtocol,
         cache: CodableStorage,
         eventId: String,
         mainQueue: DispatchQueueType = DispatchQueue.main) {
        
        self.api = api
        self.cache = cache
        self.eventId = eventId
        self.mainQueue = mainQueue
    }
    
    func loadDetails() {
        let endpoint = EventDetailsEndpoint(eventId: eventId)
        api.execute(endpoint: endpoint) { [weak self] (result: Result<EventDetailsModel, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.update(with: model)
            case .failure(_):
                self.mainQueue.async { self.output?.presentError() }
            }
        }
    }
    
    func buyTicket() {
        mainQueue.async { self.output?.startLoading() }
        
        if let cachedTicket = fetchTicket() {
            self.mainQueue.async {
                self.output?.endLoading()
                self.coordinatorDelegate?.routeToTicketDetails(model: cachedTicket)
            }
            return
        }
        let endpoint = TicketPurchaseEndpoint(eventId: eventId)
        api.execute(endpoint: endpoint) { [weak self] (result: Result<TicketModel, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                guard model.isSuccessful else {
                    self.output?.presentError()
                    return
                }
                self.handleSuccess(with: model)
            case .failure(_):
                self.mainQueue.async {
                    self.output?.endLoading()
                    self.output?.presentError()
                }
            }
        }
    }
    
    func handleSuccess(with model: TicketModel) {
        saveTicket(model: model)
        updateBuyButtonTitle()
        mainQueue.async {
            self.output?.endLoading()
            self.coordinatorDelegate?.routeToTicketDetails(model: model)
        }
    }
    
    private func update(with model: EventDetailsModel) {
        self.eventDetails = model
        updateBuyButtonTitle()
        mainQueue.async {
            self.output?.eventDetailsLoaded(eventDetails: model)
        }
    }
    
    private func updateBuyButtonTitle() {
        guard let model = eventDetails else { return }
        let areTicketPresent = fetchTicket() != nil
        let buyTitleWithPrice = "Buy ticket (\(model.price))"
        let openTicketTitle = "Open ticket"
        let title = areTicketPresent ? openTicketTitle : buyTitleWithPrice
        mainQueue.async {
            self.output?.updateBuyButton(buyButtonTitle: title)
        }
    }
    
    private func fetchTicket() -> TicketModel? {
        return try? cache.fetch(for: eventId)
    }
    
    private func saveTicket(model: TicketModel) {
        try? cache.save(model, for: eventId)
    }
}
