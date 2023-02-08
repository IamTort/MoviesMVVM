// WebViewController.swift
// Copyright © PozolotinaAA. All rights reserved.

import UIKit
import WebKit

/// Экран вебвью
final class WebViewController: UIViewController {
    // MARK: - Private Enum

    private enum Constants {
        static let errorString = "Error"
    }

    // MARK: - Private Visual Components

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - Public property

    var webViewModel: WebViewModelProtocol?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        webViewModel?.loadWebViewData()
        setupUI()
    }

    // MARK: - Private methods

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(webView)
        createConstraints()
        alertView()
        dismissView()
        loadWebView()
    }

    private func alertView() {
        webViewModel?.alertData = { [weak self] alert in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.showErrorAlert(title: Constants.errorString, message: alert)
            }
        }
    }

    private func dismissView() {
        webViewModel?.dismiss = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }

    private func loadWebView() {
        webViewModel?.loadWebView = { [weak self] url in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.webView.load(URLRequest(url: url))
            }
        }
    }

    private func createConstraints() {
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - WKNavigationDelegate, WKUIDelegate

extension WebViewController: WKNavigationDelegate, WKUIDelegate {}
