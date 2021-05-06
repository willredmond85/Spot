//
//  SpotUser.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import Foundation
import Firebase

class SpotUser {
    var email: String
    var displayName: String
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["email": email, "displayName": displayName, "photoURL": photoURL]
    }
    
    init(email: String, displayName: String, photoURL: String, documentID: String) {
        self.email = email
        self.displayName = displayName
        self.photoURL = photoURL
        self.documentID = documentID
    }
    
    convenience init(user: User) {
        let email = user.email ?? ""
        let displayName = user.displayName ?? ""
        let photoURL = (user.photoURL != nil ? "\(user.photoURL)" : "")
        self.init(email: email, displayName: displayName, photoURL: photoURL, documentID: user.uid)
    }
    
    convenience init(dictionary: [String: Any]) {
        let email = dictionary["email"] as! String? ?? ""
        let displayName = dictionary["displayName"] as! String? ?? ""
        let photoURL = dictionary["photoURL"] as! String? ?? ""
        self.init(email: email, displayName: displayName, photoURL: photoURL, documentID: "")
    }
    
    func saveIfNewUser(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(documentID)
        userRef.getDocument { (document, error) in
            guard error == nil else {
                return completion(false)
            }
            guard document?.exists == false else {
                return completion(true)
            }
            let dataToSave: [String: Any] = self.dictionary
            db.collection("users").document(self.documentID).setData(dataToSave) { (error) in
                guard error == nil else {
                    return completion(false)
                }
                return completion(true)
            }
        }
    }
    
}
