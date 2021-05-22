//
//  HistoryTableViewCell.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//

import UIKit
import RxSwift
import RxCocoa

class HistoryTableViewCell: UITableViewCell {

    var goalID : String?
    var index = 0
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalResultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBOutlet weak var shareOutlet: UIButton!
    
    @IBAction func sharePressed(_ sender: Any) {
        
        if goalID == nil {
            print("####  goal id is empty")
        } else {
            NotificationCenter.default.post(name: shareSuccessNoti, object: goalID, userInfo: ["index":index])
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
