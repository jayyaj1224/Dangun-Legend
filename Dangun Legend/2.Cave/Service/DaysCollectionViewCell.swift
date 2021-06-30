//
//  DaysCollectionViewCell.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/05/20.
//

import Foundation
import UIKit

class SquareCell : UICollectionViewCell {

    var singleDayInfo : DayModel?
    let dateManager = DateCalculate()
    
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var squareImage: UIImageView!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let singleInfo = singleDayInfo {
            NotificationCenter.default.post(name: checkTheDateNoti, object: singleInfo, userInfo: nil)
        }
    }
}
    
