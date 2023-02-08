// ApplicationCoordinator.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Стартовый координатор
final class ApplicationCoordinator: BaseCoordinator {
    // MARK: - Public property

    var assemblyBuilder: AssemblyBuilderProtocol?

    // MARK: - Initializer

    convenience init(assemblyBuilder: AssemblyBuilderProtocol?) {
        self.init()
        self.assemblyBuilder = assemblyBuilder
    }

    // MARK: - Public Methods

    override func start() {
        toMovieList()
    }

    // MARK: - Private Methods

    private func toMovieList() {
        let coordinator = MainCoordinator(builder: assemblyBuilder)
        addDependency(coordinator)
        coordinator.start()
    }
}
