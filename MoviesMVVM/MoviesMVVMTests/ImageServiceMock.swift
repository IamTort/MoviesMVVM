// ImageServiceMock.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
@testable import MoviesMVVM

/// Мок сервиса по загрузке картинок
final class ImageServiceMock: ImageServiceProtocol {
    // MARK: - Private property

    private let mockUrl = "url"

    // MARK: - Public methods

    func fetchImage(byUrl url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        if url == mockUrl {
            let data = Data(count: 10)
            completion(.success(data))
        }
    }
}
