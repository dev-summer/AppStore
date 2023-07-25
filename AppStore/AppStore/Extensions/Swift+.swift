//
//  Swift+.swift
//  AppStore
//
//  Created by summercat on 2023/07/17.
//

import Foundation

extension Double {
    var shortenedText: String {
        switch self {
        case ..<1_000:
            return String(format: "%.0f", self)
        case 1_000..<999_999:
            return String(format: "%.1fK", self / 1_000).replacingOccurrences(of: ".0", with: "")
        default:
            return String(format: "%.1fM", self / 1_000_000).replacingOccurrences(of: ".0", with: "")
        }
    }
}

extension Int {
    var languageCodeCount: String {
        switch self {
        case 0:
            return ""
        default:
            return "+ \(self) More"
        }
    }
}
