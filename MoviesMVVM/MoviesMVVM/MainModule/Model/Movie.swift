// Movie.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель фильма
struct Movie: Decodable {
    /// Название фильма
    let title: String
    /// Идентификатор фильма
    let id: Int
    /// Описание фильма
    let overview: String
    /// Ссылка на постер фильма
    let poster: String
    /// Рейтинг фильма
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster = "poster_path"
        case rate = "vote_average"
    }
}
