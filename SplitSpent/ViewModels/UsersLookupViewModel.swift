//
//  UsersLookupViewModel.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 09.03.2023.
//

import Foundation

class UsersLookupViewModel: ObservableObject {
    @Published var queryResultUsers: [User] = []
    
    func fetchUsers(with keyword: String) {
        
        FirebaseManager.shared.firestore.collection(User.firebaseName).whereField(User.firebaseKeywordsForLookup, arrayContains: keyword).getDocuments { querySnapshot, error in
            guard let documents = querySnapshot?.documents, error == nil else {
                print("No documents")
                return
            }
            self.queryResultUsers = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: User.self)
            }
        }
    }
}
