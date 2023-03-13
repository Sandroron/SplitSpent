//
//  FirebaseManager.swift
//  SplitSpent
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager: NSObject {
    
    let auth: Auth
//    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        auth = Auth.auth()
//        storage = Storage.storage()
        firestore = Firestore.firestore()
        
        super.init()
    }
}
