// WebViewController.swift
// Copyright © RoadMap. All rights reserved.

//
//  Created by angelina on 27.10.2022.
//
import UIKit
import WebKit

/// Экран вебвью
final class WebViewController: UIViewController {
    // MARK: - Private Enum

    private enum Constants {
        static let urlShemeHostPath = "https://www.themoviedb.org/movie/"
        static let urlFragment = "#play="
    }

    // MARK: - Private Visual Components

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    // MARK: - Private property

    private var filmInfo: [VideoId]?

    // MARK: - Public property

    var filmIndex: Int?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebViewData()
        setupUI()
    }

    // MARK: - Private methods

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(webView)
        createConstraints()
    }

    private func loadWebViewData() {
        guard let index = filmIndex else { return }
        Service.shared.loadVideos(index: index) { [weak self] result in

            guard result.count != 0,
                  let url =
                  URL(string: "\(Constants.urlShemeHostPath)\(index)\(Constants.urlFragment)\(result[0].key)")
            else {
                DispatchQueue.main.async {
                    self?.dismiss(animated: true)
                }
                return
            }
            DispatchQueue.main.async {
                self?.webView.load(URLRequest(url: url))
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
