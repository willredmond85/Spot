//
//  DogDetailViewController.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import UIKit
import CoreLocation
import SDWebImage


class DogDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var hypoImageView: UIImageView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    var dog: Dog!
    var photo: Photo!
    var likedDogs = LikedDogs()
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation!
    //TODO: add image picker for more images
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        if dog == nil {
            dog = Dog()
        }
        
        dog = Dog(name: "Loots", coordinate: CLLocationCoordinate2D(), size: "S", breed: "Bichon Frise", personality: "Loving \nActs like a cat \nVery timid \nOnce had nasal mites!? \nLikes to eat when we eat\nHis real name is Louie", price: 999, hypo: true, liked: false, posterID: "", posterName: "Will Redmond", documentID: "")
        photo = Photo(image: UIImage(named: "lou")!, photoUserID: "", photoURL: "", documentID: "")
        
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
            
            likedDogs.loadData {
                destination.likedDogs = self.likedDogs
            }
        }
    }
    
    func clearUserInterface() {
        imageView.image = UIImage()
        nameLabel.text = ""
        breedLabel.text = ""
        sizeLabel.text = ""
        distanceLabel.text = ""
        descriptionTextView.text = ""
        priceLabel.text = ""
        hypoImageView.image = UIImage()
        if dog.liked {
            likeButton.isEnabled = false
        }
    }
    
    func updateUserInterface() {
        nameLabel.text = dog.name
        breedLabel.text = dog.breed
        sizeLabel.text = dog.size
        priceLabel.text = "$\(dog.price)"
        distanceLabel.text = "" //"\(dog.location.distance(from: currentLocation))"
        descriptionTextView.text = dog.personality
        if dog.hypo {
            hypoImageView.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            hypoImageView.image = UIImage(systemName: "xmark.square.fill")
        }
        imageView.layer.cornerRadius = 10
        likeButton.layer.cornerRadius = 4
        dislikeButton.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        
//        guard let url = URL(string: photo.photoURL) else {
//            imageView.image = UIImage(systemName: "questionmark")
//            return
//        }
        imageView.image = photo.image
//        imageView.sd_setImage(with: url, placeholderImage: UIImage(systemName: "questionmark"))
    }
    

    @IBAction func dislikeButtonPressed(_ sender: UIButton) {
        //TODO: go to a new dog
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        dog.liked = true
        likeButton.isEnabled = false
        let newLikedDog = LikedDog(name: dog.name, breed: dog.breed, photoURL: photo.photoURL, posterID: dog.posterID, posterName: dog.posterName, price: dog.price)
        likedDogs.dogsArray.append(newLikedDog)
        likedDogs.saveData()
        //TODO: go to a new dog
        //TODO: add like animation
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("hi")
    }
}
