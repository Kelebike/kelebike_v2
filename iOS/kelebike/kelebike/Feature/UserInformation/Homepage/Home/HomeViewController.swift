//
//  HomeViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 30.11.2022.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase



class HomeViewController: UIViewController {

    
    let db = Firestore.firestore()
    var bikeCount: String?
    var rentedBike: Bike?
    var isBikeRented: Bool?
    
    // saves what the user status is. 0 for not rented. 1 is for waiting apporeval. 2 is rented
    var userStatus: Int?
    
    @IBOutlet weak var availableBikes: UILabel!
    
    @IBOutlet weak var qrButton: UIButton!
    
    @IBOutlet weak var codeHeader: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    
    @IBOutlet weak var lockHeader: UILabel!
    @IBOutlet weak var lockLabel: UILabel!
    
    @IBOutlet weak var timerHeader: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isBikeRented = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }

    @IBAction func refreshTapped(_ sender: Any) {
        loadData()
    }
    
    
    
    @IBAction func takeReturnBikeTapped(_ sender: Any) {
        Task { @MainActor in
            if(await isItBlacklisted(Auth.auth().currentUser!.email!)) {
                let reason = await blacklistReason(Auth.auth().currentUser!.email!)
                customAlert(title: "You are in the Blacklist", message: reason)
            }
            else if (await isThereWaitingRequest(Auth.auth().currentUser!.email!)){
                customAlert(title: "Error", message: "You already have a request please try again later.")
            }
            else if(userStatus == 0) {
                self.performSegue(withIdentifier: "toQRScanner", sender: nil)
            }
            else if (userStatus == 2) {
                Task { @MainActor in
                    let id = await getDocument(code: rentedBike!.code)
                    returnAlert(title: "Return", message: "Do you want to return bike?", id : id)
                    loadData()
                }
            }
        }
    }
    
    
    //checks blacklisted user
    func isItBlacklisted(_ email: String) async -> Bool {
        let collectionRef = db.collection("Blacklist/")
        var smth = false
        do {
            smth = try await collectionRef.whereField("user", isEqualTo: email).getDocuments().isEmpty
        } catch {
            print("Error about documents")
        }
        
        return !smth;
    }
    
    func isThereWaitingRequest(_ email: String) async -> Bool {
        let collectionRef = db.collection("Bike/")
        var smth = false
        do {
            smth = try await collectionRef.whereField("owner", isEqualTo: email).whereField("status", isEqualTo: "waiting").getDocuments().isEmpty
        } catch {
            print("Error about documents")
        }
        
        return !smth;
    }
    
    //checks blacklisted user
    func blacklistReason(_ email: String) async -> String {
        var docID = "NOT_FOUND"
        var reason = "NOT"
        let collectionRef = db.collection("Blacklist/")
        do {
            docID = try await collectionRef.whereField("user", isEqualTo: email).getDocuments().documents.first?.documentID ?? "NOT_FOUND"
        } catch {
            print("Error about documents")
        }
        
        do {
            print(docID)
            reason = try await db.collection("Blaklist/").document(docID).getDocument().get("reason") as? String ?? "default"
        } catch {
            print("error")
        }
        
        
        return reason;
    }
    
    
    
    func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.retrieveDataHome()
        self.rentedBike = appDelegate.rentedBike
        self.isBikeRented = appDelegate.isBikeRented
        self.userStatus = appDelegate.userStatus
        
        appDelegate.retrieveDataBikeCount()
        self.bikeCount = appDelegate.bikeCount

        // update home page acording to loaded data
        if(userStatus == 0){
            codeHeader.text = " "
            codeLabel.text = ""
            lockHeader.text = ""
            lockLabel.text = ""
            timerHeader.text = ""
            timerLabel.text = ""
            infoLabel.text = "Go rent a bike and enjoy the school"
            
            qrButton.setTitle(" Take a bike", for: .normal)
        }
        // user waiting for apporeval
        else if(userStatus == 1){
            codeHeader.text = "Code:"
            codeLabel.text = rentedBike?.code
            lockHeader.text = "Status:"
            lockLabel.text = "Waiting"
            timerHeader.text = "Initiation date:"
            timerLabel.text = rentedBike?.issuedDate
            infoLabel.text = ""
            
            qrButton.setTitle(" Return bike", for: .normal)
        }
        // user has a rented bike
        else if(userStatus == 2){
            codeHeader.text = "Code:"
            codeLabel.text = rentedBike?.code
            lockHeader.text = "Lock:"
            lockLabel.text = rentedBike?.lock
            timerHeader.text = "Remaining Time:"
            timerLabel.text = calculateRemainingTime()
            infoLabel.text = ""
            
            qrButton.setTitle(" Return bike", for: .normal)
        }
        
        // update avaliable bike count
        availableBikes.text = self.bikeCount!
    }
    
    func calculateRemainingTime() -> String {
        // get current day, month and year
        let currentDate = Date()
        let calendar = Calendar.current
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay = calendar.component(.day, from: currentDate)
        
        // save return date
        let returnMonth = Int(self.rentedBike!.returnDate.components(separatedBy: ".")[1])
        let returnDay = Int(self.rentedBike!.returnDate.components(separatedBy: ".").first!)
        
        if(returnMonth == currentMonth && returnDay == currentDay){
            return "Return today"
        }
        else if (returnMonth == currentMonth && returnDay! - currentDay == 1) {
            return "Return tommorow"
        }
        else if (returnMonth == currentMonth) {
            return "\(returnDay! - currentDay) days"
        }
        else {
            let days = numberOfDaysInMonth(for: currentMonth, in: Int(self.rentedBike!.returnDate.components(separatedBy: ".")[2])!)
            
            return "\(days - currentDay + returnDay!) days"
        }
    }
    
    func numberOfDaysInMonth(for month: Int, in year: Int) -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    //create custom alert
    func customAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            print("ok button tapped")
            
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
    
    
    // Create new Alert
    func returnAlert(title: String, message: String, id : String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        

            let yes = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                print("yes button tapped")
                self.db.collection("Bike").document(id).updateData(["status" : "returned", "owner" : Auth.auth().currentUser?.email])
        })
            
        
        // Create OK button with action handler
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) -> Void in
            print("no button tapped")
            
         })
        
        //Add OK button to a dialog message
        dialogMessage.addAction(yes)
        dialogMessage.addAction(no)

        // Present Alert to
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    private func getDocument(code : String) async -> String {
        var docID : String = "NOT_FOUND"
        
        do {
            docID = try await self.db.collection("Bike").whereField("code", isEqualTo: code)
                    .getDocuments().documents.first?.documentID ?? "NOT_FOUND"
        } catch {
                print("Error find the document")
        }
        return docID
    }
    
    

}
