// CoreDataServiceProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

///  Протокол сервиса загрузки данных с БД
protocol CoreDataServiceProtocol {
    var alertHandler: StringHandler? { get set }
    func saveMovies(category: String, movies: [Movie])
    func saveMovie(movie: MovieDetail)
    func getAllMovies(category: String) -> [Movie]?
    func getMovie(id: Int) -> MovieDetail?
}
