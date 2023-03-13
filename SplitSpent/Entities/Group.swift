//
//  Group.swift
//  SplitSpent
//

import Foundation
import FirebaseFirestoreSwift

struct Group: Identifiable, Codable, FirebaseEntity {
    
    static var firebaseName: String {
        get {
            return "Groups"
        }
    }
    
    @DocumentID var id: String?
    var title: String
    var users: [String]?
    var transactions: [Transaction]?
    var currencyBase: String?
}

extension Group {
    
    init() {
        title = ""
    }
}
