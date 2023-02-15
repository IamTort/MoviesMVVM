// FilmViewModel.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Модель экрана фильма
final class FilmViewModel: FilmViewModelProtocol {
    // MARK: - Public property

    var filmIndex: Int?
    var filmInfo: MovieDetail?
    var updateViewData: VoidHandler?
    var imageData: DataHandler?
    var alertData: StringHandler?

    // MARK: - Private property

    private var coreDataService: CoreDataServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageServiceProtocol

    // MARK: - Initializer

    init(
        imageService: ImageServiceProtocol,
        networkService: NetworkServiceProtocol,
        coreDataService: CoreDataServiceProtocol,
        filmIndex: Int?
    ) {
        self.networkService = networkService
        self.imageService = imageService
        self.coreDataService = coreDataService
        self.filmIndex = filmIndex
        returnError()
    }

    // MARK: - Public methods

    func loadFilmData() {
        guard let index = filmIndex else { return }
        if let item = coreDataService.getMovie(id: index) {
            filmInfo = item
            updateViewData?()
        } else {
            networkService.loadFilm(index: index) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(movie):
                    self.filmInfo = movie
                    self.coreDataService.saveMovie(movie: movie)
                    self.updateViewData?()
                case let .failure(error):
                    self.alertData?(error.localizedDescription)
                }
            }
        }
    }

    func loadImage() {
        guard let image = filmInfo?.poster else { return }
        imageService.fetchImage(byUrl: "\(PurchaseEndPoint.link.rawValue)\(image)") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                self.imageData?(data)
            case let .failure(error):
                self.alertData?(error.localizedDescription)
            }
        }
    }

    // MARK: - Private methods

    private func returnError() {
        coreDataService.alertHandler = { [weak self] error in
            self?.alertData?(error)
        }
    }
}
