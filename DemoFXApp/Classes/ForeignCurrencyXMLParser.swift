//
//  ForeignCurrencyXMLParser.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 11.10.2024.
//

import Foundation

class ForeignCurrencyXMLParser: NSObject, XMLParserDelegate {
    private var currentElement = ""
        private var currentValute: Valute?
        private var currentValType: ValType?
        private var valutes = [Valute]()
        var valTypes = [ValType]()
        
        private var currentCode = ""
        private var currentNominal = ""
        private var currentName = ""
        private var currentValue = ""
        private var currentType = ""
        
        private var date: String = ""
        private var name: String = ""
        private var descriptionText: String = ""
        var valCurs: ValCurs = ValCurs(date: "", name: "", description: "", valTypes: [])
        
        private let decimalFormatter: Foundation.NumberFormatter = NumberFormatterFactory.decimalNumberFormatter()
    
        func parse(data: Data) -> ValCurs? {
            let parser = XMLParser(data: data)
            parser.delegate = self
            if parser.parse() {
                return valCurs
            }
            return nil
        }
        
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            currentElement = elementName
            
            if currentElement == "ValCurs" {
                date = attributeDict["Date"] ?? ""
                name = attributeDict["Name"] ?? ""
                descriptionText = attributeDict["Description"] ?? ""
            } else if currentElement == "ValType" {
                currentType = attributeDict["Type"] ?? ""
                valutes.removeAll()
            } else if currentElement == "Valute" {
                currentCode = attributeDict["Code"] ?? ""
            }
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if currentElement == "Nominal" {
                currentNominal += trimmedString
            } else if currentElement == "Name" {
                currentName += trimmedString
            } else if currentElement == "Value" {
                currentValue += trimmedString
            }
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "Valute" {
                let currentSellValue = calculateSellValue(currentValue: currentValue)
                let valute = Valute(code: currentCode, nominal: currentNominal, name: currentName, buyValue: currentValue, sellValue: currentSellValue, value: currentValue)
                valutes.append(valute)
                resetValuteParams()
            } else if elementName == "ValType" {
                let valType = ValType(type: currentType, valutes: valutes)
                valTypes.append(valType)
                resetValTypeParams()
            } else if elementName == "ValCurs" {
                valCurs = ValCurs(date: date, name: name, description: descriptionText, valTypes: valTypes)
                resetValCursParams()
            }
        }
}

// private functions
extension ForeignCurrencyXMLParser {
    private func resetValuteParams() {
        currentNominal = ""
        currentName = ""
        currentValue = ""
    }
    
    private func resetValTypeParams() {
        currentType = ""
    }
    
    private func resetValCursParams() {
        date = ""
        name = ""
        descriptionText = ""
    }
    
    private func calculateSellValue(currentValue: String) -> String {
        if let number = decimalFormatter.number(from: currentValue) {
            let doubleNumb = number.doubleValue * 0.9
            return decimalFormatter.string(from: NSNumber(value: doubleNumb)) ?? "0.00"
        }
        
        return ""
    }
}
