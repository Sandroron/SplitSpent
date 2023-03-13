//
//  Expense.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 13.03.2023.
//

import Foundation

struct Expense: Identifiable, Hashable {
    
    var id: String = UUID().uuidString
    var email: String
    var value: String
}
