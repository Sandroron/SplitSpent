//
//  CurrencySearchView.swift
//  SplitSpent
//

import SwiftUI
import Alamofire

struct CurrencySearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var currencySearchViewModel = CurrencySearchViewModel()
    @Binding var selectedCurrency: String?
    @State var editMode = EditMode.active
    
    var body: some View {
        VStack() {
            List(currencySearchViewModel.queryResultCurrency.sorted(by: <), id: \.key, selection: $selectedCurrency) { key, value in
                Text(key)
            }
        }.onAppear() {
            currencySearchViewModel.fetchCurrency()
        }
        .onChange(of: selectedCurrency, perform: { selectedCurrency in
            dismiss.callAsFunction()
        })
        .navigationTitle("Choose currency")
    }
}
