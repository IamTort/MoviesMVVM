// FilmViewModel.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель экрана фильма
final class FilmViewModel: FilmViewModelProtocol {
    // MARK: - Public property

    let networkService: NetworkServiceProtocol
    let imageService: ImageServiceProtocol
    var filmIndex: Int?
    var filmInfo: Film?
    var updateViewData: VoidHandler?
    var imageData: ((Data) -> ())?
    var alertData: StringHandler?

    // MARK: - Initializer

    init(imageService: ImageServiceProtocol, networkService: NetworkServiceProtocol, filmIndex: Int?) {
        self.networkService = networkService
        self.imageService = imageService
        self.filmIndex = filmIndex
    }

    // MARK: - Public methods

    func loadFilmData() {
        guard let index = filmIndex else { return }
        networkService.loadFilm(index: index) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(movie):
                self.filmInfo = movie
                self.updateViewData?()
            case let .failure(error):
                self.alertData?(error.localizedDescription)
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
}
