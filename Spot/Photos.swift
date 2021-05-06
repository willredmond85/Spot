//
//  Photos.swift
//  Spot
//
//  Created by Will Redmond on 5/6/21.
//

import Foundation
import Firebase

class Photos {
    var photoArray: [Photo] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(dog: Dog, completed: @escaping () -> ()) {
        guard dog.documentID != "" else {
            return
        }
        db.collection("dogs").document(dog.documentID).collection("photos").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: couldnt get listener going")
                return completed()
            }
            
            self.photoArray = []
            
            for document in querySnapshot!.documents {
                let photo = Photo(dictionary: document.data())
                photo.documentID = document.documentID
                self.photoArray.append(photo)
            }
            completed()
        }
        
    }
}
