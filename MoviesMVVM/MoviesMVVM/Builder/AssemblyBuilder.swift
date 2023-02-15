// AssemblyBuilder.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit

/// Сборщик модулей
final class AssemblyBuilder: AssemblyBuilderProtocol {
    // MARK: - Public methods

    func makeMainModule(coordinator: MainCoordinator) -> UIViewController {
        let keychainService = KeychainService()
        let networkService = NetworkService(keychainService: keychainService)
        let imageAPIService = ImageAPIService()
        let fileManager = FileManagerService()
        let proxy = Proxy(imageNetworkService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let coreDataService = CoreDataService()
        let moviesViewModel = MoviesViewModel(
            imageService: imageService,
            networkService: networkService,
            coreDataService: coreDataService,
            keychainService: keychainService
        )
        let view = MoviesViewController()
        view.moviesViewModel = moviesViewModel
        return view
    }

    func makeDetailModule(filmIndex: Int) -> UIViewController {
        let keychainService = KeychainService()
        let networkService = NetworkService(keychainService: keychainService)
        let imageAPIService = ImageAPIService()
        let fileManager = FileManagerService()
        let proxy = Proxy(imageNetworkService: imageAPIService, fileManagerService: fileManager)
        let imageService = ImageService(proxy: proxy)
        let coreDataService = CoreDataService()
        let filmViewModel = FilmViewModel(
            imageService: imageService,
            networkService: networkService,
            coreDataService: coreDataService,
            filmIndex: filmIndex
        )
        let view = FilmViewController(filmViewModel: filmViewModel)
        return view
    }
}
