// FilmViewModelProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Протокол модели экрана фильма
protocol FilmViewModelProtocol {
    var updateViewData: VoidHandler? { get set }
    var alertData: StringHandler? { get set }
    var filmInfo: MovieDetail? { get set }
    var imageData: ((Data) -> ())? { get set }
    func loadFilmData()
    func loadImage()
}
