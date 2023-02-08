// CoordinatorProtocol.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Протокол для координатора
protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
