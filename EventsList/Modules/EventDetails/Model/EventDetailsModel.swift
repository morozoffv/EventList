import Foundation

struct EventDetailsModel {
    let id: String
    let title: String?
    let subtitle: String?
    let price: Float
    let phone: String?
    let address: String?
    let email: String?
    let date: Date
}

extension EventDetailsModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "guid"
        case title = "event"
        case subtitle = "description"
        case price = "ticketPrice"
        case phone
        case address
        case email
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
        price = try container.decode(Float.self, forKey: .price)
        phone = try container.decode(String.self, forKey: .phone)
        address = try container.decode(String.self, forKey: .address)
        email = try container.decode(String.self, forKey: .email)
        date = try container.decode(Date.self, forKey: .date)
    }
}
