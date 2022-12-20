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

    var bikeCount: Int?
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bikeCount = 0
        isBikeRented = false
        userStatus = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
    }

    @IBAction func refreshTapped(_ sender: Any) {
        loadData()
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
            timerHeader.text = "Go rent a bike and enjoy the school"
            timerLabel.text = ""
            
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
            
            qrButton.setTitle(" Return bike", for: .normal)
        }
        
        // update avaliable bike count
        availableBikes.text = String(self.bikeCount ?? 000)
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

}
