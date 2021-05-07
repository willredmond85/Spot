//
//  LikeTableViewCell.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import UIKit
import SDWebImage

class LikeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var posterButton: UIButton!
    @IBOutlet weak var dogImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var dog: LikedDog! {
        didSet {
            nameLabel.text = dog.name
            breedLabel.text = dog.breed
            priceLabel.text = "$\(dog.price)"
            posterButton.setTitle(dog.posterName, for: .normal)
            
            // round corners of original dog image
            dogImageView.layer.cornerRadius = 10
            dogImageView.layer.borderWidth = 2
            dogImageView.layer.borderColor = UIColor.white.cgColor
            dogImageView.clipsToBounds = true
            
            guard let url = URL(string: dog.photoURL) else {
                dogImageView.image = UIImage(systemName: "questionmark")
                return
            }
            
            dogImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "questionmark"))
        }
    }

}
