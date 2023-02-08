// AssemblyBuilderProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit

/// Протокол билдера
protocol AssemblyBuilderProtocol {
    // MARK: - Public Methods

    func makeMainModule(coordinator: MainCoordinator) -> UIViewController
    func makeDetailModule(filmIndex: Int) -> UIViewController
}
