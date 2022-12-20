//
//  LoginViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 29.10.2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var gifView: UIImageView!
    
    @IBOutlet weak var showHideIcon: UIButton!    
    
    var passwordVisible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        email.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }

    @IBAction func forgotPasswordTapped(_ sender: Any) {
        print("forgot password tappped")
        Auth.auth().sendPasswordReset(withEmail: email.text!)
        createAlert(title: "Reset Password", message: "Reset email has been sent. Please check your inbox.", goBack: false)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
            activityIndicator.startAnimating()
        
            //waits until firebase signed up 
            Task { @MainActor in
                
                do {
                    try await Auth.auth().signIn(withEmail: email.text!, password: password.text!)
                }catch{
                    print("error")
                }
                
                if Auth.auth().currentUser == nil
                {
                    createAlert(title: "ERROR", message: "User not found or wrong password!\nPlease sign up and try again.", goBack: false)
                }
                else {
                    performSegue(withIdentifier: "toHomepage", sender: nil)
                    
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.retrieveDataHistory()
                }
                
            }
            activityIndicator.stopAnimating()
        
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
    
}
