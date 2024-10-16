//
//  UIColorExtension.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 10.10.2024.
//

import UIKit

extension UIColor {
    static func getColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    static var appGreen: UIColor {
        .getColor(red: 118, green: 188, blue: 32)
    }
}


extension UIView {
    func createAndAddLabel(text: String, alignment: NSTextAlignment, color: UIColor = .black, font: UIFont? = UIFont(name: "Helvetica-Bold", size: 12), shouldAddSeltView: Bool = false) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = alignment
        label.font = font
        label.textColor = color
        if shouldAddSeltView {
            addSubview(label)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

extension UILabel {
    func prepareLabel(textColor: UIColor, textAlignment: NSTextAlignment)  {
        self.text = "-"
        self.textAlignment = textAlignment
        self.font = UIFont(name: "Helvetica", size: 12)
        self.textColor = textColor
    }
}

class FXTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(paste(_:)) || action == #selector(cut(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}


extension FXTextField {
    func prepare(textColor: UIColor, textAlignment: NSTextAlignment, isEnable: Bool = false)  {
        self.text = "-"
        self.textAlignment = textAlignment
        self.font = UIFont(name: "Helvetica", size: 12)
        self.textColor = textColor
        self.borderStyle = .none
        self.isEnabled = isEnable
        self.keyboardType = .decimalPad
        self.tintColor = .appGreen
    }
    

}

extension NSLayoutConstraint {
    static func addViewProgramatically(item: Any,
                                       itemAttribute: NSLayoutConstraint.Attribute,
                                       itemRelatedBy: NSLayoutConstraint.Relation,
                                       toItem: Any?,
                                       toItemAttribute: NSLayoutConstraint.Attribute,
                                       multiplier: CGFloat,
                                       constant: CGFloat
   ) {
       let constraint = NSLayoutConstraint(item: item, attribute: itemAttribute, relatedBy: itemRelatedBy, toItem: toItem, attribute: toItemAttribute, multiplier: multiplier, constant: constant)
       constraint.isActive = true
   }
}
