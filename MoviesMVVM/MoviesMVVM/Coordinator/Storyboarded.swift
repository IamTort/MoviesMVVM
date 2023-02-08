// Storyboarded.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Протокол для создания контроллера
protocol Storyboarded {
    static func instantiate() -> Self
}
