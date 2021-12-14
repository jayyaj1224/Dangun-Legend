//
//  UIFont+Extension.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import UIKit

extension UIFont {
    
    enum Family: String {
        case Thin, Light, Regular, Medium, Semibold, Bold, Heavy
    }
    
    
    static func fontSFProDisplay(size: CGFloat, family: Family = .Regular) -> UIFont {
        if let font = UIFont(name: "SFProDisplay-\(family)", size: size) {
            return font
        }
        if family == .Bold {
            return .boldSystemFont(ofSize: size)
        }
        else {
            return .systemFont(ofSize: size)
        }
    }
    
}
