//
//  AddGroupView.swift
//  SplitSpent
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
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var groupListViewModel: GroupListViewModel
    
    @ObservedObject private var formInfo = AddGroupFormInfo()
    
    @State private var selectedUsers = Set<String>()
    @State private var selectedCurrency: String?
    
    var body: some View {
        
        NavigationView {
            
            if groupListViewModel.isLoading {

                ProgressView()
            } else {
                
                Form {
                    Section() {
                        TextField("Group name", text: $formInfo.groupName)
                            .background(Color(uiColor: .systemBackground))
                            .validation(formInfo.groupNameValidation)
                        
                        NavigationLink(destination: UserSearchView(selectedUsers: $selectedUsers)) {
                            HStack {
                                Text("Add users")
                                Spacer()
                                Text("\(selectedUsers.count) selected")
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                        }
                            
                        NavigationLink(destination: CurrencySearchView(selectedCurrency: $selectedCurrency)) {
                            HStack {
                                Text("Choose currency")
                                Spacer()
                                Text(selectedCurrency ?? "")
                                    .foregroundColor(Color(uiColor: .secondaryLabel))
                            }
                        }
                        .validation(formInfo.selectedCurrencyValidation)
                    }
                }
                .navigationTitle("New Group")
                .background(Color(uiColor: .secondarySystemBackground))
                .navigationBarItems(
                    leading: Button(
                        action: {
                            dismiss.callAsFunction()
                        },
                        label: {
                            Text("Cancel")
                        }),
                    trailing: Button(
                        action: {
                        formInfo.selectedCurrency = selectedCurrency ?? ""
                        
                        if formInfo.form.triggerValidation() {
                            
                            groupListViewModel.addGroup(group: Group(title: formInfo.groupName,
                                                                     users: Array(selectedUsers) + [FirebaseManager.shared.auth.currentUser?.email ?? ""],
                                                                     currencyBase: formInfo.selectedCurrency),
                                                        completion: dismiss.callAsFunction)
                        }},
                        label: {
                            Text("Save")
                        }))
            }
        }
    }
}

struct AddGroupView_Previews: PreviewProvider {
    static var previews: some View {
        AddGroupView()
    }
}
