//
//  ContentView.swift
//  SplitSpent
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if authViewModel.isSignedIn {
                GroupListView()
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
            authViewModel.isSignedIn = authViewModel.signedIn()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
