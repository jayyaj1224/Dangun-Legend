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
    
    //var caveGoalAddVC = CaveAddViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-->>>caveViewDidLoad")
        //caveGoalAddVC.delegate = self
        caveViewSwitch(defaults.bool(forKey: "goalExisitence"))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(type(of: self),#function)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print(type(of: self),#function)
    }
    
    @IBOutlet var caveView: UIView!
    @IBOutlet weak var startYour100DaysView: UIView!
    @IBOutlet weak var goalManageScrollView: UIScrollView!
    
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    
    
    func caveViewSwitch(_ bool: Bool) {
        if bool {
            startYour100DaysView.isHidden = true
            goalManageScrollView.isHidden = false
        } else {
            startYour100DaysView.isHidden = false
            goalManageScrollView.isHidden = true
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
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if squareImage.image == #imageLiteral(resourceName: "EmptySquare") {
                    squareImage.image = #imageLiteral(resourceName: "SuccessSquare")
                } else {
                    squareImage.image = #imageLiteral(resourceName: "EmptySquare")
                }
            }
        }
    }
    
}



extension CaveViewController: GoalUIManagerDelegate {
    
    func updateView(_ caveAddVC: CaveAddViewController,_ data: String) {
        //caveViewSwitch(defaults.bool(forKey: "goalExisitence"))
        print("delegated: -->> \(data)")
    }
    
    
    func didFailwithError(error: Error) {
        print("")
    }


}
