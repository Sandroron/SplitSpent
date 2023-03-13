//
//  GroupView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 12.03.2023.
//

import SwiftUI

struct GroupView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var groupListViewModel: GroupListViewModel
    
    @StateObject var groupViewModel: GroupViewModel
    
    var body: some View {
        
        NavigationView {
            if groupViewModel.isLoading {
                
                ProgressView()
            } else {
                
                Form {
                    Section("Group name") {
                        TextField("Name", text: $groupViewModel.group.title)
                            .background(Color(uiColor: .systemBackground))
                    }
                    
                    Section("Currency") {
                        NavigationLink(destination: CurrencySearchView(selectedCurrency: $groupViewModel.group.currencyBase)) {
                            HStack {
                                Text("Choose currency")
                                Spacer()
                                Text(groupViewModel.group.currencyBase ?? "")
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                        }
                    }
                    
                    Section("Users") {
                        
                        List {
                            ForEach(groupViewModel.users.sorted(by: >), id: \.self) { userId in
                                Text(userId)
                            }
                            .onDelete(perform: groupViewModel.deleteUser)
                        }
                        
                        NavigationLink(destination: UserSearchView(selectedUsers: $groupViewModel.users)) {
                            HStack {
                                Text("Add users")
                                    .foregroundColor(Color(uiColor: .link))
                            }
                        }
                    }
                    
                    Section("Expense transactions") {
                        
                        List {
                            ForEach(groupViewModel.transactions.sorted(by: >), id: \.self) { transaction in
                                
                                NavigationLink(destination: EditTransactionView(transaction: transaction).environmentObject(groupViewModel)) {
                                    Text((transaction.description?.isEmpty ?? true) ? "Transaction" : transaction.description!)
                                }
                            }
                            .onDelete(perform: groupViewModel.deleteTransaction)
                        }
                        
                        NavigationLink(destination: AddTransactionView().environmentObject(groupViewModel)) {
                            HStack {
                                Text("Add transaction")
                                    .foregroundColor(Color(uiColor: .link))
                            }
                        }
                    }
                }
                .navigationTitle("Group")
                .background(Color(uiColor: .secondarySystemBackground))
                .navigationBarItems(
                    leading: Button(
                        action: {
                            dismiss.callAsFunction()
                        },
                        label: {
                            Text("Back")
                        }),
                    trailing: Button(
                        action: {
                            groupViewModel.saveGroup(completion: {
                                groupListViewModel.fetchGroups()
                                dismiss.callAsFunction()
                            })
                        },
                        label: {
                            Text("Save")
                        }))
                .onAppear(perform: {
                    print("\(groupViewModel.transactions)")
                })
            }
        }
    }
}
