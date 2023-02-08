// ImageServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса загрузки фото
protocol ImageServiceProtocol {
    func fetchImage(byUrl url: String, completion: @escaping (Swift.Result<Data, Error>) -> ())
}
