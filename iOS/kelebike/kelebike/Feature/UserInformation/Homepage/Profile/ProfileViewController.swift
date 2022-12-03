//
//  ProfileViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 3.12.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var userInfo: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfo.text = Auth.auth().currentUser?.email
        

    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Error!")
        }
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    
}
