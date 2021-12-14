//
//  Int+Extension.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

extension Int {
    var pi: Float { return Float(Double(self) * .pi/180) }
}

extension Float {
    var cgFloat: CGFloat { return CGFloat(self) }
}
