//
//  HistoryTableViewCell.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/07.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    var goalID = ""
    let goalManager = GoalManager()
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalResultLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var shareOutlet: UIButton!
    @IBAction func sharePressed(_ sender: Any) {
        if goalID == "" {
            print("####  goal id is empty")
        } else {
            NotificationCenter.default.post(name: shareSuccessNoti, object: goalID, userInfo: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
