// MoviesViewModelProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Протокол вью модели экрана фильмов
protocol MoviesViewModelProtocol {
    var films: [Movie] { get set }
    var moviesPageInfo: Int? { get set }
    var category: PurchaseEndPoint { get set }
    var toDescriptionModule: IntHandler? { get set }
    var updateViewData: (() -> ())? { get set }
    var scrollViewData: (() -> ())? { get set }
    var listStateHandler: ((MoviesState) -> ())? { get set }
    var coordinator: MainCoordinatorProtocol? { get set }
    var alertData: StringHandler? { get set }
    var keychainHandler: VoidHandler? { get set }
    func fetchFilmsData()
    func loadMore()
    func updateMoviesCategory(sender: Int)
    func goFilmScreen(movie: Int)
    func setApiKey(_ key: String)
    func getApiKey()
}
