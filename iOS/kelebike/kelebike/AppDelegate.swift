//
//  AppDelegate.swift
//  kelebike
//
//  Created by Berkay Baygut on 29.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var historyArray: [History] = []
    var isHistoryEmpty: Bool?
    
    var bikeCount: String = "Loading..."
    var rentedBike: Bike?
    var isBikeRented: Bool?
    var userStatus: Int = 0

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        self.isHistoryEmpty = false
        self.isBikeRented = false
        
        if (Auth.auth().currentUser != nil) {
            retrieveDataHistory()
            retrieveDataHome()
        }

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func retrieveDataBikeCount() {
        let db = Firestore.firestore()
        let ref = db.collection("Bike").whereField("status", isEqualTo: "nontaken")
        
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var bikeCount = 0
                for _ in querySnapshot!.documents {
                    bikeCount += 1
                }
                self.bikeCount = String(bikeCount)
            }
        }
    }
    
    func retrieveDataHome () {
        let db = Firestore.firestore()
        let ref = db.collection("Bike").whereField("owner", isEqualTo: (Auth.auth().currentUser?.email)!)
        
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var bikeCount = 0
                for document in querySnapshot!.documents {
                    bikeCount += 1
                    
                    // format issued date and return dates
                    let cutIssuedDate = (document.data()["issued"] as! String).components(separatedBy: " ").first?.replacingOccurrences(of: "-", with: ".")
                    let cutReturnDate = (document.data()["return"] as! String).components(separatedBy: " ").first?.replacingOccurrences(of: "-", with: ".")
                    
                    // reverse the dates
                    let finalIssuedDate = cutIssuedDate!.components(separatedBy: ".").map { $0 }.reduce("") { result, element in
                        return element + "." + result
                    }
                    let finalReturnDate = cutReturnDate!.components(separatedBy: ".").map { $0 }.reduce("") { result, element in
                        return element + "." + result
                    }
                    
                    self.rentedBike = Bike(code: document.data()["code"] as! String,
                                           lock: document.data()["lock"] as! String,
                                           brand: document.data()["brand"] as! String,
                                           issuedDate: String(finalIssuedDate.prefix(finalIssuedDate.count - 1)),
                                           returnDate: String(finalReturnDate.prefix(finalReturnDate.count - 1)),
                                           owner: document.data()["owner"] as! String,
                                           status: document.data()["status"] as! String)
                    
                    self.isBikeRented = true
                }
                
                if (bikeCount == 0){
                    self.isBikeRented = false
                    self.userStatus = 0
                }
                else {
                    if(self.rentedBike?.status == "waiting" || self.rentedBike?.status == "returned"){
                        self.userStatus = 1
                    }
                    else if(self.rentedBike?.status ==  "taken"){
                        self.userStatus = 2
                    }
                }
            }
        }
    }
    
    func retrieveDataHistory() {
        let db = Firestore.firestore()
        let ref = db.collection("History").whereField("bike.owner", isEqualTo: (Auth.auth().currentUser?.email)!)
        
        ref.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                var historyCount = 0
                self.historyArray.removeAll()
                
                for document in querySnapshot!.documents {
                    historyCount += 1
                    let dataBike = document.data()["bike"] as! [String: Any]
                    
                    // remove unnecesarry parts from the date
                    let cutIssuedDate = (dataBike["issued"] as! String).components(separatedBy: " ").first?.replacingOccurrences(of: "-", with: ".")
                    let cutReturnDate = (dataBike["return"] as! String).components(separatedBy: " ").first?.replacingOccurrences(of: "-", with: ".")

                    
                    // reverse the date format
                    let finalIssuedDate = cutIssuedDate!.components(separatedBy: ".").map { $0 }.reduce("") { result, element in
                        return element + "." + result
                    }
                    let finalReturnDate = cutReturnDate!.components(separatedBy: ".").map { $0 }.reduce("") { result, element in
                        return element + "." + result
                    }
        
                    // save bike info
                    let code = dataBike["code"] as! String
                    let lock = dataBike["lock"] as! String
                    let brand = dataBike["brand"] as! String
                    let issuedDate = finalIssuedDate.prefix(finalIssuedDate.count - 1)
                    let returnDate = finalReturnDate.prefix(finalReturnDate.count - 1)
                    let owner = dataBike["owner"] as! String
                    let status = dataBike["status"] as! String
                    
                    let formatedCreatedDate = DateFormatter.localizedString(from: ((document.data()["createdAt"] as? Timestamp)?.dateValue())!, dateStyle: .short, timeStyle: .short)
                    
                    // create structs to hold data
                    let bike = Bike(code: code, lock: lock, brand: brand, issuedDate: String(issuedDate), returnDate: String(returnDate), owner: owner, status: status)
                    let history = History(bike: bike, createdAt: formatedCreatedDate)
                    
                    var unique_flag = true
                    for h in self.historyArray {
                        if (h.createdAt == history.createdAt){
                            unique_flag = false
                        }
                    }
                    
                    if unique_flag {
                        self.historyArray.append(history)
                        self.isHistoryEmpty = false
                    }
                }
                if (historyCount == 0) {
                    self.isHistoryEmpty = true
                }
            }
        }
    }
}
