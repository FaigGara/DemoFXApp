//
//  ForeignCurrencyViewController.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 9.10.2024.
//

import UIKit

class ForeignCurrencyViewController: FXBaseViewController {
    
    private let tableView = UITableView()
    private let convertButton = UIView()
    private let headerView = UIView()
    private let viewModel = ForeignCurrencyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addIndicator()
        self.showLoadingIndicator()
        DispatchQueue.global(qos: .background).async {
            self.viewModel.fetchForeignCurrencies()
            DispatchQueue.main.async {
                self.prepareViewComponents()
            }
        }
    }
}

// Private fonksiyonlar
extension ForeignCurrencyViewController {
    
    private func prepareViewComponents() {
        title = "Valyuta Məzənnələri"
        self.prepareTableView()
        self.prepareTableViewHeader()
        self.prepareConvertButton()
        viewModel.reloadTableView = { [weak self] in
            self?.tableView.reloadData()
            self?.hideLoadingIndicator()
        }
    }
    
    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "CurrencyTableViewCell")
        view.addSubview(convertButton)
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: convertButton.topAnchor, constant: -10)
        ])
    }
    
    private func prepareTableViewHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        
        let valyutaLabel = headerView.createAndAddLabel(text: "VALYUTA", alignment: .left, shouldAddSeltView: true)
        valyutaLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(valyutaLabel)
        
        let buyLabel = headerView.createAndAddLabel(text: "ALIŞ", alignment: .right)
        let sellLabel = headerView.createAndAddLabel(text: "SATIŞ", alignment: .right)
        let mbLabel = headerView.createAndAddLabel(text: "MB", alignment: .right)
        
        let stackView = UIStackView(arrangedSubviews: [buyLabel, sellLabel, mbLabel])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(stackView)
        
        let divider = UIView()
        divider.backgroundColor = .lightGray
        divider.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(divider)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableView.tableHeaderView = headerView
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            headerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            valyutaLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            valyutaLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            valyutaLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.3),
            
            stackView.leadingAnchor.constraint(equalTo: valyutaLabel.trailingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            stackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            stackView.heightAnchor.constraint(equalTo: headerView.heightAnchor, multiplier: 0.8),
            
            divider.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10),
            divider.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -10),
            divider.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
    }
    
    private func prepareConvertButton() {
        
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        convertButton.backgroundColor = .systemGreen
        convertButton.layer.cornerRadius = 5
        convertButton.isUserInteractionEnabled = true
        view.addSubview(convertButton)
        
        let buttonLabel = convertButton.createAndAddLabel(text: "Kovertasiya", alignment: .center, shouldAddSeltView: true)
        buttonLabel.textColor = .white
        buttonLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let image = UIImage(systemName: "repeat.circle")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        convertButton.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            convertButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            convertButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            convertButton.heightAnchor.constraint(equalToConstant: 50),
            
            buttonLabel.centerYAnchor.constraint(equalTo: convertButton.centerYAnchor),
            buttonLabel.centerXAnchor.constraint(equalTo: convertButton.centerXAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: convertButton.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: convertButton.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(convertAction))
        convertButton.addGestureRecognizer(tap)
    }
    
    @objc func convertAction(recognizer: UITapGestureRecognizer) {
        if viewModel.valutes.isEmpty {
            return
        }
        let navController = BaseNavigationController(rootViewController: FXItemsConvertViewController())
        navigationController?.present(navController, animated: true)
    }
}

extension ForeignCurrencyViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.valutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as? CurrencyTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setupViews()
        
        let valute = viewModel.valutes[indexPath.row]
        cell.configure(with: valute)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
