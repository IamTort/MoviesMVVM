// ImageAPIService.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Загрузка фото с сети
final class ImageAPIService: ImageAPIServiceProtocol {
    // MARK: - Public methods

    func fetchData(byUrl url: String, completion: @escaping (Swift.Result<Data, Error>) -> ()) {
        guard let url = URL(string: url) else { return }
        do {
            let data = try Data(contentsOf: url)
            DispatchQueue.main.async {
                completion(.success(data))
            }
        } catch {
            completion(.failure(error))
        }
    }
}
