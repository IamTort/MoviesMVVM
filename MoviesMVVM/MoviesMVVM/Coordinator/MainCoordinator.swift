// MainCoordinator.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit

/// Координатор экрана фильмов
final class MainCoordinator: BaseCoordinator {
    // MARK: - Public property

    var builder: AssemblyBuilderProtocol?
    var rootNavController: UINavigationController?

    // MARK: - Initializers

    convenience init(builder: AssemblyBuilderProtocol?) {
        self.init()
        self.builder = builder
    }

    // MARK: - Public methods

    override func start() {
        showMoviesModule()
    }

    func showMoviesModule() {
        guard let vc = builder?.makeMainModule(coordinator: self) as? MoviesViewController else { return }
        vc.moviesViewModel?.toDescriptionModule = { id in
            self.goFilmDetail(filmIndex: id)
        }
        let rootController = UINavigationController(rootViewController: vc)
        setAsRoot(rootController)
        rootNavController = rootController
    }

    func goFilmDetail(filmIndex: Int) {
        guard let vc = builder?.makeDetailModule(filmIndex: filmIndex) as? FilmViewController else { return }
        rootNavController?.pushViewController(vc, animated: true)
    }
}
