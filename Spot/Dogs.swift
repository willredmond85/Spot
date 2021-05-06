//
//  Dogs.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import Foundation
import Firebase

class Dogs {
    var dogArray: [Dog] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("dogs").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: couldnt get listener going")
                return completed()
            }
            
            self.dogArray = []
            
            for document in querySnapshot!.documents {
                let dog = Dog(dictionary: document.data())
                dog.documentID = document.documentID
                self.dogArray.append(dog)
            }
            completed()
        }
        
    }
}
