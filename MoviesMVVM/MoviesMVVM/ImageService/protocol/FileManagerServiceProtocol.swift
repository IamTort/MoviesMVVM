// FileManagerServiceProtocol.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол сервиса загрузки фото с кеша
protocol FileManagerServiceProtocol {
    func getImageFromCache(url: String) -> Data?
    func saveImageToCache(url: String, data: Data)
}
