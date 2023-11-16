import Foundation
import UIKit

protocol TicketDetailsPresenterProtocol {
    var title: String { get }
    var errorMessage: String { get }
    func updateTicket()
}

protocol TicketDetailsPresenterProtocolOutput: NSObjectProtocol {
    func ticketUpdated(date: String, qrCodeImage: UIImage)
}

final class TicketDetailsPresenter: TicketDetailsPresenterProtocol {
    
    weak var output: TicketDetailsPresenterProtocolOutput?
    
    private(set) var title: String = "Ticket Details"
    private(set) var errorMessage: String = "Couldn't fetch your ticket :( Try again."
    
    private let model: TicketModel
    
    init(model: TicketModel) {
        self.model = model
    }
    
    func updateTicket() {
        guard let imageString = model.verificationImage,
              let qrCodeImage = convertBase64StringToImage(imageBase64String: imageString)
        else { return }
        
        output?.ticketUpdated(date: model.date.formattedString, qrCodeImage: qrCodeImage)
    }
    
    private func convertBase64StringToImage(imageBase64String: String) -> UIImage? {
        guard let imageData = Data(base64Encoded: imageBase64String),
              let image = UIImage(data: imageData)
        else { return nil }
        return image
    }
}

