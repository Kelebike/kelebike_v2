//
//  SignUpViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 29.10.2022.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordCheck: UITextField!
    @IBOutlet weak var showHideIcon: UIButton!
    @IBOutlet weak var gifView: UIImageView!
    
    var passwordVisible: Bool = true
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        gifView.loadGif(name: "signup")
        
    }

    @IBAction func signUpTapped(_ sender: Any) {
        if(email.text?.isEmpty == true ){
            print("email empty")
            return
        }
        else if(password.text?.isEmpty == true){
            print("password empty")
            return
        }
        else if(password.text!.count < 6){
            print("password to short")
            
            createAlert(title: "Password", message: "Password has to be at least 6 characters long", goBack: false)
            return
        }
        else if(password.text! != passwordCheck.text!){
            print("passwords don't macth")
            
            createAlert(title: "Password", message: "Passwords don't match", goBack: false)
            return
        }
        else {
            if(email.text?.hasSuffix("@gtu.edu.tr") == true)
            {
                print("success email")
                signUp()
                
            }
            else{
                print("not a gtu mail")
                
                createAlert(title: "Mail", message: "The mail is not a GTU mail adress", goBack: false)
            }
        }
    }
    
    func signUp(  ){
        print("signUp button tapped")
        
        Auth.auth().createUser(withEmail: email.text!, password: password.text!){
            (authResult, error) in
            guard let user = authResult?.user, error == nil else{
                print("Error!!? \(String(describing: error?.localizedDescription))")
                return
            }
            user.sendEmailVerification()
            
            self.createAlert(title: "Verification", message: "Verification email has been sent to your email adress. Please check your inbox.", goBack: true)
        }
    }
    
    // Create new Alert
    func createAlert(title: String, message: String, goBack: Bool) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
            
            if(goBack){
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "login")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
            }
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(ok)
        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    // button for showing or hiding the password
    @IBAction func showHideButton(_ sender: Any) {
        password.isSecureTextEntry.toggle()
        passwordCheck.isSecureTextEntry.toggle()
        
        if(passwordVisible){
            showHideIcon.setImage(UIImage(systemName: "eye.slash.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            passwordVisible = false
        }
        else{
            showHideIcon.setImage(UIImage(systemName: "eye.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            passwordVisible = true
        }
    }
    
    // done button func for all of the text fields
    @IBAction func doneMail(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func donePassword(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    @IBAction func doneRePassword(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}
