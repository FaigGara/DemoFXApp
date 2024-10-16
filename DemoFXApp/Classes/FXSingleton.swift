//
//  FXSingleton.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 11.10.2024.
//

import Foundation

class FXSingleton {
    static let shared = FXSingleton()
    
    var valCurs: ValCurs = ValCurs(date: "", name: "", description: "", valTypes: [])
    
}
