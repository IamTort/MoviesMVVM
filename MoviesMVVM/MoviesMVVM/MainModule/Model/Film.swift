// Film.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Модель фильма
struct Film: Decodable {
    /// Идентификатор фильма
    let id: Int
    /// Описание фильма
    let overview: String
    /// Ссылка на постер фильма
    let poster: String
    /// Девиз
    let tagline: String
    /// Название фильма
    let title: String
    /// Рейтинг фильма
    let rate: Double
    /// Дата выпуска
    let release: String
    /// Жанры фильма
    let genres: [Genres]
    /// Длительность фильма
    let runtime: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case tagline
        case overview
        case genres
        case runtime
        case poster = "poster_path"
        case rate = "vote_average"
        case release = "release_date"
    }
}
