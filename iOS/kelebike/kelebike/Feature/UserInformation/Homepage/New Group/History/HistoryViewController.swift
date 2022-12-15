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
    
    var query: Query!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        let db = Firestore.firestore()
        //query = db.collection("History").whereField("bike.owner", isEqualTo: (Auth.auth().currentUser?.email)!)
        query = db.collection("Blacklist")
        
        
        query.getDocuments { (snapshot, _) in
            let documents = snapshot!.documents
            
            try! documents.forEach { document in
                let h: Blacklist = try document.decoded()
                print(h)
            }
        }
        
        
        
        
        
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
