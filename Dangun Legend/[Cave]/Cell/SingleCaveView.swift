//
//  SingleCaveView.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/19.
//

import Foundation
import UIKit
import Gifu


class SingleCaveView: UIScrollView {
    
    private var contentView: UIView!
    
    var caveImageView: UIImageView!
    
    private var gifImageView: GIFImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setContentView()
        
        
    }
    
    func setGoalInfo(_ goal: GoalModel) {
        
    }
    
    //MARK: - Setup UI
    
    private func setContentView() {
        let view = UIView()
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalTo(1800)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        let backGroundView = UIImageView()
        backGroundView.alpha = 0
        backGroundView.image = UIImage(named: "Cave_Backgound")
        view.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(300)
        }
        self.caveImageView = backGroundView
        
        let light = UIImageView()
        light.image = UIImage(named: "Cave_Lights")
        view.addSubview(light)
        light.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(300)
        }
        
        self.contentView = view
//        self.setGigImageView()
    }
    
    private func setGigImageView() {
        let gifImageView = GIFImageView()
        gifImageView.animate(withGIFNamed: "Cave_Lights")
        gifImageView.contentMode = .scaleToFill
        
        self.contentView.addSubview(gifImageView)
        gifImageView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(CS.screenWidth*1217/1625)
        }
//k
        self.gifImageView = gifImageView
    }

    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
