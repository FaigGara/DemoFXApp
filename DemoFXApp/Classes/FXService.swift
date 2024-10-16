//
//  FXService.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 9.10.2024.
//

import Foundation

class FXService {
    func fetchForeignCurrencies(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.cbar.az/currencies/20.02.2024.xml") else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                completion(true)
                return
            }
            
            let parser = XMLParser(data: data)
            let currencyParser = ForeignCurrencyXMLParser()
            parser.delegate = currencyParser
            parser.parse()
            FXSingleton.shared.valCurs = currencyParser.valCurs
            DispatchQueue.main.async {
                completion(true)
            }
        }
        task.resume()
    }
}
