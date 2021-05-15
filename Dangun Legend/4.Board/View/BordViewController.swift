//
//  BordViewController.swift
//  Dangun Legend
//
//  Created by JAY LEE on 2021/04/16.
//

import UIKit
import Firebase
import RxSwift
import RxCocoa

let boardDeleteNoti : Notification.Name = Notification.Name("boardDeleteNoti")

class BoardViewController: UIViewController {

    @IBOutlet weak var boardTableView: UITableView!
    
    private var boardViewModel : BoardListViewModel!
    private let boardService = BoardService()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        boardTableView.register(UINib(nibName: "BoardShareCell", bundle: nil), forCellReuseIdentifier: "boardShareCell")
        NotificationCenter.default.addObserver(self, selector: #selector(deleteBoard(_:)), name: boardDeleteNoti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadBoard()
    }

    
    private func loadBoard(){
        self.boardService.sortedBoardList { goalStructList in
            return Observable.just(goalStructList)
                .subscribe(onNext: { goalStructList in
                    let achievementList = BoardListViewModel.init(goalStructList)
                    self.boardViewModel = achievementList
                    DispatchQueue.main.async {
                        self.boardTableView.reloadData()
                    }
                }).disposed(by: self.disposeBag)
        }
    }
    
    @objc func deleteBoard(_ noti: Notification){
        let goalID = noti.object as! String
        let alert = UIAlertController.init(title: "Delete", message: "업적을 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { (UIAlertAction) in
            self.boardService.deleteFromBoard(goalID: goalID)
            self.loadBoard()
        }))
        present(alert, animated: true, completion: nil)
    }
}


extension BoardViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boardViewModel == nil ? 0 : self.boardViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "boardShareCell", for: indexPath) as? BoardShareCell else {
            return UITableViewCell()
        }
        
        let achievementVM = self.boardViewModel.achievementAt(indexPath.row)
        
        achievementVM.title
            .asDriver(onErrorJustReturn: "")
            .drive(cell.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        achievementVM.goal
            .asDriver(onErrorJustReturn: "")
            .drive(cell.goalLabel.rx.text)
            .disposed(by: disposeBag)
        
        achievementVM.numOfSuccess
            .asDriver(onErrorJustReturn: 0 )
            .drive(onNext: { num in
                let description = "\(num) 일"
                cell.achieveLabel.text = description
                cell.badgeControl(numOfSuccess: num)
            }).disposed(by: disposeBag)
        
        achievementVM.date
            .asDriver(onErrorJustReturn: "")
            .drive(cell.dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        achievementVM.userID
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { id in
                cell.deleteButtonControl(id: id)
            })
            .disposed(by: disposeBag)
        
        achievementVM.goalID
            .asDriver(onErrorJustReturn: "")
            .drive(cell.rx.goalID)
            .disposed(by: disposeBag)
        
        return cell
    }
    
    
    
}
