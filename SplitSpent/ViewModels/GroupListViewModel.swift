//
//  GroupListViewModel.swift
//  SplitSpent
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class GroupListViewModel: ObservableObject { // DataManager
    
    @Published var groups: [Group] = []
    @Published var isLoading = false
    
    var errorMessage: String?
    
    init() {
        fetchGroups()
    }
    
    func fetchGroups() {
        isLoading = true
        
        groups = []
        
        FirebaseManager.shared.firestore.collection(Group.firebaseName).getDocuments(completion: { [weak self] (result, error) in
            
            guard let documents = result?.documents else {
                // self?.errorMessage = "No documents"
                self?.isLoading = false
                return
            }
            
            if let error = error {
                self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
            }
            
            for document in documents {
                
                if let group = try? document.data(as: Group.self) {
                    self?.groups.append(group)
                }
            }
            self?.isLoading = false
        })
        
//        docRef.getDocument(as: [Group].self) { [weak self] result in
//          switch result {
//          case .success(let groups):
//
//            self?.groups = groups
//            self?.errorMessage = nil
//          case .failure(let error):
//
//            self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
//          }
//        }
    }
    
    func addGroup(group: Group, completion: @escaping () -> Void) {
        isLoading = true
        
        do {
            let _ = try FirebaseManager.shared.firestore.collection(Group.firebaseName).addDocument(from: group, completion: { [weak self] error in
                
                if let error = error {
                    self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                }
                
                self?.fetchGroups()
                
                DispatchQueue.main.async {
                    self?.isLoading = false
                    completion()
                }
            })
        } catch {
            self.errorMessage = "Error decoding document: \(error.localizedDescription)"
            isLoading = false
            completion()
        }
    }
}
