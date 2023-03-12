//
//  GroupListView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 12.03.2023.
//

import SwiftUI

struct GroupListView: View {
    @StateObject private var groupListViewModel = GroupListViewModel()
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
                    .environmentObject(groupListViewModel)
            }
            
        }
    }
}
