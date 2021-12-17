//
//  UISegment- +extension.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/17.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func segmentAt(_ index: Int) -> UIView {
        if #available(iOS 13.0, *) {
            return self.subviews[index]
        } else {
            let subviews = self.subviews.sorted { $0.frame.minX < $1.frame.minX }
            return subviews[index]
        }
    }
}
