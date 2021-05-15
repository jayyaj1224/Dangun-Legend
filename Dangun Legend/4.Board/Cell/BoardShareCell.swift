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
    
    private let boardVC = BoardViewController()
    
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
   
    func deleteButtonControl(id: String){
        let userID = defaults.string(forKey: keyForDf.crrUser)
        if id == userID {
            deleteOutlet.isHidden = false
        } else {
            deleteOutlet.isHidden = true
        }
    }
    
    func badgeControl(numOfSuccess: Int){
        switch numOfSuccess {
        case 100:
            self.terrificOutlet.isHidden = true
            self.superOutlet.isHidden = false

        case 97...99:
            self.terrificOutlet.isHidden = false
            self.superOutlet.isHidden = true

        default:
            self.terrificOutlet.isHidden = true
            self.superOutlet.isHidden = true
        }
    }

    
}
