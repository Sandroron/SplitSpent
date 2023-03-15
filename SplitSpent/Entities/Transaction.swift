//
//  Transaction.swift
//  SplitSpent
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI
import PhotosUI

struct Transaction: Identifiable, Codable, Hashable, Comparable {
    
    @DocumentID var id: String? = UUID().uuidString
    var description: String?
    var photos: [String]?
    var photosDataInfo: PhotosDataInfo? = nil
    var expenses: [String : Double]
    
    static func < (lhs: Transaction, rhs: Transaction) -> Bool {
        
        if lhs.description == rhs.description {
            return lhs.id ?? "" < rhs.id ?? ""
        } else {
            return lhs.description ?? "Transaction" < rhs.description ?? "Transaction"
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case photos
        case expenses
    }
    
    struct PhotosDataInfo: Equatable, Hashable {
        
        var selectedItems: [PhotosPickerItem] = []
        var selectedPhotosData: [Data] = [Data]()
        var selectedPhotosImages: [UIImage]?
    }
}
