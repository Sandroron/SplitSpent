//
//  Transaction.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 04.03.2023.
//

import Foundation
import FirebaseFirestoreSwift

struct Transaction: Identifiable, Codable, Hashable {
    
    @DocumentID var id: String?
    var expenses: [String : Double]
}
