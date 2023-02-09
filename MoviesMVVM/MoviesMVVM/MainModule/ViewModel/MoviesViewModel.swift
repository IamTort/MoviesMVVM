// MoviesViewModel.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
import KeychainAccess

/// Состояния экрана
enum MoviesState {
    case initial
    case loading
    case success
    case failure
}

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

    var coordinator: MainCoordinator?
    var updateViewData: VoidHandler?
    var scrollViewData: VoidHandler?
    var listStateHandler: ((MoviesState) -> ())?
    var alertData: StringHandler?
    var toDescriptionModule: IntHandler?
    var films: [Movie] = []

    // MARK: - Private property

    private let coreDataService: CoreDataService
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageServiceProtocol
    private var moviesPageInfo: Int?
    private var page = 1
    private var category = PurchaseEndPoint.popular
    private var moviess: [Movie] = []

    // MARK: - Initializer

    init(
        imageService: ImageServiceProtocol,
        networkService: NetworkServiceProtocol,
        coordinator: MainCoordinator,
        coreDataService: CoreDataService
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.coordinator = coordinator
        self.coreDataService = coreDataService
    }

    // MARK: - Public methods

    func fetchFilmsData() {
        listStateHandler?(.loading)
        if let items = coreDataService.getAllMovies(category: category.rawValue),
           !items.isEmpty
        {
            films = items
            listStateHandler?(.success)
        } else {
            networkService.loadFilms(page: 1, api: PurchaseEndPoint.popular) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(result):
                    self.films = result.filmsInfo
                    self.coreDataService.saveMovies(category: self.category.rawValue, movies: result.filmsInfo)
                    self.moviesPageInfo = result.pageCount
                    self.listStateHandler?(.success)
                case .failure:
                    self.listStateHandler?(.failure)
                }
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
                self.coreDataService.saveMovies(category: self.category.rawValue, movies: result.filmsInfo)
                self.listStateHandler?(.success)
            case .failure:
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
        fetchMoviesNewCategory(api: category)
    }

    func fetchMoviesNewCategory(api: PurchaseEndPoint) {
        if let items = coreDataService.getAllMovies(category: category.rawValue),
           !items.isEmpty
        {
            films = items
            scrollViewData?()
            listStateHandler?(.success)
        } else {
            networkService.loadFilms(page: 1, api: api) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(movies):
                    self.moviesPageInfo = movies.pageCount
                    self.films = movies.filmsInfo
                    self.coreDataService.saveMovies(category: self.category.rawValue, movies: movies.filmsInfo)
                    self.scrollViewData?()
                    self.listStateHandler?(.success)
                case .failure:
                    self.listStateHandler?(.failure)
                }
            }
        }
    }

    func goFilmScreen(movie: Int) {
        toDescriptionModule?(movie)
    }
}
