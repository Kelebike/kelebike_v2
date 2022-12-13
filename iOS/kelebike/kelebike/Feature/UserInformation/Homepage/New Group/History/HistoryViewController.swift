//
//  HistoryViewController.swift
//  kelebike
//
//  Created by Mert on 4.12.2022.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var historyTableView: UITableView!
    var ref: DatabaseReference!
    var query: DatabaseQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        ref = Database.database().reference()
        query = ref.child("History").queryOrdered(byChild: "owner").queryEqual(toValue: Auth.auth().currentUser?.email)
        
        query.observe(.value, with: { (snapshot) in
            for childSnapshot in snapshot.children {
                print(childSnapshot)
            }
        })
        
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows are on the table
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // how to fill a new cell in the screen
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryTableViewCell
        
        cell.id.text = "Bike ID: " + String(indexPath.row)
        cell.date.text = "23.04.2001"
        cell.duration.text = "Bike rented for " + String(indexPath.row) + " days"
        
        cell.historyView.layer.cornerRadius = cell.historyView.frame.height / 4
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // row press action
        print("History pressed at index " + String(indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // row height
        return 110
    }

}
