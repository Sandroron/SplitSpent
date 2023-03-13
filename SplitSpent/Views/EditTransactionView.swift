//
//  EditTransactionView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 13.03.2023.
//

import SwiftUI

struct EditTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var groupViewModel: GroupViewModel
    
    @State private var expenses = [Expense]()
    @State private var description = String()
    
    var transaction: Transaction
    
    var body: some View {
        Form {
            Section("Description") {
                TextField("Brief info", text: $description)
                    .background(Color(uiColor: .systemBackground))
            }
            
            ForEach(Array(expenses.enumerated()), id: \.offset) { index, expense in
                Section() {
                    
                    Picker("User", selection: $expenses[index].email) {
                        ForEach(groupViewModel.users.sorted(by: >), id: \.self) {
                            Text($0)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    TextField("Expense amount", text: $expenses[index].value)
                        .background(Color(uiColor: .systemBackground))
                }
            }
            
            Section("Expenses (put \"-\" for debtors)") {
                
                Button(action: {
                    
                    expenses.append(Expense(email: groupViewModel.users.sorted(by: >).first ?? "", value: ""))
                }, label: {
                    Text("Add expense")
                })
            }
        }
        .navigationTitle("Transaction")
        
        .navigationBarItems(
            trailing: Button(
                action: {
                    
                    if !expenses.isEmpty {
                        
                        groupViewModel.editTransaction(transaction: transaction, description: description, expenses: expenses)
                        dismiss.callAsFunction()
                    }
                },
                label: {
                    Text("Save")
                }))
        .onAppear( perform: {

            description = transaction.description ?? ""
            
            for expense in transaction.expenses {
                expenses.append(Expense(email: expense.key, value: String(expense.value)))
            }
        })
    }
}
