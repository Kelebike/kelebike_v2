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

        // Do any additional setup after loading the view.
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
