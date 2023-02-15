// CoreDataService.swift
// Copyright © PozolotinaAA. All rights reserved.

import CoreData
import UIKit

///  Загрузка данных с БД
final class CoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let movieObjectString = "MovieObject"
        static let movieDetailObjectString = "MovieDetailObject"
        static let emptyString = ""
        static let failSaveString = "Failed to save movie: "
        static let failRetrieveString = "Failed to retrieve movies:"
    }

    // MARK: - Public property

    var alertHandler: StringHandler?

    // MARK: - Private property

    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    // MARK: - Public methods

    func saveMovies(category: String, movies: [Movie]) {
        context?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: Constants.movieObjectString, in: context)
        else { return }
        do {
            movies.forEach { movie in
                let object = MovieObject(entity: entity, insertInto: context)
                object.title = movie.title
                object.id = Int64(movie.id)
                object.overview = movie.overview
                object.poster = movie.poster
                object.rate = movie.rate
                object.category = category
            }
            try context.save()
        } catch {
            alertHandler?("\(Constants.failSaveString) \(error.localizedDescription)")
        }
    }

    func saveMovie(movie: MovieDetail) {
        context?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let context = context,
              let entity = NSEntityDescription.entity(forEntityName: Constants.movieDetailObjectString, in: context)
        else { return }
        do {
            let object = MovieDetailObject(entity: entity, insertInto: context)
            object.title = movie.title
            object.id = Int64(movie.id)
            object.overview = movie.overview
            object.poster = movie.poster
            object.rate = movie.rate
            object.releases = movie.release
            object.tagline = movie.tagline
            object.runtime = Int64(movie.runtime)
            try context.save()
        } catch {
            alertHandler?("\(Constants.failSaveString) \(error.localizedDescription)")
        }
    }

    func getAllMovies(category: String) -> [Movie]? {
        let fetch = MovieObject.fetchRequest()
        var movies: [Movie] = []
        do {
            guard let movieEntities = try context?.fetch(fetch) else { return nil }
            for movieEntity in movieEntities {
                if movieEntity.category == category {
                    let movie = Movie(
                        title: movieEntity.title ?? Constants.emptyString,
                        id: Int(movieEntity.id),
                        overview: movieEntity.overview ?? Constants.emptyString,
                        poster: movieEntity.poster ?? Constants.emptyString,
                        rate: movieEntity.rate
                    )
                    movies.append(movie)
                }
            }
        } catch {
            alertHandler?("\(Constants.failRetrieveString) \(error.localizedDescription)")
        }
        return movies
    }

    func getMovie(id: Int) -> MovieDetail? {
        let fetch = MovieDetailObject.fetchRequest()
        var movie: MovieDetail
        do {
            guard let movieEntities = try context?.fetch(fetch) else { return nil }
            for movieEntity in movieEntities {
                if movieEntity.id == id {
                    movie = MovieDetail(
                        id: Int(movieEntity.id),
                        overview: movieEntity.overview ?? Constants.emptyString,
                        poster: movieEntity.poster ?? Constants.emptyString,
                        tagline: movieEntity.tagline ?? Constants.emptyString,
                        title: movieEntity.title ?? Constants.emptyString,
                        rate: movieEntity.rate,
                        release: movieEntity.releases ?? Constants.emptyString,
                        genres: nil,
                        runtime: Int(movieEntity.runtime)
                    )
                    return movie
                }
            }
        } catch {
            alertHandler?("\(Constants.failRetrieveString) \(error.localizedDescription)")
        }
        return nil
    }
}
