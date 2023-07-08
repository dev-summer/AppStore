//
//  DateFormatter+shared.swift
//  AppStore
//
//  Created by summercat on 2023/07/07.
//

import Foundation

extension DateFormatter {
    static let formatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE d MMMM")
        
        return formatter
    }()
}
