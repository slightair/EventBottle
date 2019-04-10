import UIKit

public class EventBottleViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    public let eventDataSource: EventDataSource

    private let tableView = UITableView()
    private let activityIndicatorView = UIActivityIndicatorView()
    private let activityIndicatorBackgroundView = UIView()
    private let errorMessageLabel = UILabel()
    private let errorMessageBackgroundView = UIView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let defaultRowHeight: CGFloat = 44

    private var isLoading = false {
        didSet {
            activityIndicatorBackgroundView.isHidden = !isLoading
        }
    }

    private var filteredEvents: [Event] = []

    public convenience init() {
        self.init(eventDataSource: EventBottleFileEventDataStore.shared.dataSource)
    }

    public init(eventDataSource: EventDataSource) {
        self.eventDataSource = eventDataSource

        super.init(nibName: nil, bundle: nil)

        title = "Events"
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setUpSubviews()

        refresh()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        refresh()
    }

    @objc private func refresh() {
        if isLoading {
            return
        }
        isLoading = true
        errorMessageBackgroundView.isHidden = true

        filteredEvents = []
        eventDataSource.load { success in
            if success {
                self.tableView.reloadData()
            } else {
                self.errorMessageBackgroundView.isHidden = false
            }
            self.isLoading = false
        }
    }

    private func setUpSubviews() {
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationItem.rightBarButtonItem = refreshButton

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.estimatedRowHeight = defaultRowHeight
        tableView.rowHeight = UITableView.automaticDimension

        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.defaultIdentifier)

        tableView.dataSource = self

        activityIndicatorView.style = .whiteLarge
        activityIndicatorView.startAnimating()

        activityIndicatorBackgroundView.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: activityIndicatorBackgroundView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: activityIndicatorBackgroundView.centerYAnchor).isActive = true

        activityIndicatorBackgroundView.backgroundColor = UIColor(white: 0.0, alpha: 0.3)

        view.addSubview(activityIndicatorBackgroundView)
        activityIndicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        activityIndicatorBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        activityIndicatorBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityIndicatorBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        errorMessageLabel.text = "Could not load events"
        errorMessageLabel.textColor = .darkGray

        errorMessageBackgroundView.addSubview(errorMessageLabel)
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.centerXAnchor.constraint(equalTo: errorMessageBackgroundView.centerXAnchor).isActive = true
        errorMessageLabel.centerYAnchor.constraint(equalTo: errorMessageBackgroundView.centerYAnchor).isActive = true

        errorMessageBackgroundView.backgroundColor = .white
        errorMessageBackgroundView.isHidden = true

        view.addSubview(errorMessageBackgroundView)
        errorMessageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        errorMessageBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorMessageBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        errorMessageBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorMessageBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false

        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
    }

    public func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return searchController.isActive ? filteredEvents.count : eventDataSource.events.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.defaultIdentifier, for: indexPath) as? EventCell else {
            fatalError("Unexpected cell")
        }

        let event = searchController.isActive ? filteredEvents[indexPath.row] : eventDataSource.events[indexPath.row]
        cell.event = event

        return cell
    }

    public func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""

        if searchText.isEmpty {
            filteredEvents = eventDataSource.events
            tableView.reloadData()
        } else {
            eventDataSource.filterdEvents(with: searchText) { result in
                self.filteredEvents = result
                self.tableView.reloadData()
            }
        }
    }
}
