//
//  CurrencySearchViewModel.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 10.03.2023.
//

import Foundation

class CurrencySearchViewModel: ObservableObject {
    
    let requestUrl = "https://api.exchangerate.host/latest"
    
    @Published var queryResultCurrency = [String: Double]()
    
    func fetchCurrency() {
        apiRequest(url: requestUrl) { [weak self] currency in
            self?.queryResultCurrency.self = currency.rates
        }
    }
}
