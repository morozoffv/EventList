import Foundation

struct EventItem {
    let id: String
    let title: String
    let price: Float
    let date: Date
    
    let formattedDate: String
    let formattedPrice: String

    init(model: EventModel) {
        self.id = model.id
        self.title = model.title
        self.price = model.price
        self.date = model.date

        self.formattedDate = model.date.formattedString
        self.formattedPrice = String(model.price)
    }
}
