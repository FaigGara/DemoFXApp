//
//  FXItemConvertViewModel.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 11.10.2024.
//

import Foundation

class FXItemConvertViewModel {
    var aznValute = Valute(code: "AZN", nominal: "1", name: "Azərbaycan Manatı", buyValue: "1", sellValue: "1", value: "1")
    var valCurs: ValCurs = FXSingleton.shared.valCurs
    var valutes =  [Valute]()
    
    
    var changedValute: Valute?
    var newPrice: String?
    
    var reloadTableView: (() -> Void)?
    
    init() {
        valutes.append(aznValute)
        valutes.append(contentsOf: valCurs.valTypes[1].valutes)
    }
    
    func changeAznValute(isBuy: Bool) {
        guard let valute = self.changedValute else {
            for index in valutes.indices {
                valutes[index].aznUnit = valutes.first?.aznUnit ?? "1.0"
            }
            reloadTableView?()
            return
        }
        
        let price = self.newPrice ?? "1.0"
        
        var tempValute = valute
        tempValute.setAzntUnit(isBuy: isBuy, price: price)
        let aznUnit = tempValute.aznUnit
        
        for index in valutes.indices {
            valutes[index].aznUnit = aznUnit
        }
        reloadTableView?()
    }
}
