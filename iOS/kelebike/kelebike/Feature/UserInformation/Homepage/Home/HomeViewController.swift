//
//  HomeViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 30.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


var i : Int = 0

class HomeViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var homeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func putDataTapped(_ sender: Any) {
        let docRef = db.document("Bike/" + String(i))
        docRef.setData([String(i) : i])
        i = i + 1
        
    }
    
    
}
