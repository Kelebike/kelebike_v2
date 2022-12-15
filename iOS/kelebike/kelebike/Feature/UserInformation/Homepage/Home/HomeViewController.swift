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
            
            let bike = Bike(code: 1265, lock: 0000, brand: "nontaken" ,issuedDate: "nontaken", returnDate: "nontaken", owner: "nontaken", status: "nontaken")
            
            await addBike(bike: bike)
            
            
        }
    }
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
            
        
        
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
        // Add a new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("Bike").addDocument(data: ["code": bike.code, "lock" : bike.lock, "brand" : bike.brand, "issuedDate" : bike.issuedDate, "returnDate" : bike.returnDate, "owner" : bike.owner, "status" : bike.status ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    
    func getDataFrom(collection : String, field : String) -> String {
        
        //read documents from spesific path
        db.collection(collection).getDocuments { snapshot , error in
            //no error
            if error == nil {
                if let snapshot = snapshot {
                    //get all the documents
                }
            }
            //handle the erro
            else {
                
            }
        }
        
    }

}
