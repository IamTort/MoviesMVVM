// KeychainService.swift
// Copyright © PozolotinaAA. All rights reserved.

import KeychainAccess

/// Сохранение файлов в песочницу
final class KeychainService: KeychainServiceProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let keychainServiceString = "ru.MoviesMVVM"
    }

    // MARK: - Private property

    private let keychain = Keychain(service: Constants.keychainServiceString)

    // MARK: - Public methods

    func setAPIKey(_ value: String, forKey: String) {
        keychain[forKey] = value
    }

    func getAPIKey(_ key: String) -> String {
        guard let keyValue = keychain[key] else { return String() }
        return keyValue
    }
}
