//
//  CurrencyApiManager.swift
//  SplitSpent
//

import Foundation
import Alamofire

class CurrencyApiManager {
    
    static func apiRequest(url: String, completion: @escaping (Currency) -> ()) {
        
        Session.default.request(url).responseDecodable(of: Currency.self) { response in
            switch response.result {
            case .success(let currencies):
                print(currencies)
                completion(currencies)
            case .failure(let error):
                print(error)
            }
        }
    }
}
