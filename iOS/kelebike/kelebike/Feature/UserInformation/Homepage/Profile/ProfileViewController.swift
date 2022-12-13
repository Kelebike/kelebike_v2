//
//  ProfileViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 3.12.2022.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userInfo: UITextField!
    @IBOutlet weak var newPasswordOne: UITextField!
    @IBOutlet weak var newPasswordTwo: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInfo.text = Auth.auth().currentUser?.email
        
        newPasswordOne.attributedPlaceholder = NSAttributedString(
            string: "New password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        newPasswordTwo.attributedPlaceholder = NSAttributedString(
            string: "New password again",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )

    }
    
    @IBAction func signOutTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Error!")
        }
        
        performSegue(withIdentifier: "toLogin", sender: nil)  
        
    }
    
    @IBAction func changeTapped(_ sender: Any) {
        if(newPasswordOne.text!.count == 0) {
            print("Field is empty")
        }
        else if(newPasswordOne.text!.count < 6){
            self.createAlert(title: "Error!", message: "Password to short")
        }
        else if (newPasswordOne.text != newPasswordTwo.text){
            self.createAlert(title: "Error!", message: "Passwords don't match")
        }
        else {
            Auth.auth().currentUser?.updatePassword(to: newPasswordOne.text!) { error in
                if error != nil {
                    self.createAlert(title: "Error!", message: error?.localizedDescription ?? "Password can't be changed")
                }
                else {
                    self.createAlert(title: "Success!", message: "Password has been changed")
                    self.newPasswordOne.text! = ""
                    self.newPasswordTwo.text! = ""
                }
            }
        }
    }
    

    // close keyboard functionality
    @IBAction func doneNewOne(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func doneNewTwo(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    // Create new Alert
    func createAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
}
