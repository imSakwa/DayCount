//
//  ViewController.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import RxCocoa
import RxDataSources
import RxSwift
import UIKit

class MainView: UIViewController {
    var feedbackGenerator: UISelectionFeedbackGenerator?
    let disposebag = DisposeBag()

    var itemTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        return table
    }()
    
    var plusbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        return button
    }()
    
    var viewModel = ItemViewModel()
        
    // 뷰-뷰모델 바인딩
    func bind(){
        plusbutton.rx.tap
            .bind{ [weak self] in
                self?.addItemView()
            }.disposed(by: disposebag)
        
        viewModel.output.reloadList
            .subscribe(onNext: { [weak self] _ in
                print("reload?")
                self?.itemTableView.reloadData()
            })
            .disposed(by: disposebag)
        
        viewModel.output.list.accept(viewModel.ddaylist)

        viewModel.output.list
            .bind(to: itemTableView.rx.items){ tableView, indexPath, item in
            print("bind list")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableViewCell
            cell.title.text = item.title
            
            if item.isSwitchOn {
                cell.date.text = item.date + "~"
                let dday: String = String(self.viewModel.calcDDay(date: item.date, isSwitchOn: item.isSwitchOn))
                cell.ddaylabel.text = "D+"+dday
            } else {
                cell.date.text = "~" + item.date
                let dday: String = String(self.viewModel.calcDDay(date: item.date, isSwitchOn: item.isSwitchOn))
                cell.ddaylabel.text = "D-"+dday
            }
            return cell
        }.disposed(by: disposebag)
    }
    
    // plus 버튼 클릭 이벤트
    private func addItemView() {
        let addItemView = AddItemView()
        addItemView.modalPresentationStyle = .fullScreen
        self.present(addItemView, animated: true, completion: nil)
    }
        
    func setLayout(){
        view.addSubview(itemTableView)
        
        itemTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        itemTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true
        itemTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemTableView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20).isActive = true
    }
    
    func setupTableView(){
        itemTableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "cell")
        //itemTableView.footerView(forSection: ddayList.count)
        itemTableView.tableFooterView = plusbutton
        itemTableView.rx.setDelegate(self).disposed(by: disposebag)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()    // 준비상태
        
        setupTableView()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bind()
    }

}

class CustomSwipeGesture: UISwipeGestureRecognizer {
    var itemView: ItemTableViewCell?
}

extension MainView: UITableViewDelegate {
    // Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 10
    }
    
    // Delegate
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    // Delegate
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
