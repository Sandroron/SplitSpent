//
//  Expense.swift
//  SplitSpent
//

import Foundation

struct Expense: Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var email: String
    var value: String
}
