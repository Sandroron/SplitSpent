//
//  AppJsonStructure.swift
//  SplitSpent
//

import Foundation

struct AppJsonStructure: Codable {
    var users: [UserJsonStructure]
    var groups: [GroupJsonStructure]
    
    struct UserJsonStructure: Codable {
        var email: String?
        var name: String
        
        func getUser() -> User {
            User(email: email, name: name)
        }
    }
    
    struct GroupJsonStructure: Codable {
        var id: String
        var title: String?
        var users: [String]?
        var transactions: [TransactionJsonStructure]?
        
        struct TransactionJsonStructure: Codable {
            var id: String
            var expenses: [String : Double]?
        }
        
        func getGroup() -> Group {
            Group(id: id, title: title ?? "", users: users, transactions: getTransactions())
        }
        
        private func getTransactions() -> [Transaction] {
            var transactionsResult: [Transaction] = []
            
            guard let transactions else { return [] }
            
            for transaction in transactions {
                
                transactionsResult.append(Transaction(id: transaction.id, expenses: transaction.expenses ?? [:]))
            }
            
            return transactionsResult
        }
    }
}

