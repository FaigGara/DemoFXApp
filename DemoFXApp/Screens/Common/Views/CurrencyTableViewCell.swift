//
//  CurrencyTableViewCell.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 10.10.2024.
//

import UIKit

protocol CurrencyTableViewCellDelegate: AnyObject {
    func valutePriceChanged(_ valute: Valute, newPrice: String)
}

class CurrencyTableViewCell: UITableViewCell {
    
    private let mainStackView = UIStackView()
    private let currencyIconView = UIView()
    private let characterLabel = UILabel()
    private let centerStackView = UIStackView()
    private let rightStackView = UIStackView()
    
    private let currencyNameLabel = UILabel()
    private let currencyDescLabel = UILabel()
    private let buyLabel = UILabel()
    private let sellLabel = UILabel()
    private let mbTextField = FXTextField()
    
    private var listType: FXListType = .list
    var valute: Valute?
    weak var delegate: CurrencyTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(listType: FXListType = .list) {
        self.listType = listType
        selectionStyle = .none
        
        mainStackView.axis = .horizontal
        mainStackView.spacing = 0
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        currencyIconView.backgroundColor = .appGreen
        currencyIconView.translatesAutoresizingMaskIntoConstraints = false
        currencyIconView.layer.cornerRadius = 10
        
        characterLabel.text = "$"
        characterLabel.textAlignment = .center
        characterLabel.font = UIFont(name: "Helvetica", size: 14)
        characterLabel.textColor = .white
        characterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        currencyIconView.addSubview(characterLabel)
        
        centerStackView.axis = .vertical
        centerStackView.spacing = 0
        centerStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        rightStackView.axis = .horizontal
        rightStackView.spacing = 10
        rightStackView.distribution = .fillEqually
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        currencyNameLabel.prepareLabel(textColor: .black, textAlignment: .left)
        currencyDescLabel.prepareLabel(textColor: .gray, textAlignment: .left)
        buyLabel.prepareLabel(textColor: .black, textAlignment: .right)
        sellLabel.prepareLabel(textColor: .black, textAlignment: .right)
        
        mbTextField.prepare(textColor: .black, textAlignment: .right, isEnable: listType == .convert)
        mbTextField.delegate = self
        
        centerStackView.addArrangedSubview(currencyNameLabel)
        centerStackView.addArrangedSubview(currencyDescLabel)
        
        rightStackView.addArrangedSubview(buyLabel)
        rightStackView.addArrangedSubview(sellLabel)
        rightStackView.addArrangedSubview(mbTextField)
        
        mainStackView.addArrangedSubview(centerStackView)
        mainStackView.addArrangedSubview(rightStackView)
        
        addSubview(currencyIconView)
        addSubview(mainStackView)
        
        let width = frame.width - 20
        let centerStackViewWidth = width / 2.5
        let rightWidth = (width - centerStackViewWidth) / 3
        
        NSLayoutConstraint.activate([
            currencyIconView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            currencyIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            currencyIconView.widthAnchor.constraint(equalToConstant: 36),
            currencyIconView.heightAnchor.constraint(equalToConstant: 36),
            
            mainStackView.leadingAnchor.constraint(equalTo: currencyIconView.trailingAnchor, constant: 10),
            mainStackView.centerYAnchor.constraint(equalTo: currencyIconView.centerYAnchor, constant: -3),
            mainStackView.heightAnchor.constraint(equalToConstant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            characterLabel.centerXAnchor.constraint(equalTo: currencyIconView.centerXAnchor),
            characterLabel.centerYAnchor.constraint(equalTo: currencyIconView.centerYAnchor),
            
            buyLabel.widthAnchor.constraint(equalToConstant: rightWidth),
            sellLabel.widthAnchor.constraint(equalToConstant: rightWidth),
            mbTextField.widthAnchor.constraint(equalToConstant: rightWidth)
        ])
        
        NSLayoutConstraint.activate([
            currencyIconView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            currencyIconView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            currencyIconView.widthAnchor.constraint(equalToConstant: 36),
            currencyIconView.heightAnchor.constraint(equalToConstant: 36),
            
            mainStackView.leadingAnchor.constraint(equalTo: currencyIconView.trailingAnchor, constant: 10),
            mainStackView.centerYAnchor.constraint(equalTo: currencyIconView.centerYAnchor, constant: -3),
            mainStackView.heightAnchor.constraint(equalToConstant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            characterLabel.centerXAnchor.constraint(equalTo: currencyIconView.centerXAnchor),
            characterLabel.centerYAnchor.constraint(equalTo: currencyIconView.centerYAnchor),
            
            buyLabel.widthAnchor.constraint(equalToConstant: rightWidth),
            sellLabel.widthAnchor.constraint(equalToConstant: rightWidth),
            mbTextField.widthAnchor.constraint(equalToConstant: rightWidth)
        ])
    }
    
    func configure(with valute: Valute) {
        self.valute = valute
        characterLabel.text = valute.symbol
        currencyNameLabel.text = valute.code
        currencyDescLabel.text = valute.name
        buyLabel.text = valute.buyValue
        sellLabel.text = valute.sellValue
        mbTextField.text = valute.value
    }
    
    func configure(with valute: Valute, buy: Bool){
        self.valute = valute
        buyLabel.isHidden = true
        sellLabel.isHidden = true
        characterLabel.text = valute.symbol
        
        currencyNameLabel.text = valute.code
        currencyDescLabel.text = valute.name
        buyLabel.text = valute.buyValue
        sellLabel.text = valute.sellValue
        mbTextField.text = buy ? valute.getBuyPriceByAzn() : valute.getSellPriceByAzn()
    }
}

extension CurrencyTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = string.replacingOccurrences(of: ",", with: ".")
        
        if (textField.text ?? "").contains(".") && text.contains(".") {
            return false
        }
        
        if (textField.text ?? "").isEmpty && text == "." {
            textField.text = "0."
            if let valute = self.valute {
                self.delegate?.valutePriceChanged(valute, newPrice: textField.text!)
            }
            return false
        }
        
        if textField.text == "0" && text != "." && !text.isEmpty {
            textField.text = text
            if let valute = self.valute {
                self.delegate?.valutePriceChanged(valute, newPrice: text)
            }
            return false
        }
        
        if let currentText = textField.text,
           let textRange = Range(range, in: currentText) {
            
            var updatedText = currentText.replacingCharacters(in: textRange, with: text)
            
            if updatedText.isEmpty {
                updatedText = "0"
            }
            
            textField.text = updatedText
            if let valute = self.valute {
                self.delegate?.valutePriceChanged(valute, newPrice: updatedText)
            }
            return false
        }
        
        return true
    }
}
