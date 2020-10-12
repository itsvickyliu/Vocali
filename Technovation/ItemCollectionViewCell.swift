//
//  ItemCollectionViewCell.swift
//  Technovation
//
//  Created by Vicky Liu on 9/29/20.
//  Copyright © 2020 Vicky Liu. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ItemCollectionViewCell"
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return imageView
    }()
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "FredokaOne-Regular", size: 20)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.clipsToBounds = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 7
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(itemImageView)
        contentView.addSubview(pointLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemImageView.frame = contentView.bounds
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            itemImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            pointLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.8),
            pointLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pointLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.3),
            pointLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    public func configure(name: String, image: UIImage, point: Int) {
        itemImageView.image = image
        pointLabel.text = "\(point)"
        if Constants.purchasedItem.contains(name) {
            pointLabel.isHidden = true
        }
        else if point > Constants.points ?? 0 {
            pointLabel.isHidden = false
            pointLabel.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            self.isUserInteractionEnabled = false
        }
        else {
            pointLabel.isHidden = false
            pointLabel.backgroundColor = UIColor(red: 143/255.0, green: 84/255.0, blue: 49/255.0, alpha: 1)
            //UIColor(red: 141/255.0, green: 189/255.0, blue: 243/255.0, alpha: 1)
            self.isUserInteractionEnabled = true
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        itemImageView.image = nil
        pointLabel.text = ""
    }
    
}
