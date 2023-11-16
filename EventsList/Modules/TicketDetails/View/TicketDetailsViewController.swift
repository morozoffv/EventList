import UIKit
import SnapKit

final class TicketDetailsViewController: UIViewController {
    
    private enum Constants {
        static let baseOffset: CGFloat = 8
    }
    
    private let presenter: TicketDetailsPresenterProtocol
    
    private let qrCodeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    init(presenter: TicketDetailsPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        setupConstraints()
        presenter.updateTicket()
    }
    
    private func setupUI() {
        navigationItem.title = presenter.title
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(dateLabel)
        view.addSubview(qrCodeImageView)
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(qrCodeImageView.snp.bottom).offset(Constants.baseOffset * 2)
            $0.centerX.equalToSuperview()
        }
        
        qrCodeImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension TicketDetailsViewController: TicketDetailsPresenterProtocolOutput {
    func ticketUpdated(date: String, qrCodeImage: UIImage) {
        dateLabel.text = date
        qrCodeImageView.image = qrCodeImage
    }
}
