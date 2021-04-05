//
//  CaveViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/03.
//
/*
 
 Cave View에서
 
 진행중인 Project가 있는지?     Yes -> 진행중인 프로젝트 화면
                            No -> 시작하기Button        -> AddVC
 
 */


import UIKit
import Firebase

class CaveViewController: UIViewController {
    
    var caveGoalAddVC = CaveAddViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        caveGoalAddVC.delegate = self
        noGoalView.alpha = 0
        GoalView.alpha = 1
    }
    
    @IBOutlet weak var noGoalView: UIView!
    @IBOutlet weak var GoalView: UIView!
    
    
    func goalExists(_ yn: Bool) {
        if yn {
            noGoalView.alpha = 0
            GoalView.alpha = 1
        } else {
            noGoalView.alpha = 1
            GoalView.alpha = 0
        }
    }
    
}

extension CaveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Square", for: indexPath) as? SquareCell
        else {
            return UICollectionViewCell()
        }
        cell.updateUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    } // 클릭되었을때 세그웨이를 실행합니다.


//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let sideLength : CGFloat = collectionView.bounds.width / 20
//
//        return CGSize(width: sideLength, height: sideLength)
//    }
    
    
}

class SquareCell : UICollectionViewCell {

    @IBOutlet weak var squareImage: UIImageView!
    
    func updateUI(){
        squareImage.image = #imageLiteral(resourceName: "EmptySquare")
    }
    
    select
    
}

extension CaveViewController: goalUIManagerDelegate{
    
    func updateView(_ newgoal: NewGoal) {
        goalExists(true)
    }
    
    func errorOccurred() {
        print("")
    }
    
}
