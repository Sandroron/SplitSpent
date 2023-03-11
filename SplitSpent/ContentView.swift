//
//  ContentView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 01.03.2023.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if authViewModel.signedIn {
                let groupListViewModel = GroupListViewModel()
                GroupListView()
                    .environmentObject(groupListViewModel)
                    .navigationBarItems(
                        leading: Button( action: {
                            authViewModel.signOut()
                    }, label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }))
            } else {
                ScrollView {
                    SignInView()
                }
            }
        }
        .onAppear(perform: {
            authViewModel.signedIn = authViewModel.isSignedIn
        })
    }
}

struct GroupListView: View {
    @EnvironmentObject var groupListViewModel: GroupListViewModel
    @State private var showPopup = false
    
    var body: some View {
        
        if groupListViewModel.isLoading {
            
            ProgressView()
        } else {
            List(groupListViewModel.groups, id: \.id) { group in
                Text(group.name)
            }
            .navigationTitle("Groups")
            .navigationBarItems(
                trailing: Button( action: {
                    showPopup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(isPresented: $showPopup) {
                AddGroupView()
            }
            
        }
    }
}



struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            VStack {
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else { return }
                    
                    authViewModel.signIn(email: email, password: password)
                },
                       label: {
                    Text("Enter")
                        .frame(width: 200.0, height: 50.0)
                        .foregroundColor(Color(.white))
                        .background(Color(.systemBlue))
                })
                
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Sign In")
    }
}



struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    @State var name = ""
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            VStack {
                TextField("Email Address", text: $email)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                TextField("Name", text: $name)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .disableAutocorrection(true)
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty, !name.isEmpty else { return }
                    
                    authViewModel.signUp(email: email, password: password, name: name)
                },
                       label: {
                    Text("Enter")
                        .frame(width: 200.0, height: 50.0)
                        .foregroundColor(Color(.white))
                        .background(Color(.systemBlue))
                })
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Create Account")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
