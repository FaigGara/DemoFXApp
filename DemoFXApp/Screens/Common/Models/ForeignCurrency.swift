//
//  ForeignCurrency.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 9.10.2024.
//

import Foundation

struct Valute {
    let code: String
    let nominal: String
    let name: String
    let buyValue: String
    let sellValue: String
    let value: String
    var symbol: String = "$"
    var aznUnit: String = "1.0"
    
    init(code: String, nominal: String, name: String, buyValue: String, sellValue: String, value: String) {
        self.code = code
        self.nominal = nominal
        self.name = name
        self.buyValue = buyValue
        self.sellValue = sellValue
        self.value = value
        self.symbol = ValutesSymbol.currencySymbols[self.code] ?? "$"
    }
    
    private let dataFormatter = NumberFormatterFactory.decimalNumberFormatter()
    
    func getBuyPriceByAzn() -> String {
        if self.code == "AZN" {
            return aznUnit
        }
        
        let unitDouble = dataFormatter.number(from: aznUnit)!.doubleValue
        let buyDouble = dataFormatter.number(from: self.buyValue)!.doubleValue
        let price = unitDouble / buyDouble
        return dataFormatter.string(from: NSNumber(value: price)) ?? "1.0"
    }
    
    func getSellPriceByAzn() -> String {
        
        if self.code == "AZN" {
            return aznUnit
        }
        
        let unitDouble = dataFormatter.number(from: aznUnit)!.doubleValue
        let sellDouble = dataFormatter.number(from: self.sellValue)!.doubleValue
        let price = unitDouble / sellDouble
        return dataFormatter.string(from: NSNumber(value: price)) ?? "1.0"
    }
    
    mutating func setAzntUnit(isBuy: Bool, price: String!) {
        if self.code == "AZN" {
            self.aznUnit = price
            return
        }
        let priceDouble = dataFormatter.number(from: price)!.doubleValue
        var valuteDouble = dataFormatter.number(from: self.buyValue)!.doubleValue
        var unit = priceDouble * valuteDouble
        if !isBuy {
            valuteDouble = dataFormatter.number(from: self.sellValue)!.doubleValue
            unit = priceDouble * valuteDouble
        }
    
        self.aznUnit = dataFormatter.string(from: NSNumber(value: unit))!

    }
}

struct ValType {
    let type: String
    let valutes: [Valute]
}

struct ValCurs {
    let date: String
    let name: String
    let description: String
    let valTypes: [ValType]
}


struct ValutesSymbol {
    static let currencySymbols: [String: String] = [
        "AZN": "₼",
        "USD": "$",
        "EUR": "€",
        "AUD": "A$",
        "ARS": "$",
        "BYN": "Br",
        "BRL": "R$",
        "AED": "د.إ",
        "ZAR": "R",
        "KRW": "₩",
        "CZK": "Kč",
        "CLP": "$",
        "CNY": "¥",
        "DKK": "kr",
        "GEL": "₾",
        "HKD": "HK$",
        "INR": "₹",
        "GBP": "£",
        "IDR": "Rp",
        "IRR": "﷼",
        "SEK": "kr",
        "CHF": "CHF",
        "ILS": "₪",
        "CAD": "C$",
        "KWD": "د.ك",
        "KZT": "₸",
        "KGS": "лв",
        "LBP": "ل.ل",
        "MYR": "RM",
        "MXN": "$",
        "MDL": "L",
        "EGP": "£",
        "NOK": "kr",
        "UZS": "лв",
        "PLN": "zł",
        "RUB": "₽",
        "SGD": "S$",
        "SAR": "﷼",
        "SDR": "XDR",
        "TRY": "₺",
        "TWD": "NT$",
        "TJS": "ЅМ",
        "TMT": "T",
        "UAH": "₴",
        "JPY": "¥",
        "NZD": "NZ$"
    ]
}
