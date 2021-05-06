//
//  DogDetailViewController.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import UIKit
import CoreLocation


class DogDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var hypoImageView: UIImageView!
    
    var dog: Dog!
    var photo: Photo!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    //TODO: add image picker for more images
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        clearUserInterface()
        
        getLocation()
        
        updateUserInterface()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowLikes" {
            let destination = segue.destination as! LikesViewController
//            destination.likedDogs =
        }
    }
    
    func clearUserInterface() {
        imageView.image = UIImage()
        nameLabel.text = ""
        breedLabel.text = ""
        sizeLabel.text = ""
        distanceLabel.text = ""
        descriptionTextView.text = ""
        hypoImageView.image = UIImage()
    }
    
    func updateUserInterface() {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        sizeLabel.text = dog.size
        distanceLabel.text = "\(dog.location.distance(from: currentLocation))"
        descriptionTextView.text = dog.personality
        if dog.hypo {
            hypoImageView.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            hypoImageView.image = UIImage(systemName: "xmark.square.fill")
        }
    }
    

    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        let newLikedDog = LikedDog(name: dog.name, breed: dog.breed, photoURL: photo.photoURL, posterID: dog.posterID, posterName: dog.posterName)
        
        
    }
    
    
    
    
}

extension DogDetailViewController: CLLocationManagerDelegate {
    
    func getLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        handleAuthenticalStatus(status: status)
    }
    
    func handleAuthenticalStatus(status: CLAuthorizationStatus) {
        switch status {
        
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location services denied", message: "It might be that parental controls are restricting location use in this app")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location services", message: "Select 'Settings' below to open device settings and enable location services for this app.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEV ALERT: unknown case of status")
        }
    }
    
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last ?? CLLocation()
        print("current location: \(currentLocation.coordinate.latitude) \(currentLocation.coordinate.longitude)")
        
        sortBasedOnSegmentPressed()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("hi")
    }
}
