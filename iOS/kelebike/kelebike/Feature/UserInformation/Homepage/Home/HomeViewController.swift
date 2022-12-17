//
//  HomeViewController.swift
//  kelebike
//
//  Created by Berkay Baygut on 30.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase


var i : Int = 0

class HomeViewController: UIViewController {

    var seconds = 50 // it should be remaining time
    
    
    @IBOutlet weak var availableBikes: UILabel!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var homeText: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var lockLabel: UILabel!
    
    
    @IBOutlet weak var timerLabel: UILabel!
    var timer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeViewController.counter), userInfo: nil, repeats: true)
        
    }
    
    @objc func counter() {
        seconds -= 1
        timerLabel.text = String(seconds)
        if(seconds <= 0){
            timer.invalidate()
        }
    }
    
    
    @IBAction func putDataTapped(_ sender: Any) {
        Task { @MainActor in
            
            let bike = Bike(code: "1265", lock: "0000", brand: "nontaken" ,issuedDate: "nontaken", returnDate: "nontaken", owner: "nontaken", status: "nontaken")
            
            await addBike(bike: bike)
            
            
        }
    }
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        let docRef = db.collection("Bike").whereField("status", isEqualTo: "nontaken")
        docRef.getDocuments() { snapshot, error in
            if let error = error {
                print("Error getting collection size: \(error)")
                return
            }
            DispatchQueue.main.async {
                let count = snapshot?.documents.count
                self.availableBikes.text = String(count ?? 0)
            }
        }
        
        let userRef = db.collection("Bike").whereField("owner", isEqualTo: Auth.auth().currentUser?.email ?? "nil" )
        userRef.getDocuments() { snapshot, error in
            if let error = error {
                print("Error getting collection size: \(error)")
                return
            }
            DispatchQueue.main.async {
                let bike = snapshot?.documents
                let code = bike?.first?.get("code").map(String.init(describing:)) ?? "nil"
                var lock = bike?.first?.get("lock").map(String.init(describing:)) ?? "nil"
                
                
                //self.detailLabel.text = code
                
            }
            
            
        }
        
    }
    
    
    //checks the code if it is exist
    fileprivate func isItUnique(_ bike: Bike) async -> Bool {
        let collectionRef = db.collection("Bike")
        var smth = false
        do {
            smth = try await collectionRef.whereField("code", isEqualTo: bike.code).getDocuments().isEmpty
        } catch {
            print("Error about documents")
        }
        
        return smth;
    }
    
    func addBike(bike : Bike) async{
        let docRef = db.document("Bike/" + String(bike.code))
        if(await isItUnique(bike)){
            do{
                try await docRef.setData(["code": bike.code, "lock" : bike.lock, "brand" : bike.brand, "issuedDate" : bike.issuedDate, "returnDate" : bike.returnDate, "owner" : bike.owner, "status" : bike.status ])
            } catch {
                print ("Error about saving document to database...")
            }
        }
    }

}
