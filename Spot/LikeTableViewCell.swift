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
    
    
    var dog: LikedDog! {
        didSet {
            nameLabel.text = dog.name
            breedLabel.text = dog.breed
            posterButton.setTitle(dog.posterID, for: .normal)
            
            // round corners of original dog image
            dogImageView.layer.cornerRadius = 20
            dogImageView.layer.borderWidth = 3
            dogImageView.layer.borderColor = UIColor.black.cgColor
            dogImageView.clipsToBounds = true
            
            guard let url = URL(string: photo.photoURL) else {
                dogImageView.image = UIImage(systemName: "questionmark")
                return
            }
            
            dogImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "questionmark"))
        }
    }

}
