//
//  ContentView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 01.03.2023.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            if authViewModel.signedIn {
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
            authViewModel.signedIn = authViewModel.isSignedIn
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
