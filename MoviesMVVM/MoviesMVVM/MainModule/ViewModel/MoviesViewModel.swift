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

    var updateViewData: VoidHandler?
    var scrollViewData: VoidHandler?
    var listStateHandler: ((MoviesState) -> ())?
    var alertData: StringHandler?
    var toDescriptionModule: IntHandler?
    var keychainHandler: VoidHandler?
    var films: [Movie] = []
    var category = PurchaseEndPoint.popular
    var moviesPageInfo: Int?

    // MARK: - Private property

    private var keychainService: KeychainServiceProtocol
    private var coreDataService: CoreDataServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageServiceProtocol
    private var page = 1

    // MARK: - Initializer

    init(
        imageService: ImageServiceProtocol,
        networkService: NetworkServiceProtocol,
        coreDataService: CoreDataServiceProtocol,
        keychainService: KeychainServiceProtocol
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.coreDataService = coreDataService
        self.keychainService = keychainService
        returnError()
    }

    // MARK: - Public methods

    func fetchFilmsData() {
        listStateHandler?(.loading)
        if let items = coreDataService.getAllMovies(category: category.rawValue),
           !items.isEmpty
        {
            films = items
            moviesPageInfo = 30000
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
                case let .failure(error):
                    self.alertData?(error.localizedDescription)
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
            case let .failure(error):
                self.alertData?(error.localizedDescription)
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
                case let .failure(error):
                    self.alertData?(error.localizedDescription)
                    self.listStateHandler?(.failure)
                }
            }
        }
    }

    func goFilmScreen(movie: Int) {
        toDescriptionModule?(movie)
    }

    func setApiKey(_ key: String) {
        keychainService.setAPIKey(key, forKey: Constants.key)
        fetchFilmsData()
    }

    func getApiKey() {
        if !keychainService.getAPIKey(Constants.key).isEmpty {
            fetchFilmsData()
        } else {
            keychainHandler?()
        }
    }

    // MARK: - Private methods

    private func returnError() {
        coreDataService.alertHandler = { [weak self] error in
            self?.alertData?(error)
        }
    }
}
