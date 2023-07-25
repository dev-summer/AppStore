//
//  DetailSection.swift
//  AppStore
//
//  Created by summercat on 2023/07/25.
//

enum DetailSection: Int, Hashable, CaseIterable {
    case top
    case summary
    case screenshot
    case description
//    case rating
    case releaseNote
    case information
}

extension DetailSection {
    func isValid(for app: App) -> Bool {
        switch self {
        case .releaseNote:
            return app.releaseNotes != nil && app.releaseNotes != .init()
        default:
            return true
        }
    }
}
