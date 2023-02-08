// Storyboarded.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Протокол для создания контроллера
protocol Storyboarded {
    static func instantiate() -> Self
}
