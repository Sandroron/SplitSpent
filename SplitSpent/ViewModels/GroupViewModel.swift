//
//  GroupViewModel.swift
//  SplitSpent
//

import SwiftUI
import PhotosUI
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
        
        savePhotos(completion: { [unowned self] in
            
            let groupToSave = Group(title: group.title,
                                    users: Array(users),
                                    transactions: Array(transactions),
                                    currencyBase: group.currencyBase)
                    
            do {
                errorMessage = ""
                    
                let document = FirebaseManager.shared.firestore.collection(Group.firebaseName).document(groupId)
                try document.setData(from: groupToSave, completion: { [unowned self] error in
                    
                    isLoading = false
                    errorMessage = "Error saving document: \(error?.localizedDescription ?? "")"
                    completion()
                })
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        })
    }
    
    func savePhotos(completion: @escaping () -> Void) {
        
        guard let userId = FirebaseManager.shared.auth.currentUser?.email,
              !transactions.isEmpty else {
            return
        }
        
        let transactionsArray = transactions.sorted(by: <)
        
        for transaction in transactionsArray {
            
            if let photosImages = transaction.photosDataInfo?.selectedPhotosImages,
               !photosImages.isEmpty {
                
                var editedTransaction = transaction
                editedTransaction.photos = []
                
                photosImages.forEach { photoImage in
                    
                    let uid = userId + UUID().uuidString
                    let ref = FirebaseManager.shared.storage.reference(withPath: uid)
                    
                    guard let imageData = photoImage.jpegData(compressionQuality: 0.5) else {
                        return
                    }
                    
                    ref.putData(imageData) { metadata, error in
                        
                        ref.downloadURL(completion: { [unowned self] url, error in
                            
                            guard let url, error == nil else {
                                return
                            }
                            
                            editedTransaction.photos?.append(url.absoluteString)
                            
                            if photoImage == photosImages.last {
                                
                                transactions.remove(transaction)
                                transactions.update(with: editedTransaction)
                                
                                if transaction == transactionsArray.last {
                                    completion()
                                }
                            }
                        })
                    }
                }
            } else {
                
                if transaction == transactionsArray.last {
                    completion()
                } else {
                    continue
                }
            }
        }
    }
    
    func deleteUser(at offsets: IndexSet) {
        
        var temp = users.sorted(by: >)
        temp.remove(atOffsets: offsets)
        users = Set(temp)
    }
    
    func addTransaction(description: String, expenses: [Expense], selectedItems: [PhotosPickerItem], selectedPhotosData: [Data], selectedPhotosImages: [UIImage]?) {

        var expensesDictionary = [String : Double]()
        
        for expense in expenses {
            expensesDictionary.updateValue(Double(expense.value) ?? 0.0, forKey: expense.email)
        }
        
        let photosDataInfo = Transaction.PhotosDataInfo(selectedItems: selectedItems,
                                                        selectedPhotosData: selectedPhotosData,
                                                        selectedPhotosImages: selectedPhotosImages)
        
        transactions.update(with: Transaction(description: description, photosDataInfo: photosDataInfo, expenses: expensesDictionary))
    }
    
    func editTransaction(transaction: Transaction, description: String, expenses: [Expense], selectedItems: [PhotosPickerItem]?, selectedPhotosData: [Data]?, selectedPhotosImages: [UIImage]?) {

        var editedTransaction = transaction
        var expensesDictionary = [String : Double]()
        
        for expense in expenses {
            expensesDictionary.updateValue(Double(expense.value) ?? 0.0, forKey: expense.email)
        }
        
        let photosDataInfo = Transaction.PhotosDataInfo(selectedItems: selectedItems ?? [],
                                                        selectedPhotosData: selectedPhotosData ?? [],
                                                        selectedPhotosImages: selectedPhotosImages)
        
        editedTransaction.description = description
        editedTransaction.expenses = expensesDictionary
        editedTransaction.photosDataInfo = photosDataInfo
        
        transactions.remove(transaction)
        transactions.update(with: editedTransaction)
    }
    
    func deleteTransaction(at offsets: IndexSet) {
        
        var temp = transactions.sorted(by: >)
        temp.remove(atOffsets: offsets)
        transactions = Set(temp)
    }
    
    static func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
