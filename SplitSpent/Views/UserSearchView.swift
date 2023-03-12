//
//  UserSearchView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 09.03.2023.
//

import SwiftUI

struct UserSearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var usersLookupViewModel = UsersLookupViewModel()
    
    @State private var keyword = ""
    @State private var editMode = EditMode.active
    
    @Binding var selectedUsers: Set<String>
    
    var body: some View {
        let keywordBinding = Binding<String>(
            get: {
                keyword
            },
            set: {
                keyword = $0
                usersLookupViewModel.fetchUsers(with: keyword)
            }
        )
        VStack {
            SearchBarView(keyword: keywordBinding)
            List(usersLookupViewModel.queryResultUsers, id: \.id, selection: $selectedUsers) { user in
                Text(user.name)
            }
            .toolbar {
                EditButton()
                    .hidden()
            }
            .environment(\.editMode, $editMode)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SearchBarView: View {
    @Binding var keyword: String
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(uiColor: .secondarySystemFill))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Searching for...", text: $keyword)
                .autocapitalization(.none)
            }
            .padding(.leading, 12)
        }
        .frame(height: 40)
        .cornerRadius(12)
        .padding()
    }
}
