//
//  CaveScrollDetailView.swift
//  Dangun Legend
//
//  Created by Lee Jong Yun on 2021/12/14.
//

import Foundation
import UIKit

class CaveScrollDetailView: UIView {
    var collectionView: UICollectionView!
    var characterView: UIView!
    var caveExitView: UIView!
    
    var index: Int?
    
    var asdfjkl = Array(0...100)///toDelete
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 1300, height: 200))
        self.setupCollectionView()
        
        self.setupCharacterView()
        self.setupCaveExitView()
    }
    
    func setCaveScrollViewDetail(with goalData: GoalModel) {
        
    }
    
    func refreshScroll() {
        self.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
    }
    
    private func setupCollectionView() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 0, width: 1300, height: 200), collectionViewLayout: layout)
        collectionView.register(StepCell.self, forCellWithReuseIdentifier: "StepCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        self.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.size.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.collectionView = collectionView
    }
    
    private func setupCharacterView() {
        let view = UIView()
        view.backgroundColor = .brown
        view.alpha = 0.3
        view.layer.cornerRadius = 50
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(100)
        }
        self.caveExitView = view
    }
    
    private func setupCaveExitView() {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.3
        view.layer.cornerRadius = 50
        self.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(100)
        }
        self.caveExitView = view
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension CaveScrollDetailView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.asdfjkl.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StepCell", for: indexPath) as? StepCell else {
            return UICollectionViewCell()
        }
        cell.label.text = "\(indexPath.row)"
        return cell
    }
}

extension CaveScrollDetailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 200)
    }
}
