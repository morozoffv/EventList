import Foundation

protocol RequestManagerProtocol {
    func execute(_ request: URLRequest, completion: @escaping ResultHandler<HTTPServerResponse>)
}

final class RequestManager: RequestManagerProtocol {
    
    enum Error: Swift.Error {
        case invalidResponse
    }
    
    private let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    // MARK: - RequestManagerProtocol
    func execute(_ request: URLRequest,
                 completion: @escaping ResultHandler<HTTPServerResponse>) {
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response as? HTTPURLResponse, let data = data {
                let serverResponse = HTTPServerResponse(httpResponse: response, data: data)
                completion(.success(serverResponse))
            } else {
                completion(.failure(Error.invalidResponse))
            }
        }
        
        task.resume()
    }
}
