// NSMutableAttributedString + Extension.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// изменение конфигурации строки
extension NSMutableAttributedString {
    func normal(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir-Heavy", size: 24) as Any,
            .foregroundColor: UIColor.label
        ]
        append(NSAttributedString(string: value, attributes: attributes))
        return self
    }

    func normalGray(_ value: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "Avenir-Heavy", size: 24) as Any,
            .foregroundColor: UIColor.secondaryLabel
        ]
        append(NSAttributedString(string: value, attributes: attributes))
        return self
    }
}
