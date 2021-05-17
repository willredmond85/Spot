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
    
    var likedDogs: LikedDogs!
    var photo: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        likedDogs = LikedDogs()
        likedDogs.loadData {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func posterButtonPressed(_ sender: UIButton) {
       // oneButtonAlert(title: "Poster Email:", message: "\(likedDogs.dogsArray[])")
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
        return likedDogs.dogsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LikeTableViewCell
        cell.dog = likedDogs.dogsArray[indexPath.row]
       // cell.photo = photos.photoArray[indexPath.row]
        cell.image = photo
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            likedDogs.dogsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            likedDogs.saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = likedDogs.dogsArray[sourceIndexPath.row]
        likedDogs.dogsArray.remove(at: sourceIndexPath.row)
        likedDogs.dogsArray.insert(itemToMove, at: destinationIndexPath.row)
        likedDogs.saveData()
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != -1 ? true : false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != -1 ? true : false
    }

    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return proposedDestinationIndexPath.row == -1 ? sourceIndexPath : proposedDestinationIndexPath
    }
}
