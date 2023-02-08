// VideoId.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Модель массива информации о видео
struct ResultVideos: Decodable {
    /// Ссылки на видео тизеров
    let results: [VideoId]
}

/// Ключ от видео
struct VideoId: Decodable {
    /// Часть ссылки на страницу с фильмом
    let key: String
}
