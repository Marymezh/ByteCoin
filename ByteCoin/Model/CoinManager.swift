//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol  CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    
    let apiKey = "9E8A0DF1-8073-4164-AB54-017A874D0BFF"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        //        performRequest(with: urlString)
        //        print (urlString)
        
        guard let url = URL(string: urlString) else { return }
        // creating url session
        let session = URLSession(configuration: .default)
        //  giving a task 
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print (error!)
                return
            }
            
            if let safeData = data {
                if let bitcoinPrice = self.parseJSON(safeData) {
                    let priceSting = String(format: "%.2f", bitcoinPrice)
                    self.delegate?.didUpdatePrice(self, price: priceSting, currency: currency)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
