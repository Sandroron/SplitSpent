//
//  AuthViewModel.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 09.03.2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    let auth = FirebaseManager.shared.auth
    
    @Published var signedIn = false
    
    var isSignedIn: Bool { // userIsAuthenticated
        return auth.currentUser != nil
    }
    
    var id: String? {
        auth.currentUser?.uid
    }
    
    func signIn(email: String, password: String) {
        
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        
        auth.createUser(withEmail: email,
                        password: password) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
            
            self?.addUser(user: User(email: email, name: name))
        }
    }
    
    func signOut() {
        
        do {
            try auth.signOut()
            signedIn = false
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func addUser(user: User) {
        
        do {
//            let document = try FirebaseManager.shared.firestore.collection(User.firebaseName).addDocument(from: user)
            
            let document = FirebaseManager.shared.firestore.collection(User.firebaseName).document(user.id)
            try document.setData(from: user)
            document.updateData([User.firebaseKeywordsForLookup: user.keywordsForLookup])
            
        } catch {
            print("Error adding: \(error)")
        }
    }
    
    private func updateUser(user: User) {
//        guard userIsAuthenticatedAndSynced else { return }
        do {
            let document = FirebaseManager.shared.firestore.collection(User.firebaseName).document(user.id)
            try document.setData(from: user)
            document.updateData([User.firebaseKeywordsForLookup: user.keywordsForLookup])
        } catch {
            print("Error updating: \(error)")
        }
    }
}
