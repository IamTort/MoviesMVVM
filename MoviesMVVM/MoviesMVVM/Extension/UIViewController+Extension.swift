// UIViewController+Extension.swift
// Copyright © PozolotinaAA. All rights reserved.

import CoreData
import UIKit
import KeychainAccess

/// Расширение для универсального алерта
extension UIViewController {
    // MARK: - Constants

    private enum Constants {
        static let actionTitle = "ok"
    }

    // MARK: - Public methods

    func showErrorAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title,
            message:
            message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: Constants.actionTitle, style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    func showApiKeyAlert(title: String, message: String, handler: StringHandler?) {
        let alertController = UIAlertController(
            title: title,
            message:
            message,
            preferredStyle: .alert
        )
        alertController.addTextField()
        let action = UIAlertAction(title: Constants.actionTitle, style: .cancel) { _ in
            guard let key = alertController.textFields?.first?.text else { return }
            handler?(key)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
