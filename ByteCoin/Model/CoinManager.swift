//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation


struct CoinManager {
    
   
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    
    let apiKey = "9E8A0DF1-8073-4164-AB54-017A874D0BFF"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
        performRequest(with: urlString)
        print (urlString)
    }
    
    func performRequest(with urlString: String) {
        // creating url
        guard let url = URL(string: urlString) else { return }
        // creating url session
        let session = URLSession(configuration: .default)
        //  giving a task 
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                print (error!)
                return
            }
            //            printing request
            //                let dataString = String(data: data!, encoding: .utf8)
            //                print(dataString)
            
            // parcing JSON for the data
            
            if let safeData = data {
                let bitcoinPrice = self.parseJSON(safeData)
                
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
            print (error)
            return nil
        }
        
    }
    
}
