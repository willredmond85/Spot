//
//  Preferences.swift
//  Spot
//
//  Created by Will Redmond on 5/6/21.
//

import Foundation

class Preferences {
    var prefArray: [Preference] = [Preference(sizePref: 3, hypoPref: 2, maxDistance: 3, posting: true)]
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("preferences").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(prefArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("ERROR: Could not save data")
        }
    }
    
    func loadData (completed: @escaping () -> () ) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("preferences").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            prefArray = try jsonDecoder.decode(Array<Preference>.self, from: data)
            
        } catch {
            print("ERROR: Could not load data")
        }
        completed()
    }
}
