// MoviesViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

///  Контроллер экрана Фильмы
final class MoviesViewController: UIViewController {
    // MARK: - Private Enum

    private enum Constants {
        static let popular = "Популярное"
        static let topRated = "Топ"
        static let upcoming = "Скоро"
        static let cellIdentifier = "cell"
        static let chevronLeftImageName = "chevron.left"
        static let chevronRightImageName = "chevron.right"
        static let movies = "Фильмы"
        static let keyValue = "a5b0bb6ebe58602d88ccf2463076122b"
        static let key = "apiKey"
    }

    // MARK: - Private Visual Components

    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: items)
        segment.tintColor = UIColor.black
        segment.selectedSegmentIndex = 0
        segment.selectedSegmentTintColor = .systemGray2
        segment.addTarget(self, action: #selector(updateTableViewAction), for: .allEvents)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()

    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        return tableView
    }()

    // MARK: - Private property

    private let items = [Constants.popular, Constants.topRated, Constants.upcoming]
    private var pageInfo: Int?
    private var films: [FilmInfo] = []
    private var page = 1

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadFilmsData()
        setupUI()
    }

    // MARK: - Private methods

    private func loadFilmsData() {
        UserDefaults.standard.set(Constants.keyValue, forKey: Constants.key)
        Service.shared.loadFilms(page: 1, api: PurchaseEndPoint.popular) { [weak self] result in
            self?.films = result.filmsInfo
            self?.pageInfo = result.pageCount
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func setupUI() {
        tableView.dataSource = self
        tableView.delegate = self
        navigationItem.title = Constants.movies
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(segmentedControl)
        createConstraint()
    }

    private func loadMore(page: Int) {
        Service.shared.loadFilms(page: page) { [weak self] result in
            self?.films += result.filmsInfo
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    private func createConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),

            segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40)

        ])
    }

    @objc private func updateTableViewAction() {
        var category: PurchaseEndPoint {
            switch segmentedControl.selectedSegmentIndex {
            case 0: return .popular
            case 1: return .topRated
            case 2: return .upcoming
            default:
                return .popular
            }
        }

        Service.shared.loadFilms(page: 1, api: category) { [weak self] result in
            self?.pageInfo = result.pageCount
            self?.films = result.filmsInfo
            DispatchQueue.main.async {
                self?.tableView.setContentOffset(.zero, animated: true)
                self?.tableView.reloadData()
            }
        }
    }

    // MARK: - Public method

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        guard let pageInfo = pageInfo,
              deltaOffset <= 0,
              page < pageInfo else { return }
        page += 1
        loadMore(page: page)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as? FilmTableViewCell {
            cell.setupData(data: films[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        240
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let row = indexPath.row
        let fvc = FilmViewController()
        fvc.filmIndex = films[row].id
        navigationController?.pushViewController(fvc, animated: true)
    }
}
