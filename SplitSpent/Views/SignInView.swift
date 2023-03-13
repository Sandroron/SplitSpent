//
//  SignInView.swift
//  SplitSpent
//

import SwiftUI
import FormValidator

class SignInFormInfo: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    lazy var form = {
        FormValidation(validationType: .deferred)
    }()
    
    lazy var emailValidation: ValidationContainer = {
        $email.emailValidator(form: form, errorMessage: "Email is not valid")
    }()
    
    lazy var passwordValidation: ValidationContainer = {
        $password.nonEmptyValidator(form: form, errorMessage: "Password must not be empty")
    }()
}

struct SignInView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @ObservedObject private var formInfo = SignInFormInfo()
    
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
                        .validation(formInfo.passwordValidation)
                    
                    Button(action: {
                        
                        if formInfo.form.triggerValidation() {
                            authViewModel.signIn(email: formInfo.email, password: formInfo.password)
                        }
                    },
                           label: {
                        Text("Enter")
                            .frame(width: 200.0, height: 50.0)
                            .foregroundColor(Color(.white))
                            .background(Color(.systemBlue))
                            .cornerRadius(12)
                    })
                    
                    NavigationLink("Create Account", destination: SignUpView())
                        .padding()
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationTitle("Sign In")
    }
}
