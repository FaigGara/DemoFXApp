//
//  NSLayoutConstraintExtension.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 10.10.2024.
//

import UIKit

class NumberFormatterFactory {
    
    static func decimalNumberFormatter() -> Foundation.NumberFormatter {
        let formatter = Foundation.NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.decimalSeparator = "."
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 4
        return formatter
    }

}
