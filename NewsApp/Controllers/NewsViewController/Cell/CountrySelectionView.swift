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
        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flagImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 24),
            flagImageView.heightAnchor.constraint(equalToConstant: 16),
            
            countryCodeLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 8),
            countryCodeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            arrowImageView.leadingAnchor.constraint(equalTo: countryCodeLabel.trailingAnchor, constant: 8),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 12),
            arrowImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
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
