//
//  NewDogTableViewController.swift
//  Spot
//
//  Created by Will Redmond on 5/6/21.
//

import UIKit
import Firebase
import GooglePlaces


class NewDogTableViewController: UITableViewController {

    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var sizeSegmentControl: UISegmentedControl!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var hypoSegmentControl: UISegmentedControl!
    @IBOutlet weak var photoSavedLabel: UILabel!
    
    var dog: Dog!
    var photo: Photo!
    var photos: Photos!
    var imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        photoSavedLabel.text = ""
        
        
        if dog == nil {
            dog = Dog()
        }
        photos = Photos()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateFromUserInterface() {
        dog.name = nameTextField.text!
        dog.breed = breedTextField.text!
        switch hypoSegmentControl.selectedSegmentIndex {
        case 0:
            dog.hypo = true
        case 1:
            dog.hypo = false
        default:
            print("this is wrong")
        }
        switch sizeSegmentControl.selectedSegmentIndex {
        case 0:
            dog.size = "S"
        case 1:
            dog.size = "M"
        case 2:
            dog.size = "L"
        default:
            print("this is wrong")
        }
        dog.personality = descriptionTextView.text!
        
    }
    
    
    
    func photoOrCameraPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.accessPhotoLibrary()
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.accessCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func photoButtonPressed(_ sender: UIButton) {
        photoOrCameraPressed()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func addressEditChanged(_ sender: UITextField) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        dog.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: cant unwind review segue")
            }
        }
        
    }
    

}

extension NewDogTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        photo = Photo()
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dog.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            dog.image = originalImage
        }
        photoSavedLabel.text = "photo saved!"
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func accessPhotoLibrary() {
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func accessCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            present(imagePickerController, animated: true, completion: nil)
        } else {
            self.oneButtonAlert(title: "Camera Not Available", message: "There is no camera on this device.")
        }
    }
}

extension NewDogTableViewController: GMSAutocompleteViewControllerDelegate {
    
  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    dog.coordinate = place.coordinate
    addressTextField.text = place.formattedAddress
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: -------", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }
}
