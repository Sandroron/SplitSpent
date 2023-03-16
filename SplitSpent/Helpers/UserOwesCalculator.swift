//
//  UserOwesCalculator.swift
//  SplitSpent
//

import Foundation

class UserOwesCalculator {
    
    static func calculate(for users: Set<String>, with transactions: Set<Transaction>) -> [UserExpense] {
        
        var userExpenses = Set<UserExpense>()
        
        for email in users {
            userExpenses.update(with: UserExpense(email: email))
        }
        
        // Gathering of all transactions and calculation of who is owes (paid) or owed
        for transaction in transactions {
            
            let payer = transaction.expenses.first(where: { $0.value > 0 })?.key ?? ""
            
            for expense in transaction.expenses {
                
                if let userExpense = userExpenses.first(where: {$0.email == expense.key}) {
                    
                    var updatedUserExpense = userExpense
                    
                    if expense.value <= 0 {
                        updatedUserExpense.owes = updatedUserExpense.owes + expense.value
                        updatedUserExpense.part = updatedUserExpense.part + abs(expense.value)
                        
                        var owesTo = updatedUserExpense.owesTo
                        owesTo[payer] = (owesTo[payer] ?? 0.0) + abs(expense.value)
                        
                        updatedUserExpense.owesTo = owesTo
                    } else {
                        updatedUserExpense.paid = updatedUserExpense.paid + expense.value
                        
                        let otherUsersParts = transaction.expenses.reduce(0, { result, keyValuePair in
                            
                            if userExpense.email == keyValuePair.key {
                                return result
                            }
                            return result + abs(keyValuePair.value)
                        })
                        
                        updatedUserExpense.part = updatedUserExpense.part + updatedUserExpense.paid - otherUsersParts
                    }
                    
                    userExpenses.remove(userExpense)
                    userExpenses.update(with: updatedUserExpense)
                }
            }
        }
        
        // Clear mutual debts
        var userExpensesArray = Array(userExpenses)
        
        for (currentUserIndex, currentUser) in userExpensesArray.enumerated() {
            
            for (otherUserIndex, otherUser) in userExpensesArray.enumerated() {
                
                if var otherUserOwesToCurrentUser = otherUser.owesTo[currentUser.email],
                   var currentUserOwesToOtherUser = currentUser.owesTo[otherUser.email],
                   otherUserOwesToCurrentUser > 0, currentUserOwesToOtherUser > 0 {
                    
                    let difference = min(otherUserOwesToCurrentUser, currentUserOwesToOtherUser)
                    
                    otherUserOwesToCurrentUser = otherUserOwesToCurrentUser - difference
                    currentUserOwesToOtherUser = currentUserOwesToOtherUser - difference
                    
                    // Remove the debt if the user has settled
                    userExpensesArray[currentUserIndex].owesTo[otherUser.email] = currentUserOwesToOtherUser > 0 ? currentUserOwesToOtherUser : nil
                    userExpensesArray[otherUserIndex].owesTo[currentUser.email] = otherUserOwesToCurrentUser > 0 ? otherUserOwesToCurrentUser : nil
                }
            }
        }
        
        return userExpensesArray
    }
}
