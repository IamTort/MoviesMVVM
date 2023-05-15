// KeychainServiceMock.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation
@testable import MoviesMVVM

/// Мок сервиса по сохранению ключа
final class KeychainServiceMock: KeychainServiceProtocol {
    // MARK: - Private property

    private var apiKey = ""

    // MARK: - Public methods

    func setAPIKey(_ value: String, forKey: String) {
        apiKey = value
    }

    func getAPIKey(_ key: String) -> String {
        apiKey
    }
}
