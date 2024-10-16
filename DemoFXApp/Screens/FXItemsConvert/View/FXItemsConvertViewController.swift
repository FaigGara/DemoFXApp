//
//  FXItemsConvertViewController.swift
//  DemoFXApp
//
//  Created by Faig GARAZADE on 11.10.2024.
//

import UIKit

class FXItemsConvertViewController: FXBaseViewController {
    private let tableView = UITableView()
    private let viewModel = FXItemConvertViewModel()
    private var segmentedControl = UISegmentedControl(items: ["Alış", "Satış"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        prepareViewComponents()
    }
}

// actions
extension FXItemsConvertViewController {
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        viewModel.changeAznValute(isBuy: sender.selectedSegmentIndex == 0)
    }
    
    @objc func dismiss(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
}

// private functions
extension FXItemsConvertViewController {
    
    private func prepareViewComponents() {
        prepareNavBar()
        prepareTableView()
        
        viewModel.reloadTableView = { [weak self] in
            self?.reloadTableView()
        }
    }
    
    private func reloadTableView() {
        self.tableView.performBatchUpdates({
            if let indexPaths = self.tableView.indexPathsForVisibleRows {
                for indexPath in indexPaths {
                    if self.viewModel.valutes[indexPath.row].code == viewModel.changedValute?.code ?? "" {
                        continue
                    }
                    self.tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            }else {
                self.tableView.reloadData()
            }
        })
    }
    
    private func prepareNavBar() {
        segmentedControl.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismiss(_:)))
    }
    
    private func prepareTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "CurrencyTableViewCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.addViewProgramatically(item: tableView, itemAttribute: .top, itemRelatedBy: .equal, toItem: view.safeAreaLayoutGuide, toItemAttribute: .top, multiplier: 1, constant: 0)
        NSLayoutConstraint.addViewProgramatically(item: tableView, itemAttribute: .leading, itemRelatedBy: .equal, toItem: view.safeAreaLayoutGuide, toItemAttribute: .leading, multiplier: 1, constant: 0)
        NSLayoutConstraint.addViewProgramatically(item: tableView, itemAttribute: .trailing, itemRelatedBy: .equal, toItem: view.safeAreaLayoutGuide, toItemAttribute: .trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.addViewProgramatically(item: tableView, itemAttribute: .bottom, itemRelatedBy: .equal, toItem: view.safeAreaLayoutGuide, toItemAttribute: .bottom, multiplier: 1, constant: 0)
    }
    
    
}

extension FXItemsConvertViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.valutes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyTableViewCell", for: indexPath) as! CurrencyTableViewCell
        cell.delegate = self
        cell.setupViews(listType: .convert)
        
        let valute = viewModel.valutes[indexPath.row]
        cell.configure(with: valute, buy: segmentedControl.selectedSegmentIndex == 0)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    // MARK: scrollviewdelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

// MARK: CurrencyTableViewCellDelegate
extension FXItemsConvertViewController: CurrencyTableViewCellDelegate {
    func valutePriceChanged(_ valute: Valute, newPrice: String) {
        viewModel.changedValute = valute
        viewModel.newPrice = newPrice
        viewModel.changeAznValute(isBuy: segmentedControl.selectedSegmentIndex == 0)
    }
}
