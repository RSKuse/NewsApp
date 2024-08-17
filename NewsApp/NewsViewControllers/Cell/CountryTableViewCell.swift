//
//  CountryTableViewCell.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/14.
//

import Foundation
import UIKit

class CountryTableViewCell: UITableViewCell {
    
    lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .systemBlue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(flagImageView)
        addSubview(countryLabel)
        addSubview(checkmarkImageView)
 
        flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        flagImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        flagImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        flagImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        countryLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        countryLabel.leftAnchor.constraint(equalTo: flagImageView.rightAnchor, constant: 20).isActive = true
        
        checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        checkmarkImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
    }
    
    func configure(with country: NewsCountry, isSelected: Bool) {
        countryLabel.text = country.rawValue.uppercased()
        flagImageView.image = UIImage(named: "flag_\(country.rawValue)")
        checkmarkImageView.isHidden = !isSelected
    }
}
