// ImageAPIServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса загрузки фото с сети
protocol ImageAPIServiceProtocol {
    func fetchData(byUrl url: String, completion: @escaping (Swift.Result<Data, Error>) -> ())
}
