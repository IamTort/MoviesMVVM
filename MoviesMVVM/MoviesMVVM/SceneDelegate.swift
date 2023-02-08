// SceneDelegate.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit

/// SceneDelegate
final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var coordinator: ApplicationCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let assemblyBuilder = AssemblyBuilder()
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.makeKeyAndVisible()
        coordinator = ApplicationCoordinator(assemblyBuilder: assemblyBuilder)
        coordinator?.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
}
