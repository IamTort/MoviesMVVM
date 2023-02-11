// AppDelegate.swift
// Copyright © PozolotinaAA. All rights reserved.

import CoreData
import UIKit

/// AppDelegate
@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Private Enum

    private enum Constants {
        static let modelNameString = "MovieEntity"
        static let defaultConfigString = "Default Configuration"
        static let errorString = "Unresolved error"
    }
    
    // MARK: - Public property
    
    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.modelNameString)
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("\(Constants.errorString) \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Public methods
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: Constants.defaultConfigString, sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessionsSet: Set<UISceneSession>
    ) {}

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(Constants.errorString) \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
