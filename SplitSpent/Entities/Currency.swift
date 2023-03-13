//
//  Currency.swift
//  SplitSpent
//

import Foundation

struct Currency: Codable {
    var success: Bool
    var base: String
    var date: String
    var rates = [String: Double]()
}
