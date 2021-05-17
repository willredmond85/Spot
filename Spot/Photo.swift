//
//  Photo.swift
//  Spot
//
//  Created by Will Redmond on 5/6/21.
//

import UIKit
import Firebase

class Photo {
    var image: UIImage
    var photoUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["photoUserID": photoUserID]
    }
    
    init(image: UIImage, photoUserID: String, documentID: String) {
        self.image = image
        self.photoUserID = photoUserID
        self.documentID = documentID
        
    }
    
    convenience init() {
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        self.init(image: UIImage(), photoUserID: photoUserID, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        
        self.init(image: UIImage(), photoUserID: photoUserID, documentID: documentID)
        
    }
    
    func saveData(dog: Dog, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        guard let photoData = self.image.jpegData(compressionQuality: 0.5) else {
            print("ERROR: couldnt convert photo to Data")
            return
        }
        
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        let storageRef = storage.reference().child(dog.documentID).child(documentID)
        
        let uploadTsk = storageRef.putData(photoData, metadata: uploadMetaData) { (metadata, error) in
            if let error = error {
                print("ERROR: upload for ref \(uploadMetaData) failed \(error.localizedDescription)")
            }
        }
        
        uploadTsk.observe(.success) { (snapshot) in
            print("Upload to Firebase Storage successful")
            
            storageRef.downloadURL { (url, error) in
                guard error == nil else {
                    return completion(false)
                }
        
                let dataToSave: [String: Any] = self.dictionary
                
                let ref = db.collection("dogs").document(dog.documentID).collection("photos").document(self.documentID)
                ref.setData(dataToSave) { (error) in
                    guard error == nil else {
                        return completion(false)
                    }
                    completion(true)
                }
            }
            
            uploadTsk.observe(.failure) { (snapshot) in
                print("Upload to Firebase Storage failed")
                completion(false)
            }
        }
           
    }
        
    
    func loadImage(dog: Dog, completion: @escaping (Bool) -> ()) {
        guard dog.documentID != "" else {
            print("ERROR: couldnt find spot to load image")
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference().child(dog.documentID).child(documentID)
        storageRef.getData(maxSize: 25*1024*1024) { (data, error) in
            if let error = error {
                print("ERROR: ref storage ref \(error.localizedDescription)")
                return completion(false)
            } else {
                self.image = UIImage(data: data!) ?? UIImage()
                return completion(true)
            }
        }
    }
    
    func deleteData(dog: Dog, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("dogs").document(dog.documentID).collection("photos").document(documentID).delete { (error) in
            if let error = error {
                print("ERROR: deleting photo documentID\(error.localizedDescription)")
                completion(false)
            } else {
               completion(true)
            }
        }
    }
    
    private func deleteImage(dog: Dog) {
        guard dog.documentID != "" else {
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child(dog.documentID).child(documentID)
        storageRef.delete { error in
            if let error = error {
                print("ERROR: couldnt delete photo\(error.localizedDescription)")
            } else {
                print("photo deleted")
            }
        }
    }
}
