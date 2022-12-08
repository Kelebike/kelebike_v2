//
//  HistoryTableViewCell.swift
//  kelebike
//
//  Created by Mert on 7.12.2022.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    // variables used in a cell (view is holding other 3 labels)
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var duration: UILabel!

}
