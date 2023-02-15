// MockProxy.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
@testable import MoviesMVVM

/// Мок прокси сервиса
final class MockProxy: ProxyProtocol {
    // MARK: - Private property

    private let mockUrl = "url"

    // MARK: - Public methods

    func loadImage(by url: String, completion: @escaping (Result<Data, Error>) -> ()) {
        if url == mockUrl {
            let data = Data(count: 10)
            completion(.success(data))
        }
    }
}
