import Foundation

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
}

struct EventsEndpoint: Endpoint {
    // MARK: - Endpoint
    var path: String = "events"
    var method: HTTPMethod = .get
}

struct EventDetailsEndpoint: Endpoint {    
    init(eventId: String) {
        self.path = "event/\(eventId)"
    }
    
    // MARK: - Endpoint
    var path: String
    var method: HTTPMethod = .get
}

struct TicketPurchaseEndpoint: Endpoint {
    init(eventId: String) {
        self.path = "event/\(eventId)/buy"
    }
    
    // MARK: - Endpoint
    var path: String
    var method: HTTPMethod = .post
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

final class EndpointConfiguration {
    static let host = "https://technical-interview.excels.io/"
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}

extension URLRequest {
    init?(endpoint: Endpoint) {
        let stringUrl = EndpointConfiguration.host + endpoint.path
        guard let url = URL(string: stringUrl) else { return nil }
        self.init(url: url)
        self.httpMethod = endpoint.method.rawValue
    }
}

