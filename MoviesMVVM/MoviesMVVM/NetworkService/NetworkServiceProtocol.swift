// NetworkServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса загрузки фото
protocol NetworkServiceProtocol {
    // MARK: - Public Methods

    func loadFilms(page: Int, completion: @escaping (Swift.Result<Result, Error>) -> Void)
    func loadFilms(page: Int, api: PurchaseEndPoint, completion: @escaping (Swift.Result<Result, Error>) -> Void)
    func loadFilm(index: Int, completion: @escaping (Swift.Result<Film, Error>) -> Void)
    func loadVideos(index: Int, completion: @escaping (Swift.Result<[VideoId], Error>) -> Void)
}