//
//  CaveMainTableView.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class CaveMainTableView: UITableView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        let members = subviews.reversed()
        for member in members {
            let subPoint = member.convert(point, to: self)
            guard let result = member.hitTest(subPoint, with: event) else {
                continue
            }
            return result
        }
        return nil
    }
}
