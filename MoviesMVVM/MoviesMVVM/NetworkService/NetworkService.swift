// NetworkService.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
import KeychainAccess

/// Типы запросов
enum PurchaseEndPoint: String {
    case link = "https://image.tmdb.org/t/p/w500"
    case popular = "/3/movie/popular"
    case topRated = "/3/movie/top_rated"
    case upcoming = "/3/movie/upcoming"
}

/// Класс, отвечающий за загрузку даннных с сервера
final class NetworkService: NetworkServiceProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let queryItemKeyName = "api_key"
        static let apiValueKeyName = "apiKey"
        static let queryItemLanguageName = "language"
        static let queryItemLanguageValue = "ru-Ru"
        static let queryItemPageName = "page"
        static let componentScheme = "https"
        static let componentsHost = "api.themoviedb.org"
        static let componentsPath = "/3/movie/"
        static let videos = "/videos"
    }

    // MARK: - Private property

    private lazy var queryItemKey = URLQueryItem(
        name: Constants.queryItemKeyName,
        value: keychainService.getAPIKey(Constants.apiValueKeyName)
    )
    private let queryItemLanguage = URLQueryItem(
        name: Constants.queryItemLanguageName,
        value: Constants.queryItemLanguageValue
    )

    private var category = PurchaseEndPoint.popular
    private var keychainService: KeychainServiceProtocol
    private var session: URLSession = {
        let session = URLSession(configuration: .default)
        return session
    }()

    init(keychainService: KeychainServiceProtocol) {
        self.keychainService = keychainService
    }

    // MARK: - Public methods

    func loadFilms(page: Int, completion: @escaping (Swift.Result<Result, Error>) -> Void) {
        loadFilms(page: page, api: category, completion: completion)
    }

    func loadFilms(page: Int, api: PurchaseEndPoint, completion: @escaping (Swift.Result<Result, Error>) -> Void) {
        category = api

        let queryItemPage = URLQueryItem(name: Constants.queryItemPageName, value: "\(page)")

        var components = URLComponents()
        components.scheme = Constants.componentScheme
        components.host = Constants.componentsHost
        components.path = api.rawValue
        components.queryItems = [queryItemKey, queryItemLanguage, queryItemPage]

        loadObject(urlComponents: components, completion: completion)
    }

    func loadFilm(index: Int, completion: @escaping (Swift.Result<MovieDetail, Error>) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.componentScheme
        components.host = Constants.componentsHost
        components.path = Constants.componentsPath + "\(index)"
        components.queryItems = [queryItemKey, queryItemLanguage]

        loadObject(urlComponents: components, completion: completion)
    }

    func loadVideos(index: Int, completion: @escaping (Swift.Result<[VideoId], Error>) -> Void) {
        var components = URLComponents()
        components.scheme = Constants.componentScheme
        components.host = Constants.componentsHost
        components.path = Constants.componentsPath + "\(index)" + Constants.videos
        components.queryItems = [queryItemKey, queryItemLanguage]

        loadObject(urlComponents: components, completion: completion)
    }

    func loadObject<ResponseType: Decodable>(
        urlComponents: URLComponents,
        completion: @escaping (Swift.Result<ResponseType, Error>) -> Void
    ) {
        guard let url = urlComponents.url else { return }
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let result = try JSONDecoder().decode(ResponseType.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
