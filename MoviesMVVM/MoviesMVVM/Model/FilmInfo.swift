// FilmInfo.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Массив с фильмами
struct Result: Decodable {
    let filmsInfo: [FilmInfo]
    let pageCount: Int

    enum CodingKeys: String, CodingKey {
        case filmsInfo = "results"
        case pageCount = "total_pages"
    }
}

/// Модель фильма
struct FilmInfo: Decodable {
    let title: String
    let id: Int
    let overview: String
    let poster: String
    let rate: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case poster = "poster_path"
        case rate = "vote_average"
    }
}
