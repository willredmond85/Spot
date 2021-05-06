//
//  SpotUsers.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import Foundation
import Firebase

class SpotUsers {
    var userArray: [SpotUser] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()) {
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: couldnt get listener going")
                return completed()
            }
            
            self.userArray = []
            
            for document in querySnapshot!.documents {
                let user = SpotUser(dictionary: document.data())
                user.documentID = document.documentID
                self.userArray.append(user)
            }
            completed()
        }
        
    }
}
