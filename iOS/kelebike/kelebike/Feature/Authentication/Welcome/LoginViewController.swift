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
    @IBOutlet weak var gifView: UIImageView!
    
    var passwordVisible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        gifView.loadGif(name: "login")
        /*
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.systemPink.cgColor,
            UIColor.systemPurple.cgColor
        ]
        view.layer.addSublayer(gradientLayer)
        */
        
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
    
    // done button func to close the email keyboard
    @IBAction func doneMail(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    // done button func to close the password keyboard
    @IBAction func donePassword(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}
