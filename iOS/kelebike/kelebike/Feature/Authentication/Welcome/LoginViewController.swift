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
    @IBOutlet weak var showHideIcon: UIButton!
    
    var passwordVisible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
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
    
    // button for showing or hiding the password
    @IBAction func showHideButton(_ sender: Any) {
        password.isSecureTextEntry.toggle()
        
        if(passwordVisible){
            showHideIcon.setImage(UIImage(systemName: "eye.slash.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            passwordVisible = false
        }
        else{
            showHideIcon.setImage(UIImage(systemName: "eye.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), for: .normal)
            passwordVisible = true
        }        
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
        
        email.text! = ""
        password.text! = ""
        
        performSegue(withIdentifier: "toSignup", sender: nil)
    }
}
