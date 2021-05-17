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
    @IBOutlet weak var postingSwitch: UISwitch!
    
    var user = Auth.auth().currentUser
    var prefernces = Preferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureSegmentedControl(segmentControl: sizeSegmentControl)
        configureSegmentedControl(segmentControl: hypoSegmentControl)
        configureSegmentedControl(segmentControl: distanceSegmentControl)
        
        self.navigationItem.title = "Your Profile"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prefernces.loadData {
            print(self.prefernces.prefArray)
        }
        
        updateUserInterface()
    }
    
    func updateUserInterface() {
        setSegmentedControls()
        print("hi")
        
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
    
    func setSegmentedControls() {
        prefernces.loadData {
            self.sizeSegmentControl.selectedSegmentIndex = self.prefernces.prefArray[0].sizePref
            self.hypoSegmentControl.selectedSegmentIndex = self.prefernces.prefArray[0].hypoPref
            self.distanceSegmentControl.selectedSegmentIndex = self.prefernces.prefArray[0].maxDistance
            if self.prefernces.prefArray[0].posting{
                self.postingSwitch.isOn = true
            } else {
                self.postingSwitch.isOn = false
            }
                
        }
    }
    
    func configureSegmentedControl(segmentControl: UISegmentedControl) {
        segmentControl.layer.borderColor = UIColor.white.cgColor
        segmentControl.layer.borderWidth = 1.0
    }
    
    func newSizePreference() {
        switch sizeSegmentControl.selectedSegmentIndex {
        case 0: prefernces.prefArray[0].sizePref = 0
        case 1: prefernces.prefArray[0].sizePref = 1
        case 2: prefernces.prefArray[0].sizePref = 2
        case 3: prefernces.prefArray[0].sizePref = 3
        default:
            print("woah hey u shouldnt be here")
        }
        prefernces.saveData()
    }
    
    func newHypoPreference() {
        switch hypoSegmentControl.selectedSegmentIndex {
        case 0: prefernces.prefArray[0].hypoPref = 0
        case 1: prefernces.prefArray[0].hypoPref = 1
        case 2: prefernces.prefArray[0].hypoPref = 2
        default:
            print("woah hey u shouldnt be here")
        }
        prefernces.saveData()
    }
    
    func newDistancePreference() {
        switch distanceSegmentControl.selectedSegmentIndex {
        case 0: prefernces.prefArray[0].maxDistance = 0
        case 1: prefernces.prefArray[0].maxDistance = 1
        case 2: prefernces.prefArray[0].maxDistance = 2
        case 3: prefernces.prefArray[0].maxDistance = 3
        default:
            print("woah hey u shouldnt be here")
        }
        prefernces.saveData()
    }
    
    @IBAction func sizeSegmentPressed(_ sender: UISegmentedControl) {
        newSizePreference()
    }
    
    @IBAction func hypoSegmentPressed(_ sender: UISegmentedControl) {
        newHypoPreference()
    }
    
    @IBAction func distanceSegmentPressed(_ sender: UISegmentedControl) {
        newDistancePreference()
    }
    
    
    @IBAction func postingSwitchChanged(_ sender: UISwitch) {
        if postingSwitch.isOn {
            prefernces.prefArray[0].posting = true
        } else {
            prefernces.prefArray[0].posting = false
        }
    }
    
    
    
    
}
