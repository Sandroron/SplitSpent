//
//  Group.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 04.03.2023.
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
    var name: String
    var users: [String]?
    var transactions: [Transaction]?
    var currencyBase: String?
}

protocol FirebaseEntity {
    
    static var firebaseName: String { get }
}
