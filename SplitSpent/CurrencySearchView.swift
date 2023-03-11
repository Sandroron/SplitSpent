//
//  CurrencySearchView.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 10.03.2023.
//

import SwiftUI
import Alamofire

struct CurrencySearchView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var currencySearchViewModel: CurrencySearchViewModel
    @Binding var selectedCurrency: String?
    @State var editMode = EditMode.active
    
    var body: some View {
        VStack() {
            HStack {
                Text("Currencies")
                    .font(.system(size: 30))
                    .bold()
                
            }
            List(currencySearchViewModel.queryResultCurrency.sorted(by: >), id: \.key, selection: $selectedCurrency) { key, value in
                Text("\(key) \(String(format: "%.2f", value))")
            }
//            .toolbar {
//                EditButton()
//                    .hidden()
//            }
//            .environment(\.editMode, $editMode)
            
        }.onAppear() {
            currencySearchViewModel.fetchCurrency()
        }
    }
}

//struct CurrencySearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrencySearchView()
//    }
//}
