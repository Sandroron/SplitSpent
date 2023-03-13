//
//  GroupListViewModel.swift
//  SplitSpent
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class GroupListViewModel: ObservableObject { 
    
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
    }
    
    func importGroups(url: URL?) {

        isLoading = true
        
        do {
            if let url {
                let jsonData = try Data(contentsOf: url)
                let decodedData = try JSONDecoder().decode(AppJsonStructure.self, from: jsonData)
                
                addGroupsFromJson(jsonGroups: decodedData.groups, completion: { [weak self] in
                    self?.addUsersFromJson(jsonUsers: decodedData.users, completion: { [weak self] in
                        self?.fetchGroups()
                    })
                })
            }
        } catch {
            print(error)
        }
    }
    
    private func addGroupsFromJson(jsonGroups: [AppJsonStructure.GroupJsonStructure], completion: @escaping () -> Void) {
        
        for jsonGroup in jsonGroups {
            
            do {
                try FirebaseManager.shared.firestore.collection(Group.firebaseName).document().setData(from: jsonGroup.getGroup(), completion: { [weak self] error in
                    
                    if let error = error {
                        self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                    }
                    
                    if jsonGroup.id == jsonGroups.last?.id {
                        
                        completion()
                    }
                })
            } catch {
                self.errorMessage = "Error decoding document: \(error.localizedDescription)"
                completion()
            }
        }
    }
    
    private func addUsersFromJson(jsonUsers: [AppJsonStructure.UserJsonStructure], completion: @escaping () -> Void) {
        
        for jsonUser in jsonUsers {
            
            do {
                try FirebaseManager.shared.firestore.collection(User.firebaseName).document().setData(from: jsonUser.getUser(), completion: { [weak self] error in
                    
                    if let error = error {
                        self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
                    }
                    
                    if jsonUser.email == jsonUsers.last?.email {
                        
                        completion()
                    }
                })
            } catch {
                self.errorMessage = "Error decoding document: \(error.localizedDescription)"
                completion()
            }
        }
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
