//
//  GroupViewModel.swift
//  SplitSpent
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

class GroupViewModel: ObservableObject {
    
    @Published var group = Group()
    @Published var users = Set<String>()
    @Published var transactions = Set<Transaction>()
    @Published var isLoading = false
    
    var groupId: String
    var errorMessage: String?
    
    init(id: String) {
        groupId = id
        fetchGroup(by: id)
    }
    
    func fetchGroup(by id: String) {
        isLoading = true
        
        let docRef = FirebaseManager.shared.firestore.collection(Group.firebaseName).document(id)
        
        docRef.getDocument(as: Group.self) { [weak self] result in
            self?.isLoading = false
            
            switch result {
            case .success(let group):
                
                self?.group = group
                self?.users = Set(group.users ?? [FirebaseManager.shared.auth.currentUser?.email ?? ""])
                
                if let transactions = group.transactions {
                    self?.transactions = Set(transactions)
                }
                self?.errorMessage = nil
            case .failure(let error):
                
                self?.errorMessage = "Error decoding document: \(error.localizedDescription)"
            }
        }
    }
    
    func saveGroup(completion: @escaping () -> Void) {
        isLoading = true
        
        let groupToSave = Group(title: group.title, users: Array(users), transactions: Array(transactions), currencyBase: group.currencyBase)
                
        do {
            errorMessage = ""
                
            let document = FirebaseManager.shared.firestore.collection(Group.firebaseName).document(groupId)
            try document.setData(from: groupToSave, completion: { [weak self] error in
                
                self?.isLoading = false
                self?.errorMessage = "Error saving document: \(error?.localizedDescription ?? "")"
                completion()
            })
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteUser(at offsets: IndexSet) {
        
        var temp = users.sorted(by: >)
        temp.remove(atOffsets: offsets)
        users = Set(temp)
    }
    
    func addTransaction(description: String, expenses: [Expense]) {

        var expensesDictionary = [String : Double]()
        
        for expense in expenses {
            expensesDictionary.updateValue(Double(expense.value) ?? 0.0, forKey: expense.email)
        }
        
        transactions.update(with: Transaction(description: description, expenses: expensesDictionary))
    }
    
    func editTransaction(transaction: Transaction, description: String, expenses: [Expense]) {

        var editedTransaction = transaction
        var expensesDictionary = [String : Double]()
        
        for expense in expenses {
            expensesDictionary.updateValue(Double(expense.value) ?? 0.0, forKey: expense.email)
        }
        
        editedTransaction.description = description
        editedTransaction.expenses = expensesDictionary
        
        transactions.remove(transaction)
        transactions.update(with: editedTransaction)
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        
        var temp = transactions.sorted(by: >)
        temp.remove(atOffsets: offsets)
        transactions = Set(temp)
    }
}
