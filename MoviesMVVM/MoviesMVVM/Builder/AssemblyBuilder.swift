// AssemblyBuilder.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit

/// Сборщик модулей
final class AssemblyBuilder: AssemblyBuilderProtocol {
    // MARK: - Public methods

    func makeMainModule(coordinator: MainCoordinator) -> UIViewController {
        let networkService = NetworkService()
        let imageAPIService = ImageAPIService()
        let fileManager = FileManagerService()
        let proxy = Proxy(imageNetworkService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let moviesViewModel = MoviesViewModel(
            imageService: imageService,
            networkService: networkService,
            coordinator: coordinator
        )
        let view = MoviesViewController()
        view.moviesViewModel = moviesViewModel
        return view
    }

    func makeDetailModule(filmIndex: Int) -> UIViewController {
        let networkService = NetworkService()
        let imageAPIService = ImageAPIService()
        let fileManager = FileManagerService()
        let proxy = Proxy(imageNetworkService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let filmViewModel = FilmViewModel(
            imageService: imageService,
            networkService: networkService,
            filmIndex: filmIndex
        )
        let view = FilmViewController(filmViewModel: filmViewModel)
        return view
    }
}
