//
//  CarCell.swift
//  FancyCars
//
//  Created by Michael Chung on 4/24/19.
//  Copyright © 2019 Michael Chung. All rights reserved.
//

import Foundation
import UIKit

class CarCell: UITableViewCell {
    
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var availible: UILabel!
    
    
    func setData(data:Car) {
        nameLabel.text = data.name
        makeLabel.text = data.make
        modelLabel.text = data.model
        carImage?.contentMode = .scaleAspectFit
        carImage?.clipsToBounds = true
        carImage?.image = UIImage(named: data.img)
        year.text = "\(data.year)"
        
        availible.text = data.available
        
        // could use enum
        buyButton.isHidden = true
        
        if availible.text == "In Dealership" {
            buyButton.isHidden = false
        }
        
    }
    
    func isLoading() {
        nameLabel.alpha = 0.0
        UIView.animate(withDuration: 0.7) { [weak self] in
            self?.nameLabel.alpha = 1.0
            self?.nameLabel.text = "Is Loading"
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        makeLabel.text = nil
        modelLabel.text = nil
        carImage?.contentMode = .scaleAspectFit
        carImage?.clipsToBounds = true
        carImage?.image = nil
        year.text = nil
    }
}
