// Film.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель фильма
struct Film: Decodable {
    let id: Int
    let overview: String
    let poster: String
    let tagline: String
    let title: String
    let rate: Double
    let release: String
    let genres: [Genres]
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

/// Модель жанров
struct Genres: Decodable {
    let name: String
}
