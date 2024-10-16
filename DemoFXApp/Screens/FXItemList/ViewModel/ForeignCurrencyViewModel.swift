//
//  ForeignCurrencyViewModel.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 9.10.2024.
//

import Foundation

class ForeignCurrencyViewModel {
    private var fxService: FXService
    
    var valutes: [Valute] = [] {
        didSet {
            reloadTableView?()
        }
    }
    
    var reloadTableView: (() -> Void)?
    
    init(currencyService: FXService = FXService()) {
        fxService = currencyService
    }
    
    func fetchForeignCurrencies() {
        fxService.fetchForeignCurrencies { [weak self] ginished in
            self?.valutes = FXSingleton.shared.valCurs.valTypes[1].valutes
        }
    }
}
