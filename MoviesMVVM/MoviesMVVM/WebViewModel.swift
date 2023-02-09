// WebViewModel.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Вью модель экрана вебвью
final class WebViewModel: WebViewModelProtocol {
    // MARK: - Private Enum

    private enum Constants {
        static let urlShemeHostPath = "https://www.themoviedb.org/movie/"
        static let urlFragment = "#play="
    }

    var filmIndex: Int?
    let networkService = NetworkService(keychainService: KeychainService())
    var dismiss: VoidHandler?
    var loadWebView: ((URL) -> ())?
    var alertData: StringHandler?

    func loadWebViewData() {
        guard let index = filmIndex else { return }
        networkService.loadVideos(index: index) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(result):
                guard result.count != 0,
                      let url =
                      URL(string: "\(Constants.urlShemeHostPath)\(index)\(Constants.urlFragment)\(result[0].key)")
                else {
                    self.dismiss?()
                    return
                }
                self.loadWebView?(url)
            case let .failure(error):
                self.alertData?(error.localizedDescription)
            }
        }
    }
}
