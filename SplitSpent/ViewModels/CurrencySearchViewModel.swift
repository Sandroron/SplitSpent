//
//  CurrencySearchViewModel.swift
//  SplitSpent
//\

import Foundation

class CurrencySearchViewModel: ObservableObject {
    
    let requestUrl = "https://api.exchangerate.host/latest"
    
    @Published var queryResultCurrency = [String: Double]()
    
    func fetchCurrency() {
        CurrencyApiManager.apiRequest(url: requestUrl) { [weak self] currency in
            self?.queryResultCurrency.self = currency.rates
        }
    }
}
