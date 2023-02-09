// MoviesViewController.swift
// Copyright © PozolotinaAA. All rights reserved.

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
        static let errorTitle = "Error"
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

    private var activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()

    // MARK: - Public property

    var moviesViewModel: MoviesViewModelProtocol?
    var movieListState: MoviesState = .initial {
        didSet {
            DispatchQueue.main.async {
                self.view.setNeedsLayout()
            }
        }
    }

    // MARK: - Private property

    private let items = [Constants.popular, Constants.topRated, Constants.upcoming]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch movieListState {
        case .initial:
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
            tableView.isHidden = true
            moviesViewModel?.fetchFilmsData()
        case .loading:
            tableView.isHidden = true
        case .success:
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
        case .failure:
            alertView()
        }
    }

    // MARK: - Public method

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = maximumOffset - currentOffset

        guard deltaOffset <= 0 else { return }
        moviesViewModel?.loadMore()
    }

    // MARK: - Private methods

    private func alertView() {
        moviesViewModel?.alertData = { [weak self] alert in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(title: Constants.errorTitle, message: alert)
            }
        }
    }

    private func bind() {
        moviesViewModel?.listStateHandler = { [weak self] state in
            guard let self = self else { return }
            self.movieListState = state
        }

        moviesViewModel?.scrollViewData = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.setContentOffset(.zero, animated: true)
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
        view.addSubview(activityIndicatorView)
        createConstraint()
//        scrollTableView()
//        updateView()
        bind()
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
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),

            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func updateTableViewAction() {
        moviesViewModel?.updateMoviesCategory(sender: segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesViewModel?.films.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.cellIdentifier,
            for: indexPath
        ) as? FilmTableViewCell {
            guard let movies = moviesViewModel?.films else { return UITableViewCell() }
            cell.setupData(data: movies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        240
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let movies = moviesViewModel?.films else { return }
        let row = indexPath.row
        moviesViewModel?.goFilmScreen(movie: movies[row].id)
    }
}
