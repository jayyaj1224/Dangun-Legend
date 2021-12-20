//
//  SingleCaveView.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/12/19.
//

import Foundation
import UIKit
import Gifu

class SingleCaveView: UIScrollView, UIScrollViewDelegate {
    
    private var contentView: UIView!
    
    private var caveImageView: UIImageView!
    
    private var caveTitleLabel: UILabel!
    
    private var deleteView: GradientView!
    
    var caveDelegate: CaveViewDelegate!
    
    var selfHeight: CGFloat = CS.screenWidth-40
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureSelf()
        self.setUI()
    }
    
    private func configureSelf() {
        self.showsHorizontalScrollIndicator = false
        self.delegate = self
    }
    
    func setGoalInfo(_ goal: GoalModel) {
        self.caveTitleLabel.text = goal.goalDescription
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let xOffset = scrollView.contentOffset.x
        
        self.caveImageViewAlphaControl(x: xOffset)
        
        self.deleteViewAlphaControl(x: xOffset)
    }
    
    private func caveImageViewAlphaControl(x xOffset: CGFloat) {
        switch xOffset {
        case ...10:
            self.caveImageView.alpha = 0
        case 10...800:
            self.caveImageView.alpha = xOffset*0.001
        default:
            self.caveImageView.alpha = 0.8
        }
    }
    
    private func deleteViewAlphaControl(x xOffset: CGFloat) {
        if xOffset-70 < 0 {
            self.deleteView.alpha = (-xOffset)*0.01
        }
        if xOffset < -110 {
            self.showDeleteAlert()
        }
    }
    
    private func showDeleteAlert() {
        guard let caveVc = self.viewContainingController() as? CaveViewController else { return }
        let alerView = UIAlertController(title: "목표를 삭제합니다.", message: "", preferredStyle: .alert)
        alerView.addAction( UIAlertAction(title: "취소", style: .default) { _ in } )
        
        alerView.addAction( UIAlertAction(title: "삭제", style: .destructive) { _ in
            caveVc.deleteGoalAt(self.tag)
        })
        
        caveVc.present(alerView, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


//MARK: - Setup UI
extension SingleCaveView {
    private func setUI() {
        self.setContentView()
        self.setBackGroundImageView()
        self.setLightImageView()
        
        self.setSquareView()
        self.setDeleteLabel()
    }
    
    private func setContentView() {
        let view = UIView()
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.width.equalTo(2200)
            make.leading.trailing.equalToSuperview()
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.contentView = view
    }
    
    private func setBackGroundImageView() {
        let backGroundView = UIImageView()
        backGroundView.alpha = 0
        backGroundView.image = UIImage(named: "Cave_Backgound")
        self.contentView.addSubview(backGroundView)
        backGroundView.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(500)
        }
        self.caveImageView = backGroundView
    }
    
    private func setLightImageView() {
        let light = UIImageView()
        light.image = UIImage(named: "Cave_Lights")
        self.contentView.addSubview(light)
        light.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(300)
        }
    }
    
    private func setSquareView() {
        let square = UIView()
        square.layer.borderColor = .black
        square.layer.borderWidth = 3
        self.contentView.addSubview(square)
        square.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(square.snp.height)
        }

        let label = UILabel()
        label.font = .fontSFProDisplay(size: 20, family: .Heavy)
        label.numberOfLines = 10
        label.minimumScaleFactor = 0.5
        label.textAlignment = .center
        square.addSubview(label)
        label.snp.makeConstraints { make in
            make.width.lessThanOrEqualToSuperview()
            make.center.equalToSuperview()
        }
        self.caveTitleLabel = label
    }
    
    private func setDeleteLabel() {
        let deleteView = GradientView.init(
            colours: [.systemRed.withAlphaComponent(0.5), .systemRed.withAlphaComponent(0.0)],
            frame: CGRect(x: 0, y: 0, width: 200, height: self.selfHeight),
            gradientLocation: [0,0.5],
            start: CGPoint(x: 1.0, y:0.5), end: CGPoint(x: 0.5, y: 1.0)
        )
        deleteView.gradientLayer.type = .radial
        self.contentView.addSubview(deleteView)
        
        deleteView.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.trailing.equalTo(self.contentView.snp.leading)
        }
        
        let deleteLabel = UILabel()
        deleteLabel.numberOfLines = 1
        deleteLabel.text = "delete"
        deleteLabel.textColor = .systemRed
        deleteLabel.font = .fontSFProDisplay(size: 18, family: .Bold)
        
        deleteView.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
        self.deleteView = deleteView
        self.deleteView.alpha = 0
    }
}



//private var gifImageView: GIFImageView!

//    private func setGigImageView() {
//        let gifImageView = GIFImageView()
//        gifImageView.animate(withGIFNamed: "Cave_Lights")
//        gifImageView.contentMode = .scaleToFill
//
//        self.contentView.addSubview(gifImageView)
//        gifImageView.snp.makeConstraints { make in
//            make.top.bottom.trailing.equalToSuperview()
//            make.width.equalTo(CS.screenWidth*1217/1625)
//        }
//        self.gifImageView = gifImageView
//    }
