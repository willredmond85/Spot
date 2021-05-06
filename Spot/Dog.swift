//
//  Dog.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import Foundation
import Firebase
import MapKit

class Dog: NSObject, MKAnnotation {
    var name: String
    var coordinate: CLLocationCoordinate2D
    var size: String
    var breed: String
    var personality: String
    var hypo: Bool
    var like: Bool
    var posterID: String
    var posterName: String
    var documentID: String
    
    var dictionary: [String: Any] {
        return ["name": name, "latitude": latitude, "longitude": longitude, "size": size, "breed": breed, "personality": personality, "hypo": hypo, "like": like, "posterID": posterID, "posterName": posterName]
    }
    
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    
    var longitude: CLLocationDegrees {
        return coordinate.longitude
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(name: String, coordinate: CLLocationCoordinate2D, size: String, breed: String, personality: String, hypo: Bool, like: Bool, posterID: String, posterName: String, documentID: String) {
        self.name = name
        self.coordinate = coordinate
        self.size = size
        self.breed = breed
        self.personality = personality
        self.hypo = hypo
        self.like = like
        self.posterID = posterID
        self.posterName = posterName
        self.documentID = documentID
    }
    
    convenience override init() {
        let posterID = Auth.auth().currentUser?.uid ?? ""
        let posterName = Auth.auth().currentUser?.displayName ?? ""
        self.init(name: "", coordinate: CLLocationCoordinate2D(), size: "", breed: "", personality: "", hypo: false, like: false, posterID: posterID, posterName: posterName, documentID: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let name = dictionary["name"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let size = dictionary["size"] as! String? ?? ""
        let breed = dictionary["breed"] as! String? ?? ""
        let personality = dictionary["personality"] as! String? ?? ""
        let hypo = dictionary["hypo"] as! Bool? ?? false
        let like = dictionary["like"] as! Bool? ?? false
        let posterID = dictionary["posterID"] as! String? ?? ""
        let posterName = dictionary["posterName"] as! String? ?? ""
        
        self.init(name: name, coordinate: coordinate, size: size, breed: breed, personality: personality, hypo: hypo, like: like, posterID: posterID, posterName: posterName, documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        guard let posterID = Auth.auth().currentUser?.uid else {
            print("ERROR: could not save data bc we dont have a valid postingID")
            return completion(false)
        }
        self.posterID = posterID
        let dataToSave: [String: Any] = self.dictionary
        if self.documentID == "" {
            var ref: DocumentReference? = nil
            ref = db.collection("dogs").addDocument(data: dataToSave) { (error) in
                guard error == nil else {
                    return completion(false)
                }
                self.documentID = ref!.documentID
                completion(true)
            }
            
        } else {
            let ref = db.collection("dogs").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil else {
                    return completion(false)
                }
                completion(true)
            }
        }
    }
    
    
}
