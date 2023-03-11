//
//  AddGroupView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 07.03.2023.
//

import SwiftUI

struct AddGroupView: View {
    
    @EnvironmentObject var groupListViewModel: GroupListViewModel
    @State private var name = ""
    @State var selectedUsers = Set<String>()
    @State var selectedCurrency: String?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                
                VStack {
                    
                    if groupListViewModel.isLoading {
                        
                        ProgressView()
                    } else {
                        
                        TextField("Group name", text: $name)
                        
                        Text("\(selectedUsers.joined(separator: ", "))")
                        
                        let usersLookupViewModel = UsersLookupViewModel()
                        NavigationLink("Add users", destination: UserSearchView(usersLookupViewModel: usersLookupViewModel, selectedUsers: $selectedUsers))
                            .padding()
                        
                        Text("\(selectedCurrency ?? "")")
                        
                        let currencySearchViewModel = CurrencySearchViewModel()
                        NavigationLink("Choose currency", destination: CurrencySearchView(currencySearchViewModel: currencySearchViewModel, selectedCurrency: $selectedCurrency))
                            .padding()
                        
                        Button {
                            groupListViewModel.addGroup(group: Group(name: name, users: Array(selectedUsers) + [FirebaseManager.shared.auth.currentUser?.email ?? ""], currencyBase: selectedCurrency),
                                                        completion: dismiss.callAsFunction)
                        } label: {
                            Text("Save")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("New Group")
        }
    }
}

struct AddGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddGroupView()
    }
}
