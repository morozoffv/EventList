import Foundation

struct TicketModel {
    let isSuccessful: Bool
    let price: Float
    let verificationImage: String?
    let date: Date
}

extension TicketModel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case isSuccessful = "success"
        case verificationImage
        case price = "ticketPrice"
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSuccessful = try container.decode(Bool.self, forKey: .isSuccessful)
        verificationImage = try container.decode(String.self, forKey: .verificationImage)
        price = try container.decode(Float.self, forKey: .price)
        date = try container.decode(Date.self, forKey: .date)
    }
}
