//
//  BaseNavigationController.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 9.10.2024.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = false
        navigationBar.backgroundColor = .white
        navigationBar.tintColor = .black
    }

}
