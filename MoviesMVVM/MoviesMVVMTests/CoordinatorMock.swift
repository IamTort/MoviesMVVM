// CoordinatorMock.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
@testable import MoviesMVVM

/// Мок координатора
final class CoordinatorMock: MainCoordinatorProtocol {
    // MARK: - Public methods

    func showMoviesModule() {}

    func goFilmDetail(filmIndex: Int) {}
}
