//
//  ViewController.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import UIKit

import RxCocoa
import RxSwift

final class DDayListViewController: UIViewController {
    var feedbackGenerator: UISelectionFeedbackGenerator?
    private let disposebag = DisposeBag()
    private var viewModel = DDayListVIewModel()

    private lazy var itemTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(
            DDayListItemTableViewCell.self,
            forCellReuseIdentifier: DDayListItemTableViewCell.identifier
        )
        tableView.tableFooterView = plusbutton
        tableView.rx.setDelegate(self).disposed(by: disposebag)
        return tableView
    }()
    
    private lazy var plusbutton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        return button
    }()
        
    // 뷰-뷰모델 바인딩
    func bind(){
        plusbutton.rx.tap
            .bind{ [weak self] in
                self?.addItemView()
            }.disposed(by: disposebag)
        
        viewModel.output.reloadList
            .subscribe(onNext: { [weak self] _ in
                self?.itemTableView.reloadData()
            })
            .disposed(by: disposebag)
        
        viewModel.output.list.accept(viewModel.list)

        viewModel.output.list
            .bind(to: itemTableView.rx.items) { tableView, indexPath, item in
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DDayListItemTableViewCell.identifier
                ) as? DDayListItemTableViewCell
                else { return UITableViewCell() }
                
                cell.bind(data: item)
                
          
                return cell
            }
            .disposed(by: disposebag)
    }
    
    // plus 버튼 클릭 이벤트
    private func addItemView() {
        let addItemView = AddItemView()
        addItemView.modalPresentationStyle = .fullScreen
        self.present(addItemView, animated: true, completion: nil)
    }
        
    func setupView(){
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        
        view.addSubview(itemTableView)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            itemTableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            itemTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -200
            ),
            itemTableView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            itemTableView.widthAnchor.constraint(
                equalToConstant: UIScreen.main.bounds.width - 20
            )
        ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()    // 준비상태
        
        setupView()
        setupLayout()
        bind()
    }
}

class CustomSwipeGesture: UISwipeGestureRecognizer {
    var itemView: DDayListItemTableViewCell?
}

extension DDayListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return plusbutton
    }
}

//viewModel.output.list
//    .asDriver()
//    .drive(itemTableView.rx.items){ tableView, indexPath, item in
//    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableViewCell
//    cell.title.text = item.title
//
//    if item.isSwitchOn {
//        cell.date.text = item.date + "~"
//        let dday: String = String(self.viewModel.calcDDay(date: item.date, isSwitchOn: item.isSwitchOn))
//        cell.ddaylabel.text = "D+"+dday
//    } else {
//        cell.date.text = "~" + item.date
//        let dday: String = String(self.viewModel.calcDDay(date: item.date, isSwitchOn: item.isSwitchOn))
//        cell.ddaylabel.text = "D-"+dday
//    }
//    return cell
//}.disposed(by: disposebag)
