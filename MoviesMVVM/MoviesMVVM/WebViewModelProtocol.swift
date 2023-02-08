// WebViewModelProtocol.swift
// Copyright © PozolotinaAA. All rights reserved.

import Foundation

/// Протокол вью модели вебвью
protocol WebViewModelProtocol {
    var filmIndex: Int? { get set }
    var dismiss: VoidHandler? { get set }
    var loadWebView: ((URL) -> ())? { get set }
    var alertData: StringHandler? { get set }
    func loadWebViewData()
}
