//
//  AddGroupView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 07.03.2023.
//

import SwiftUI
import FormValidator

class AddGroupFormInfo: ObservableObject {
    @Published var groupName: String = ""
    @Published var selectedCurrency: String = ""
    
    lazy var form = {
        FormValidation(validationType: .deferred)
    }()
    
    lazy var groupNameValidation: ValidationContainer = {
        $groupName.nonEmptyValidator(form: form, errorMessage: "Enter the name of your group")
    }()
    
    lazy var selectedCurrencyValidation: ValidationContainer = {
        $selectedCurrency.nonEmptyValidator(form: form, errorMessage: "Choose the currency of your group")
    }()
}

struct AddGroupView: View {
    
    @EnvironmentObject var groupListViewModel: GroupListViewModel
    
    @ObservedObject var formInfo = AddGroupFormInfo()
    
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
                        
                        TextField("Group name", text: $formInfo.groupName)
                            .background(Color(uiColor: .systemBackground))
                            .validation(formInfo.groupNameValidation)
                        
                        Text("\(selectedUsers.joined(separator: ", "))")
                        
                        let usersLookupViewModel = UsersLookupViewModel()
                        NavigationLink("Add users", destination: UserSearchView(usersLookupViewModel: usersLookupViewModel, selectedUsers: $selectedUsers))
                            .padding()
                        
                        Text("\(selectedCurrency ?? "")")
                            .validation(formInfo.selectedCurrencyValidation)
                        
                        let currencySearchViewModel = CurrencySearchViewModel()
                        NavigationLink("Choose currency", destination: CurrencySearchView(currencySearchViewModel: currencySearchViewModel, selectedCurrency: $selectedCurrency))
                            .padding()
                        
                        Button {
                            
                            formInfo.selectedCurrency = selectedCurrency ?? ""
                            
                            if formInfo.form.triggerValidation() {
                                
                                groupListViewModel.addGroup(group: Group(name: formInfo.groupName, users: Array(selectedUsers) + [FirebaseManager.shared.auth.currentUser?.email ?? ""], currencyBase: formInfo.selectedCurrency),
                                                            completion: dismiss.callAsFunction)
                            }
                        } label: {
                            Text("Save")
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("New Group")
            .background(Color(uiColor: .secondarySystemBackground))
        }
    }
}

struct AddGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddGroupView()
    }
}
