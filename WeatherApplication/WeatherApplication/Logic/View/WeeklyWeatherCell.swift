//
//  WeaklyWeatherCell.swift
//  WeatherApplication
//
//  Created by Narek Ektubaryan on 12/27/20.
//

import Foundation
import UIKit

class WeeklyWeatherCell: UITableViewCell {
    
    var weeklyWeatherListCellViewModel : WeeklyWeatherListCellViewModel? {
        didSet {
            nameLabel.text = weeklyWeatherListCellViewModel?.titleText
            sizeLabel.text = weeklyWeatherListCellViewModel?.sizeText
            dateLabel.text = weeklyWeatherListCellViewModel?.dateText
        }
    }
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = .darkGray
        return label
    }()
    
    private var sizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(nameLabel)
        self.addSubview(sizeLabel)
        self.addSubview(dateLabel)
        setNameLabelConstraints()
        setSizeLabelConstraints()
        setDataLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setNameLabelConstraints() {
        let nameLabelConstraints = [
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
   private func setSizeLabelConstraints() {
        let sizeLabelConstraints = [
            sizeLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -80),
            sizeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            sizeLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(sizeLabelConstraints)
    }
    
   private func setDataLabelConstraints() {
        let dataLabelConstraints = [
            dateLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(dataLabelConstraints)
    }
}
