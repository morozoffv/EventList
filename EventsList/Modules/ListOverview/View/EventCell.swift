import UIKit

final class EventCell: UITableViewCell {
    
    enum Constants {
        static let reuseIdentifier = "eventCell"
        static let baseOffset: CGFloat = 8
    }
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.baseOffset
        return stackView
    }()
    
    private let eventNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(eventItem: EventItem) {
        eventNameLabel.text = eventItem.title
        dateLabel.text = eventItem.formattedDate
        priceLabel.text = eventItem.formattedPrice
    }
    
    private func setupLayout() {
        containerStackView.addArrangedSubview(eventNameLabel)
        containerStackView.addArrangedSubview(dateLabel)
        addSubview(containerStackView)
        addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.baseOffset)
            $0.top.equalToSuperview().offset(Constants.baseOffset)
            $0.bottom.equalToSuperview().offset(-Constants.baseOffset)
            $0.trailing.equalTo(priceLabel.snp.leading).offset(-Constants.baseOffset)
        }
        
        priceLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-Constants.baseOffset)
            $0.top.equalToSuperview().offset(Constants.baseOffset)
            $0.bottom.equalToSuperview().offset(-Constants.baseOffset)
        }
        
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
