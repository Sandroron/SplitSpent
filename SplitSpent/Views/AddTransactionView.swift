//
//  TransactionView.swift
//  SplitSpent
//

import SwiftUI
import PhotosUI

struct AddTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var groupViewModel: GroupViewModel
    
    @State private var expenses = [Expense]()
    @State private var description = String()
    
    @State var selectedItems: [PhotosPickerItem]? = []
    @State var selectedPhotosData: [Data]? = [Data]()
    @State var selectedPhotosImages: [UIImage]? = []
    
    @State var gridLayout: [GridItem]? = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        Form {
            Section("Description") {
                TextField("Brief info", text: $description)
                    .background(Color(uiColor: .systemBackground))
            }
            
            Section("Photos") {
                
                PhotosPickerView(gridLayout: $gridLayout,
                                 selectedItems: $selectedItems,
                                 selectedPhotosData: $selectedPhotosData,
                                 selectedPhotosImages: $selectedPhotosImages)
            }
            
            ForEach(Array(expenses.enumerated()), id: \.offset) { index, expense in
                Section() {

                    Picker("User", selection: $expenses[index].email) {
                        ForEach(groupViewModel.users.sorted(by: >), id: \.self) {
                            Text($0)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    TextField("Expense amount", text: $expenses[index].value)
                        .background(Color(uiColor: .systemBackground))
                }
            }
            .onDelete(perform: removeExpense)

            Section("Expenses (put \"-\" for debtors)") {

                Button(action: {

                    expenses.append(Expense(email: groupViewModel.users.sorted(by: >).first ?? "", value: ""))
                }, label: {
                    Text("Add expense")
                })
            }
        }
        .navigationTitle("Transaction")

        .navigationBarItems(
            trailing: Button(
                action: {

                    if !expenses.isEmpty {

                        groupViewModel.addTransaction(description: description,
                                                      expenses: expenses,
                                                      selectedItems: selectedItems!,
                                                      selectedPhotosData: selectedPhotosData!,
                                                      selectedPhotosImages: selectedPhotosImages)
                        dismiss.callAsFunction()
                    }
                },
                label: {
                    Text("Save")
                }))
    }
    
    func removeExpense(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
}

@MainActor
struct PhotosPickerView: View {
    
    @Binding var gridLayout: [GridItem]?
    
    @Binding var selectedItems: [PhotosPickerItem]?
    @Binding var selectedPhotosData: [Data]?
    @Binding var selectedPhotosImages: [UIImage]?
    
    var body: some View {
        
        PhotosPicker(selection: $selectedItems.toUnwrapped(defaultValue: []), maxSelectionCount: 4, matching: .images) {
            HStack {
                Text("Select Photos")
                Image(systemName: "photo.on.rectangle.angled")
            }
        }
        .onChange(of: selectedItems!) { newItems in
            loadImagesFromPhotosPicker(newItems)
        }
        
        if let selectedPhotosImages,
           !selectedPhotosImages.isEmpty {
            
            LazyVGrid(columns: gridLayout!,
                      alignment: .center,
                      spacing: 10) {
              
                ForEach(selectedPhotosImages, id: \.self) { uiImage in
                    
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(minWidth: 100.0, maxWidth: .infinity)
                        .frame(height: 100.0)
                        .cornerRadius(10)
                }
            }
            // .transition(.opacity)
        }
    }
    
    
    func loadImagesFromPhotosPicker(_ newItems: [PhotosPickerItem]) {
        selectedPhotosData = []
        selectedPhotosImages = []
        
        var selectedPhotosImages = selectedPhotosImages ?? []
        
        for newItem in newItems {
     
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   var selectedPhotosData {
                    
                    selectedPhotosData.append(data)
                    
                    if let uiImage = UIImage(data: data) {
                        selectedPhotosImages.append(uiImage)
                    }
                    
                    if newItem == newItems.last {
                        
                        self.selectedPhotosImages = selectedPhotosImages
//                        withAnimation(.easeIn(duration: 2)) {
//
//                            self.selectedPhotosImages = selectedPhotosImages
//                        }
                    }
                }
            }
        }
    }
}
