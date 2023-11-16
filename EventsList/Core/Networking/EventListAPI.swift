import Foundation

protocol EventsListAPIProtocol {
    func execute<T: Decodable>(endpoint: Endpoint, completion: @escaping ResultHandler<T>)
}

final class EventsListAPI: EventsListAPIProtocol {
    
    enum Error: Swift.Error {
        case requestNotVaild
        case decodingFailed
    }
        
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    // MARK: - EventsListAPIProtocol

    func execute<T: Decodable>(endpoint: Endpoint, completion: @escaping ResultHandler<T>) {
        guard let request = URLRequest(endpoint: endpoint) else {
            completion(.failure(Error.requestNotVaild))
            return
        }
        
        requestManager.execute(request) { result in
            switch result {
            case .success(let response):
                let decoder = JSONDecoder()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = EndpointConfiguration.dateFormat
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                if let model = try? decoder.decode(T.self, from: response.data) {
                    completion(.success(model))
                } else {
                    completion(.failure(Error.decodingFailed))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

}
