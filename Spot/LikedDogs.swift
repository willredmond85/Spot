//
//  LikedDogs.swift
//  Spot
//
//  Created by Will Redmond on 5/6/21.
//

import Foundation

class LikedDogs {
    var dogsArray: [LikedDog] = []
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("likedDogs").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(dogsArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data")
        }
    }
    
    func loadData (completed: @escaping () -> () ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            itemsArray = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            
        } catch {
            print("ERROR: Could not load data")
        }
        completed()
    }
}
