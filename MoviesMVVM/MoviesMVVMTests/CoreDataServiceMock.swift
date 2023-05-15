// CoreDataServiceMock.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
@testable import MoviesMVVM

/// Мок сервиса кеширования данных
final class CoreDataServiceMock: CoreDataServiceProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let emptyString = ""
        static let titleString = "title"
        static let runtimeInt = 120
        static let rateDouble = 5.5
        static let checkNetworkInt = 5
    }

    // MARK: - Public property

    var alertHandler: StringHandler?

    // MARK: - Private property

    private var filmsMock = [Movie(title: Constants.titleString, id: 1, overview: "", poster: "", rate: 5.5)]

    // MARK: - Public methods

    func saveMovies(category: String, movies: [Movie]) {}

    func saveMovie(movie: MovieDetail) {}

    func getAllMovies(category: String) -> [Movie]? {
        if category == PurchaseEndPoint.popular.rawValue {
            return nil
        }
        return filmsMock
    }

    func getMovie(id: Int) -> MovieDetail? {
        if id == Constants.checkNetworkInt {
            return nil
        }
        return MovieDetail(
            id: id,
            overview: Constants.emptyString,
            poster: Constants.emptyString,
            tagline: Constants.emptyString,
            title: Constants.titleString,
            rate: Constants.rateDouble,
            release: Constants.emptyString,
            genres: nil,
            runtime: Constants.runtimeInt
        )
    }
}
