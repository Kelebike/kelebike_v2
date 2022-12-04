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

    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var availableBikes: UILabel!
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var homeText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func putDataTapped(_ sender: Any) {
        Task { @MainActor in
            
            let bike = Bike(code: 1265, lock: 0000, brand: "nontaken" ,issuedDate: "nontaken", returnDate: "nontaken", owner: "nontaken", status: "nontaken")
            
            await addBike(bike: bike)
            
            
        }
    }
    
    
    
    @IBAction func availableBikeTapped(_ sender: Any) {
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
