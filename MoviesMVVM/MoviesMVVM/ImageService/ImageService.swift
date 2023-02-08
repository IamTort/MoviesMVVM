// ImageService.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Сервис загрузки фото
final class ImageService: ImageServiceProtocol {
    // MARK: - Public property

    let proxy: ProxyProtocol

    // MARK: - Initializer

    init(proxy: ProxyProtocol) {
        self.proxy = proxy
    }

    // MARK: - Public methods

    func fetchImage(byUrl url: String, completion: @escaping (Swift.Result<Data, Error>) -> ()) {
        proxy.loadImage(by: url) { result in
            switch result {
            case let .success(data):
                completion(.success(data))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
