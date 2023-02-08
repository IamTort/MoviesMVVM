// Result.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Массив с фильмами
struct Result: Decodable {
    /// Фильмы
    let filmsInfo: [Movie]
    /// Количество страниц
    let pageCount: Int

    enum CodingKeys: String, CodingKey {
        case filmsInfo = "results"
        case pageCount = "total_pages"
    }
}
