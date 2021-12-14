//
//  CaveStepCell.swift.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/14.
//

import Foundation
import UIKit

class StepCell: UICollectionViewCell {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setLabel()
    }
    
    private func setLabel() {
        let label = UILabel()
        label.font = UIFont.fontSFProDisplay(size: 20, family: .Heavy)
        label.textColor = .black
        self.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.label = label
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
