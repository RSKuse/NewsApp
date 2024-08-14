//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/14.
//

import UIKit

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
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        selectedCountry = viewModel.selectedCountry
        view.addSubview(countriesTableView)

        NSLayoutConstraint.activate([
            countriesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            countriesTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            countriesTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            countriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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
        UserDefaultStorage.country.storeValue(selectedCountry.rawValue)
        delegate?.didSelectCountry(selectedCountry)
        navigationController?.popViewController(animated: true)
    }
}
