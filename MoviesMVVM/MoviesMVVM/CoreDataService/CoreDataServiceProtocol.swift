// CoreDataServiceProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

protocol CoreDataServiceProtocol {
    // MARK: - Public methods

    func saveMovies(category: String, movies: [Movie])
    func saveMovie(movie: Film)
    func getAllMovies(category: String) -> [Movie]?
    func getMovie(id: Int) -> Film?
}
