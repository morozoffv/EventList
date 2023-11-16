import UIKit
import SnapKit

final class EventDetailsViewController: UIViewController {
    
    private enum Constants {
        static let baseOffset: CGFloat = 8
    }
    
    private let presenter: EventDetailsPresenterProtocol
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()

    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()

    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = .medium
        return activityIndicator
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()

    init(presenter: EventDetailsPresenterProtocol) {
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
        presenter.loadDetails()
    }
    
    private func setupUI() {
        navigationItem.title = presenter.title
        view.backgroundColor = .white
        activityIndicator.isHidden = true
        
        buyButton.addTarget(self, action: #selector(buyTicket(_:)), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let containerStackView = UIStackView()
        containerStackView.axis = .vertical
        containerStackView.distribution = .fill
        
        view.addSubview(stackView)
        
        [dateLabel, addressLabel, phoneLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
        
        [titleLabel, descriptionLabel, containerStackView, buyButton, activityIndicator].forEach {
            stackView.addArrangedSubview($0)
        }
        
        view.addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.baseOffset)
            $0.trailing.equalToSuperview().offset(-Constants.baseOffset)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.baseOffset * 2)
            $0.bottom.equalToSuperview().offset(-Constants.baseOffset * 2)
        }
        
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func buyTicket(_ sender: AnyObject) {
        presenter.buyTicket()
    }
}

extension EventDetailsViewController: EventDetailsPresenterProtocolOutput {
    func eventDetailsLoaded(eventDetails: EventDetailsModel) {
        stackView.isHidden = false
        titleLabel.text = eventDetails.title
        descriptionLabel.text = eventDetails.subtitle
        dateLabel.text = eventDetails.date.formattedString
        addressLabel.text = eventDetails.address
        phoneLabel.text = eventDetails.phone
    }
    
    func presentError() {
        errorLabel.isHidden = false
        errorLabel.text = presenter.errorMessage
    }
    
    func startLoading() {
        buyButton.isHidden = true
        activityIndicator.isHidden = false
    }
    
    func endLoading() {
        buyButton.isHidden = false
        activityIndicator.isHidden = true
    }
    
    func updateBuyButton(buyButtonTitle: String) {
        buyButton.setTitle(buyButtonTitle, for: .normal)
    }
}
