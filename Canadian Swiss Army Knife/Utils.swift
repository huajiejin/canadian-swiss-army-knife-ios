//
//  Utils.swift
//  Canadian Swiss Army Knife
//
//  Created by Jin on 2022-12-09.
//

import Foundation

class Utils {
    static let numberFormatter : NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
}
