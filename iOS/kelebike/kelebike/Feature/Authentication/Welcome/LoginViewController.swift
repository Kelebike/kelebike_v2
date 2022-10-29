//
//  LoginViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 29.10.2022.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        password.isSecureTextEntry.toggle()
        
        /*
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemPurple.cgColor
        ]
        view.layer.addSublayer(gradientLayer)
        */
        
        
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
    

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        print("forgot password tappped")
    }
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        print("login tapped")
        
    }
    
    
    @IBAction func dontYouHaveAnAccountTapped(_ sender: Any) {
        print("dont you have an account tapped")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "signUp")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
        
    }
}
