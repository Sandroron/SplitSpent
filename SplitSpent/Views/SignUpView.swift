//
//  SignUpView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 12.03.2023.
//

import SwiftUI
import FormValidator

class SignUpFormInfo: ObservableObject {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var passwordSecond: String = ""
    
    lazy var form = {
        FormValidation(validationType: .deferred)
    }()
    
    lazy var emailValidation: ValidationContainer = {
        $email.emailValidator(form: form, errorMessage: "Email is not valid")
    }()
    
    lazy var nameValidation: ValidationContainer = {
        $name.nonEmptyValidator(form: form, errorMessage: "Name must not be empty")
    }()
    
    lazy var passwordSizeValidation: ValidationContainer = {
        $password.inlineValidator(form: form, errorMessage: "Password must not be more than 6 characters") { value in
            value.count >= 6
        }
    }()
    
    lazy var passwordMatchValidation: ValidationContainer = {
        $password.passwordMatchValidator(form: form,
                                         firstPassword: self.password,
                                         secondPassword: self.passwordSecond,
                                         secondPasswordPublisher: $passwordSecond,
                                         errorMessage: "Passwords do not match or empty")
    }()
}

struct SignUpView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject private var formInfo = SignUpFormInfo()
    
    var body: some View {
        VStack {
            
            if authViewModel.isLoading {
                
                ProgressView()
            } else {
                VStack {
                    TextField("Email Address", text: $formInfo.email)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .validation(formInfo.emailValidation)
                    
                    SecureField("Password", text: $formInfo.password)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                    
                    SecureField("Confirm password", text: $formInfo.passwordSecond)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .validation(formInfo.passwordSizeValidation)
                        .validation(formInfo.passwordMatchValidation)
                    
                    TextField("Name", text: $formInfo.name)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .validation(formInfo.nameValidation)
                    
                    Button(action: {
                        if formInfo.form.triggerValidation() {
                            authViewModel.signUp(email: formInfo.email, password: formInfo.password, name: formInfo.name)
                        }
                    },
                           label: {
                        Text("Enter")
                            .frame(width: 200.0, height: 50.0)
                            .foregroundColor(Color(.white))
                            .background(Color(.systemBlue))
                            .cornerRadius(12)
                    })
                    
                    if !authViewModel.errorMessage.isEmpty {
                        Text("\(authViewModel.errorMessage)")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.red))
                    }
                }
                .padding()
                Spacer()
            }
        }
        .navigationTitle("Create Account")
    }
}
