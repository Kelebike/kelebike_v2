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
    

    override func viewDidLoad() {
        password.isSecureTextEntry.toggle()
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        //Looks for single or multiple taps.
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
        else {
            if(email.text?.hasSuffix("@gtu.edu.tr") == true)
            {
                print("success email")
                signUp()
                
            }
            else{
                print("not a gtu mail")
            }
        }

    }
    
    
    @IBAction func youAlreadyHaveAnAccountTapped(_ sender: Any) {
        print(" you already  have an account tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "login")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
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
            
            // Create new Alert
            let dialogMessage = UIAlertController(title: "Verification", message: "Verification email has been sent to your email adress. Please check your inbox.", preferredStyle: .alert)
            
            // Create OK button with action handler
            let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                print("Ok button tapped")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "login")
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
                
             })
            
            //Add OK button to a dialog message
            dialogMessage.addAction(ok)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)
            
                
                //view changer
            /*
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "homepage")
             vc.modalPresentationStyle = .overFullScreen
             self.present(vc, animated: true)
             */

        
        }
    }
    
}
