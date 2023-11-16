import UIKit
import SnapKit

final class ListOverviewViewController: UIViewController {
    
    private let presenter: ListOverviewPresenterProtocol
        
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    private let sortByDateButton = UIButton(type: .system)
    private let sortByPriceButton = UIButton(type: .system)
    private let filterUpcomingButton = UIButton(type: .system)
    
    private let dashboardStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    init(presenter: ListOverviewPresenterProtocol) {
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
        presenter.loadEvents()
    }
    
    private func setupUI() {
        navigationItem.title = presenter.title
        view.backgroundColor = .white
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.Constants.reuseIdentifier)
        
        sortByDateButton.setTitle(presenter.sortByDateButtonTitle, for: .normal)
        sortByPriceButton.setTitle(presenter.sortByPriceButtonTitle, for: .normal)
        filterUpcomingButton.setTitle(presenter.upcomingButtonTitle, for: .normal)

        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        sortByDateButton.addTarget(self, action: #selector(sortByDate(_:)), for: .touchUpInside)
        sortByPriceButton.addTarget(self, action: #selector(sortByPrice(_:)), for: .touchUpInside)
        filterUpcomingButton.addTarget(self, action: #selector(filterUpcoming(_:)), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        
        view.addSubview(dashboardStackView)
        [sortByDateButton, sortByPriceButton, filterUpcomingButton].forEach {
            dashboardStackView.addArrangedSubview($0)
        }
        
        view.addSubview(errorLabel)
    }
    
    private func setupConstraints() {
        dashboardStackView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.height.equalTo(42)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.top.equalTo(dashboardStackView.snp.bottom)
        }
        
        errorLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension ListOverviewViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.eventItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.Constants.reuseIdentifier) as? EventCell else {
            return UITableViewCell()
        }
        
        let model = presenter.eventItems[indexPath.row]
        cell.configure(eventItem: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = presenter.eventItems[indexPath.row]
        presenter.showDetails(for: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        presenter.loadEvents()
    }
    
    @objc func sortByDate(_ sender: AnyObject) {
        presenter.toggleSortEvents(by: \EventItem.date)
    }

    @objc func sortByPrice(_ sender: AnyObject) {
        presenter.toggleSortEvents(by: \EventItem.price)
    }

    @objc func filterUpcoming(_ sender: AnyObject) {
        presenter.filterUpcoming()
    }
}

extension ListOverviewViewController: ListOverviewPresenterOutput {
    
    func eventsUpdated() {
        errorLabel.isHidden = true
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func presentError() {
        errorLabel.isHidden = false
        errorLabel.text = presenter.errorMessage
    }
}

