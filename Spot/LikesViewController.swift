//
//  LikesViewController.swift
//  Spot
//
//  Created by Will Redmond on 5/5/21.
//

import UIKit

class LikesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var likedDogs: [Dog] = []
    
    var dogs: Dogs!
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dogs = Dogs()
        dogs.loadData {
            self.tableView.reloadData()
        }
        
    }
    
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
        }
    }
    
}

extension LikesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dogs.dogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LikeTableViewCell
        cell.dog = dogs.dogArray[indexPath.row]
        cell.photo = photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            likedDogs.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = likedDogs[sourceIndexPath.row]
        likedDogs.remove(at: sourceIndexPath.row)
        likedDogs.insert(itemToMove, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath
    }
}
