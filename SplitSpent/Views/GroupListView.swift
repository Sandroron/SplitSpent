//
//  GroupListView.swift
//  SplitSpent
//

import SwiftUI

struct GroupListView: View {
    @StateObject private var groupListViewModel = GroupListViewModel()
    
    @State private var selectedGroup: Group?
    @State private var showAddGroup = false
    
    var body: some View {
        
        if groupListViewModel.isLoading {
            
            ProgressView()
        } else {
            List(groupListViewModel.groups, id: \.id) { group in
                
                Button(action: {
                    selectedGroup = group
                }, label: {
                    Text(group.title)
                })
            }
            .navigationTitle("Groups")
            .navigationBarItems(
                trailing: Button( action: {
                    showAddGroup.toggle()
            }, label: {
                Image(systemName: "plus")
            }))
            .sheet(item: $selectedGroup) { selectedGroup in
                GroupView(groupViewModel: GroupViewModel(id: selectedGroup.id ?? ""))
                    .environmentObject(groupListViewModel)
            }
            .sheet(isPresented: $showAddGroup) {
                AddGroupView()
                    .environmentObject(groupListViewModel)
            }
        }
    }
}
