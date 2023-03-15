//
//  EditTransactionView.swift
//  SplitSpent
//

import SwiftUI
import PhotosUI

struct EditTransactionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var groupViewModel: GroupViewModel
    
    @State var transaction: Transaction
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
                
                if let photos = transaction.photos {
                    
                    LazyVGrid(columns: gridLayout!,
                              alignment: .center,
                              spacing: 10) {

                        ForEach(photos, id: \.self) { photo in

                            AsyncImage(url: URL(string: photo)!) { phase in
                                
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                default:
                                    Image(systemName: "photo")
                                }
                            }
                            
                            .frame(minWidth: 100.0, maxWidth: .infinity)
                            .frame(height: 100.0)
                            .cornerRadius(10)
                        }
                    }
                } else {
                    
                    PhotosPickerView(gridLayout: $gridLayout,
                                     selectedItems: $selectedItems,
                                     selectedPhotosData: $selectedPhotosData,
                                     selectedPhotosImages: $selectedPhotosImages)
                }
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
                        
                        groupViewModel.editTransaction(transaction: transaction,
                                                       description: description,
                                                       expenses: expenses,
                                                       selectedItems: selectedItems,
                                                       selectedPhotosData: selectedPhotosData,
                                                       selectedPhotosImages: selectedPhotosImages)
                        dismiss.callAsFunction()
                    }
                },
                label: {
                    Text("Save")
                }))
        .onAppear( perform: {

            description = transaction.description ?? ""
            
            selectedItems = transaction.photosDataInfo?.selectedItems ?? []
            selectedPhotosData = transaction.photosDataInfo?.selectedPhotosData ?? []
            selectedPhotosImages = transaction.photosDataInfo?.selectedPhotosImages
            
            for expense in transaction.expenses {
                expenses.append(Expense(email: expense.key, value: String(expense.value)))
            }
        })
    }
}


