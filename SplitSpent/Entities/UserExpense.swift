//
//  UserExpense.swift
//  SplitSpent
//

import Foundation

struct UserExpense: Identifiable, Hashable {
    
    var id: String {
        email
    }
    var email: String
    var paid: Double
    var part: Double
    var owes: Double
    var owesTo: [String : Double]
}

extension UserExpense {
    init(email: String) {
        self.email = email
        paid = 0.0
        part = 0.0
        owes = 0.0
        owesTo = [:]
    }
}
