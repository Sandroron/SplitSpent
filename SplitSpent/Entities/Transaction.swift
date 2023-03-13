//
//  Transaction.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 04.03.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Transaction: Identifiable, Codable, Hashable, Comparable {
    
    @DocumentID var id: String? = UUID().uuidString
    var description: String?
    var expenses: [String : Double]
    
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.id ?? "" < rhs.id ?? ""
    }
}
