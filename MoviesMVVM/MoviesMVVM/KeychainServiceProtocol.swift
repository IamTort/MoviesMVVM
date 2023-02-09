// KeychainServiceProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Протокол сохранения файлов в песочницу
protocol KeychainServiceProtocol {
    // MARK: - Public methods

    func setAPIKey(_ value: String, forKey: String)
    func getAPIKey(_ key: String) -> String
}
