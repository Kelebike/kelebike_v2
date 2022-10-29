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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                print("Error!!? \(error?.localizedDescription)")
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "homepage")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        
        }
    }
    
}
