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
    
    let db = Firestore.firestore()
    
    
    var passwordVisible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.attributedPlaceholder = NSAttributedString(
            string: "Email",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        password.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        passwordCheck.attributedPlaceholder = NSAttributedString(
            string: "Password again",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        
        
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if(email.text?.isEmpty == true ){
            print("email empty")
            createAlert(title: "ERROR", message: "Email is empty!", goBack: false)
            return
        }
        else if(password.text?.isEmpty == true){
            print("password empty")
            createAlert(title: "ERROR", message: "Password is empty!", goBack: false)
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
    
    
    @IBAction func showPolicy(_ sender: Any) {
        let policy : String = "I received the bike which was given by the Department of Health and Sports Bicycle Unit and registered its brand model and serial number completely and intact.\nBicycle Delivery Terms\n1- The temporary allocation period for bicycle use is 5 (five working days. In case the usage period is extended the registration renewal process will be done again. The person who does not do this will not be given a bike again. Bicycles will be delivered to the Bicycle Unit of the Department of Health Culture and Sports.\n2- The student/staff can only buy the bike in their own name. It is forbidden to buy a bicycle and make transactions on behalf of another person. Can only take one bike for own use.\n3- The student/staff will deliver the received bike complete with all its accessories in good condition and in working condition on the date of delivery.\n4- Student/staff cannot lend rent or sell the bicycle they have received to a third party.\n5- The student/staff is responsible for the safety of the bicycle they receive. He is obliged to compensate for the value of the lost bike or to replace it with a new one of equal value.\n6- Students/staff will use it in accordance with the Bicycle Usage Rules directive and Safe Cycling Guidelines in Cities..\n7- In cases where it is determined to be caused by user error all expenses related to accidents and all kinds of material and moral damages all kinds of malfunctions and repair expenses that may occur in bicycles due to use that are not in accordance with the driving rules and safety explanations and the rules in the Safe Cycling User's Guide in Cities are collected from the user. will be. Action is taken in accordance with the relevant legislation and directive."
        
        self.createAlert(title: "Bike Renting Policy", message: policy, goBack: false)
    }
    
    
    func addUser(email : String) async{
        let docRef = db.document("Person/" + email)
        if(await isItUnique(email)){
            do{
                try await docRef.setData(["email" : email, "label" : "user"])
            } catch {
                print ("Error about saving document to database...")
            }
        }
        
        //checks the user if it is exist
        func isItUnique(_ email: String) async -> Bool {
            let collectionRef = db.collection("Person/")
            var smth = false
            do {
                smth = try await collectionRef.whereField("email", isEqualTo: email).getDocuments().isEmpty
            } catch {
                print("Error about documents")
            }
            
            return smth;
        }
    }
}
