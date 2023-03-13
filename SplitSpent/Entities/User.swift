//
//  User.swift
//  SplitSpent
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable, FirebaseEntity {
    
    static var firebaseName = "Users"
    static var firebaseKeywordsForLookup = "keywordsForLookup"
    
    var id: String { email ?? "" }
    @DocumentID var email: String?
    var name: String
    var groupIds: [Int]?
    var keywordsForLookup: [String] {
        [name.generateStringSequence(), (email ?? "").generateStringSequence(), "\(name) \(email ?? "")".generateStringSequence()].flatMap { $0 }
    }

    enum CodingKeys: String, CodingKey {
        case email
        case name
        case groupIds
    }
}
