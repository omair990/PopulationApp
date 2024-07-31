//
//  PopulationTableViewCell.swift
//  PopulationApp
//
//  Created by Muhammad Umair on 24/01/1446 AH.
//
import UIKit

protocol PopulationTableViewCellDelegate: AnyObject {
    func didTapDetailButton(for region: PopulationData)
}

class PopulationTableViewCell: UITableViewCell {
    
    weak var delegate: PopulationTableViewCellDelegate?
    
    private let backgroundCardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 3
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.backgroundColor = .white
        return view
    }()
    
    private let regionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()
    
    private let populationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let yearLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        return label
    }()
    
    private let regionTypeImageView: UIImageView = {  // ImageView for region type
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let detailButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Details", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        detailButton.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        setupUI()
    }
    
    private var regionData: PopulationData?
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(regionTypeImageView)  // Add regionTypeImageView to the card view
        backgroundCardView.addSubview(regionLabel)
        backgroundCardView.addSubview(populationLabel)
        backgroundCardView.addSubview(yearLabel)
        backgroundCardView.addSubview(detailButton)
        
        NSLayoutConstraint.activate([
            backgroundCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            regionTypeImageView.topAnchor.constraint(equalTo: backgroundCardView.topAnchor, constant: 20),
            regionTypeImageView.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20),
            regionTypeImageView.widthAnchor.constraint(equalToConstant: 30),
            regionTypeImageView.heightAnchor.constraint(equalToConstant: 30),
            
            regionLabel.centerYAnchor.constraint(equalTo: regionTypeImageView.centerYAnchor),
            regionLabel.leadingAnchor.constraint(equalTo: regionTypeImageView.trailingAnchor, constant: 10),
            regionLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            
            populationLabel.topAnchor.constraint(equalTo: regionTypeImageView.bottomAnchor, constant: 20),
            populationLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20),
            populationLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            
            yearLabel.topAnchor.constraint(equalTo: populationLabel.bottomAnchor, constant: 10),
            yearLabel.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20),
            yearLabel.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            
            detailButton.topAnchor.constraint(equalTo: yearLabel.bottomAnchor, constant: 20),
            detailButton.leadingAnchor.constraint(equalTo: backgroundCardView.leadingAnchor, constant: 20),
            detailButton.trailingAnchor.constraint(equalTo: backgroundCardView.trailingAnchor, constant: -20),
            detailButton.bottomAnchor.constraint(equalTo: backgroundCardView.bottomAnchor, constant: -20),
            detailButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func detailButtonTapped() {
        if let regionData = regionData {
            delegate?.didTapDetailButton(for: regionData)
        }
    }
    
    func configure(with data: PopulationData) {
        self.regionData = data
        regionLabel.text = data.regionName
        populationLabel.text = "Population: \(data.population)"
        yearLabel.text = "Year: \(data.year)"
        
        // Set image and background color based on region type
        if data.regionType == .state {
            regionTypeImageView.image = UIImage(systemName: "building.2")
            backgroundCardView.backgroundColor = UIColor.systemGray6
        } else {
            regionTypeImageView.image = UIImage(systemName: "globe")
            backgroundCardView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.3)
        }
    }
}
