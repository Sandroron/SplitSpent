//
//  AuthViewModel.swift
//  SplitSpent
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    
    let auth = FirebaseManager.shared.auth
    
    @Published var isSignedIn = false
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    var id: String? {
        auth.currentUser?.uid
    }
    
    func signedIn() -> Bool {
        auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        errorMessage = ""
        isLoading = true
        
        auth.signIn(withEmail: email,
                    password: password) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                self?.errorMessage = error?.localizedDescription ?? ""
                return
            }
            
            DispatchQueue.main.async {
                self?.isSignedIn = true
                self?.isLoading = false
            }
        }
    }
    
    func signUp(email: String, password: String, name: String) {
        errorMessage = ""
        isLoading = true
        
        auth.createUser(withEmail: email,
                        password: password) { [weak self] result, error in
            
            guard result != nil, error == nil else {
                self?.errorMessage = error?.localizedDescription ?? ""
                return
            }
            
            DispatchQueue.main.async {
                self?.isSignedIn = true
                self?.isLoading = false
            }
            
            self?.addUser(user: User(email: email, name: name))
        }
    }
    
    func signOut() {
        errorMessage = ""
        
        do {
            try auth.signOut()
            isSignedIn = false
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
    
    private func addUser(user: User) {
        
        do {
            errorMessage = ""
            
            let document = FirebaseManager.shared.firestore.collection(User.firebaseName).document(user.id)
            try document.setData(from: user)
            document.updateData([User.firebaseKeywordsForLookup: user.keywordsForLookup])
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func updateUser(user: User) {
        errorMessage = ""
        
        do {
            let document = FirebaseManager.shared.firestore.collection(User.firebaseName).document(user.id)
            try document.setData(from: user)
            document.updateData([User.firebaseKeywordsForLookup: user.keywordsForLookup])
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
