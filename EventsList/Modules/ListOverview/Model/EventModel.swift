import Foundation

struct EventsModel {
    let events: [EventModel]
}

extension EventsModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let events = try container.decode([EventModel].self)
        self.events = events
    }
}

struct EventModel {
    let id: String
    let title: String
    let price: Float
    let date: Date
}

extension EventModel: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "guid"
        case title = "event"
        case price = "ticketPrice"
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        price = try container.decode(Float.self, forKey: .price)
        date = try container.decode(Date.self, forKey: .date)
    }
}
