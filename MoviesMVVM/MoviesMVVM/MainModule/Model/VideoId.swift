// VideoId.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Модель массива информации о видео
struct ResultVideos: Decodable {
    let results: [VideoId]
}

/// Ключ от видео
struct VideoId: Decodable {
    let key: String
}
