//
//  BoardShareCell.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/16.
//

import UIKit

class BoardShareCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var goalID = ""
    let goalManager = GoalManager()
    
    
    
    @IBOutlet weak var caveupperBoxImage: UIImageView!
    @IBOutlet weak var terrificOutlet: UIView!
    @IBOutlet weak var superOutlet: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var goalLabel: UILabel!
    @IBOutlet var achieveLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var deleteOutlet: UIButton!
    @IBAction func deletePressed(_ sender: UIButton) {
        NotificationCenter.default.post(Notification(name: boardDeleteNoti, object: goalID, userInfo: nil))
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
