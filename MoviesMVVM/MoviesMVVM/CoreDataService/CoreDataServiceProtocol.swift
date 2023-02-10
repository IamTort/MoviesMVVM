// CoreDataServiceProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

///  Протокол сервиса загрузки данных с БД
protocol CoreDataServiceProtocol {
    // MARK: - Public property
    
    var alertHandler: StringHandler? { get set }
    
    // MARK: - Public methods

    func saveMovies(category: String, movies: [Movie])
    func saveMovie(movie: Film)
    func getAllMovies(category: String) -> [Movie]?
    func getMovie(id: Int) -> Film?
}
