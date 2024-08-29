//
//  CountrySelectionView.swift
//  NewsApp
//
//  Created by Reuben Simphiwe Kuse on 2024/08/29.
//

import Foundation
import UIKit

class CountrySelectionView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("CountrySelectionView Frame: \(self.frame)")
    }
    
    // Closure that will be triggered when the view is tapped
    var onTap: (() -> Void)?
    
    private lazy var flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var countryCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        setupUI()
        setupTapGesture()  // Ensure tap gesture is set up to trigger the closure
        print("CountrySelectionView Frame: \(self.frame)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(flagImageView)
        addSubview(countryCodeLabel)
        addSubview(arrowImageView)
        
        
        flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        flagImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        flagImageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        countryCodeLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 8).isActive = true
        countryCodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        arrowImageView.leadingAnchor.constraint(equalTo: countryCodeLabel.trailingAnchor, constant: 8).isActive = true
        arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        arrowImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        arrowImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap() {
        print("CountrySelectionView tapped")  // Debugging print statement
        onTap?()
    }
    
    func configure(flag: UIImage?, countryCode: String) {
        flagImageView.image = flag
        countryCodeLabel.text = countryCode
    }
}

extension CountrySelectionView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
