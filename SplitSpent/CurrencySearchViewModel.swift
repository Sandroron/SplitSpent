//
//  CurrencySearchViewModel.swift
//  SplitSpent
//
//  Created by CT Razumnyi on 10.03.2023.
//

import Foundation

class CurrencySearchViewModel: ObservableObject {
    @Published var queryResultCurrency = [String: Double]()
    
    func fetchCurrency() {
        apiRequest(url: "https://api.exchangerate.host/latest") { [weak self] currency in
            self?.queryResultCurrency.self = currency.rates
        }
    }
}
