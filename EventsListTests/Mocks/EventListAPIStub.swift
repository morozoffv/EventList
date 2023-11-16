import XCTest
@testable import EventsList

final class EventListAPIStub: EventsListAPIProtocol {
    
    var successResult: Decodable?
    var failureResult: Error?
    
    var completion: (() -> Void)?
    
    func execute<T>(endpoint: Endpoint, completion: @escaping ResultHandler<T>) where T : Decodable {
        if let successResult = successResult {
            completion(.success(successResult as! T))
            self.completion?()
        } else if let failureResult = failureResult {
            completion(.failure(failureResult))
            self.completion?()
        }
    }
    
}
