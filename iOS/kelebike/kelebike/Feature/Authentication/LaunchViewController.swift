//
//  LaunchViewController.swift
//  kelebike
//
//  Created by Mert on 4.12.2022.
//

import UIKit
import FirebaseAuth

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(Auth.auth().currentUser?.email ?? "\n\n\nno email\n\n\n")
        
        // checks if there is a user signed in
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "signed", sender: nil)
        }
        else {
            performSegue(withIdentifier: "notSigned", sender: nil)
        }

    }


}
