// Proxy.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Прокси
final class Proxy: ProxyProtocol {
    // MARK: - Public property

    let imageAPIService: ImageAPIServiceProtocol
    let fileManagerService: FileManagerServiceProtocol

    // MARK: - Initializer

    init(imageNetworkService: ImageAPIServiceProtocol, fileManagerService: FileManagerServiceProtocol) {
        imageAPIService = imageNetworkService
        self.fileManagerService = fileManagerService
    }

    // MARK: - Public methods

    func loadImage(by url: String, completion: @escaping (Swift.Result<Data, Error>) -> ()) {
        guard let image = fileManagerService.getImageFromCache(url: url) else {
            imageAPIService.fetchData(byUrl: url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(data):
                    self.fileManagerService.saveImageToCache(url: url, data: data)
                    completion(.success(data))
                case let .failure(error):
                    completion(.failure(error))
                }
            }
            return
        }
        completion(.success(image))
    }
}
