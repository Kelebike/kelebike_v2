//
//  HistoryViewController.swift
//  kelebike
//
//  Created by Mert on 4.12.2022.
//

import UIKit


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var loadingText: UILabel!
    
    var historyArray: [History] = []
    var isHistoryEmpty: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isHistoryEmpty = false           
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.retrieveDataFromFirebase()
        self.historyArray = appDelegate.historyArray
        self.isHistoryEmpty = appDelegate.isHistoryEmpty
        
        if (self.isHistoryEmpty!) {
            loadingText.text = "There is no history"
            loadingText.isHidden = false
        }
        else if(self.historyArray.count != 0){
            loadingText.isHidden = true
        }
        
        historyTableView.reloadData()
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.retrieveDataFromFirebase()
        self.historyArray = appDelegate.historyArray
        self.isHistoryEmpty = appDelegate.isHistoryEmpty
        
        if (self.isHistoryEmpty!) {
            loadingText.text = "There is no history"
            loadingText.isHidden = false
        }
        else if(self.historyArray.count != 0){
            loadingText.isHidden = true
        }
        
        historyTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // how many rows are on the table
        return self.historyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // how to fill a new cell in the screen
        let cell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryTableViewCell
        
        // fill top row
        cell.id.text = "Bike ID: \(self.historyArray[indexPath.row].bike.code)"
        cell.date.text = self.historyArray[indexPath.row].bike.issuedDate
            
        // fill bottom roq
        let issuedMonth = Int(self.historyArray[indexPath.row].bike.issuedDate.components(separatedBy: ".")[1])
        let issuedDay = Int(self.historyArray[indexPath.row].bike.issuedDate.components(separatedBy: ".").first!)
        let returnMonth = Int(self.historyArray[indexPath.row].bike.returnDate.components(separatedBy: ".")[1])
        let returnDay = Int(self.historyArray[indexPath.row].bike.returnDate.components(separatedBy: ".").first!)
        
        if(returnMonth == issuedMonth && returnDay == issuedDay){
            cell.duration.text = "Bike rented and returned same day"
        }
        else if (returnMonth == issuedMonth && returnDay! - issuedDay! == 1) {
            cell.duration.text = "Bike rented for \(returnDay! - issuedDay!) day"
        }
        else if (returnMonth == issuedMonth) {
            cell.duration.text = "Bike rented for \(returnDay! - issuedDay!) days"
        }
        else {
            let days = numberOfDaysInMonth(for: issuedMonth!, in: Int(self.historyArray[indexPath.row].bike.returnDate.components(separatedBy: ".")[2])!)
            
            cell.duration.text = "Bike rented for \(days - issuedDay! + returnDay!) days"
        }
        
        // set cell curve
        cell.historyView.layer.cornerRadius = cell.historyView.frame.height / 4
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // row press action
        print("History pressed at index " + String(indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // row height
        return 110
    }
    
    func numberOfDaysInMonth(for month: Int, in year: Int) -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
}
