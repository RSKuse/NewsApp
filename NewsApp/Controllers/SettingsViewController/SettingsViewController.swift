//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/14.
//

import UIKit

// Delegate Pattern
protocol SettingsViewControllerDelegate: AnyObject {
    func didSelectCountry(_ country: NewsCountry)
    
}

class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    
    let viewModel = NewsViewModel()
    var selectedCountry: NewsCountry?
    
    lazy var countriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        title = "Choose A Country"
        navigationItem.largeTitleDisplayMode = .never
        selectedCountry = viewModel.selectedCountry
        view.addSubview(countriesTableView)
        
        
        countriesTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        countriesTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        countriesTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        countriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.countries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.cellID, for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }

        let country = viewModel.countries[indexPath.row]
        let isSelected = country == selectedCountry
        cell.configure(with: country, isSelected: isSelected)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = viewModel.countries[indexPath.row]
        UserDefaultsManager.shared.storeValue(selectedCountry.rawValue, key: .country)
        delegate?.didSelectCountry(selectedCountry)
        navigationController?.popViewController(animated: true)
    }
}
