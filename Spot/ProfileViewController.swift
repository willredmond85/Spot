//
//  ProfileViewController.swift
//  Spot
//
//  Created by Will Redmond on 5/6/21.
//

import UIKit
import Firebase
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var sizeSegmentControl: UISegmentedControl!
    @IBOutlet weak var hypoSegmentControl: UISegmentedControl!
    @IBOutlet weak var distanceSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var prefLabel: UILabel!
    @IBOutlet weak var hypoLabel: UILabel!

    var user = Auth.auth().currentUser
    var prefernces = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureSegmentedControl(segmentControl: sizeSegmentControl)
        configureSegmentedControl(segmentControl: hypoSegmentControl)
        configureSegmentedControl(segmentControl: distanceSegmentControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateUserInterface()
    }
    
    func updateUserInterface() {
        nameLabel.text = user?.displayName
        emailLabel.text = user?.email
        
        profileImageView.layer.borderWidth = 5.0
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
        
        guard let url = user?.photoURL else {
            profileImageView.image = UIImage(systemName: "person.crop.circle")
            return
        }
        profileImageView.sd_imageTransition = .fade
        profileImageView.sd_imageTransition?.duration = 0.1
        profileImageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "person.crop.circle"))
    }
    
    func configureSegmentedControl(segmentControl: UISegmentedControl) {
        segmentControl.layer.borderColor = UIColor.white.cgColor
        segmentControl.layer.borderWidth = 1.0
    }
    
    func newSizePreference() {
        switch sizeSegmentControl.selectedSegmentIndex {
        case 0: prefernces.prefArray[0].sizePref = "S"
        case 1: prefernces.prefArray[0].sizePref = "M"
        case 2: prefernces.prefArray[0].sizePref = "L"
        case 3: prefernces.prefArray[0].sizePref = "A"
        default:
            print("woah hey u shouldnt be here")
        }
        prefernces.saveData()
    }
    
    func newHypoPreference() {
        switch hypoSegmentControl.selectedSegmentIndex {
        case 0: prefernces.prefArray[0].hypoPref = "Y"
        case 1: prefernces.prefArray[0].hypoPref = "N"
        case 2: prefernces.prefArray[0].hypoPref = "A"
        default:
            print("woah hey u shouldnt be here")
        }
        prefernces.saveData()
    }
    
    func newDistancePreference() {
        switch distanceSegmentControl.selectedSegmentIndex {
        case 0: prefernces.prefArray[0].maxDistance = 50.0
        case 1: prefernces.prefArray[0].maxDistance = 150.0
        case 2: prefernces.prefArray[0].maxDistance = 500.0
        case 3: prefernces.prefArray[0].maxDistance = 0.0
        default:
            print("woah hey u shouldnt be here")
        }
        prefernces.saveData()
    }
    
}
