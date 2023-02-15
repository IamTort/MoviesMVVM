// NetworkServiceMock.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
@testable import MoviesMVVM

/// Мок сетевого сервиса
final class NetworkServiceMock: NetworkServiceProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let emptyString = ""
        static let titleString = "title"
        static let runtimeInt = 120
        static let rateDouble = 5.5
        static let checkNetworkInt = 5
    }

    // MARK: - Private property

    private let mockFilms = Results(
        filmsInfo: [Movie(title: "title", id: 1, overview: "", poster: "", rate: 5.5)],
        pageCount: 3000
    )

    // MARK: - Public methods

    func loadFilms(page: Int, completion: @escaping (Result<Results, Error>) -> Void) {
        completion(.success(mockFilms))
    }

    func loadFilms(page: Int, api: PurchaseEndPoint, completion: @escaping (Result<Results, Error>) -> Void) {
        completion(.success(mockFilms))
    }

    func loadFilm(index: Int, completion: @escaping (Result<MovieDetail, Error>) -> Void) {
        completion(.success(MovieDetail(
            id: index,
            overview: Constants.emptyString,
            poster: Constants.emptyString,
            tagline: Constants.emptyString,
            title: Constants.emptyString,
            rate: Constants.rateDouble,
            release: Constants.emptyString,
            genres: nil,
            runtime: Constants.runtimeInt
        )))
    }

    func loadVideos(index: Int, completion: @escaping (Result<[VideoId], Error>) -> Void) {}
}
