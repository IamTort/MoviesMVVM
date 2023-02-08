// MoviesViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Состояния экрана
enum MoviesState {
    case initial
    case loading
    case success
    case failure
}

typealias IntHandler = (Int) -> Void
typealias VoidHandler = () -> ()

/// Модель экрана фильмов
final class MoviesViewModel: MoviesViewModelProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let popular = "Популярное"
        static let topRated = "Топ"
        static let upcoming = "Скоро"
        static let cellIdentifier = "cell"
        static let chevronLeftImageName = "chevron.left"
        static let chevronRightImageName = "chevron.right"
        static let keyValue = "a5b0bb6ebe58602d88ccf2463076122b"
        static let key = "apiKey"
    }

    // MARK: - Public property

    let networkService: NetworkServiceProtocol
    let imageService: ImageServiceProtocol
    var coordinator: MainCoordinator?
    var updateViewData: VoidHandler?
    var scrollViewData: VoidHandler?
    var listStateHandler: ((MoviesState) -> ())?
    var alertData: StringHandler?
    var toDescriptionModule: IntHandler?
    var films: [Movie] = []

    // MARK: - Private property

    private var moviesPageInfo: Int?
    private var page = 1
    private var category = PurchaseEndPoint.popular

    // MARK: - Initializer

    init(imageService: ImageServiceProtocol, networkService: NetworkServiceProtocol, coordinator: MainCoordinator) {
        self.networkService = networkService
        self.imageService = imageService
        self.coordinator = coordinator
    }

    // MARK: - Public methods

    func fetchFilmsData() {
        UserDefaults.standard.set(Constants.keyValue, forKey: Constants.key)
        listStateHandler?(.loading)
        networkService.loadFilms(page: 1, api: PurchaseEndPoint.popular) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                self.films = result.filmsInfo
                self.moviesPageInfo = result.pageCount
                self.listStateHandler?(.success)
            case let .failure(error):
                print(error.localizedDescription)
                self.listStateHandler?(.failure)
            }
        }
    }

    func loadMore() {
        guard let pageInfo = moviesPageInfo,
              page < pageInfo else { return }
        page += 1
        listStateHandler?(.loading)
        networkService.loadFilms(page: page) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                self.films += result.filmsInfo
                self.listStateHandler?(.success)
            case let .failure(error):
                print(error.localizedDescription)
                self.listStateHandler?(.failure)
            }
        }
    }

    func updateMoviesCategory(sender: Int) {
        var category: PurchaseEndPoint {
            switch sender {
            case 0:
                return .popular
            case 1:
                return .topRated
            case 2:
                return .upcoming
            default:
                return .popular
            }
        }
        self.category = category
        listStateHandler?(.loading)
        fetch(api: category)
    }

    func fetch(api: PurchaseEndPoint) {
        networkService.loadFilms(page: 1, api: api) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movies):
                self.moviesPageInfo = movies.pageCount
                self.films = movies.filmsInfo
                self.scrollViewData?()
                self.listStateHandler?(.success)
            case let .failure(error):
                print(error.localizedDescription)
                self.listStateHandler?(.failure)
            }
        }
    }

    func goFilmScreen(movie: Int) {
        toDescriptionModule?(movie)
    }
}
