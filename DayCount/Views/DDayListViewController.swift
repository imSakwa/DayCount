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
    private var viewModel = DDayListViewModel()

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
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var plusbutton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
 
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()    // 준비상태
        
        setupLayout()
        bind()
    }
}

// MARK: - Functions
extension DDayListViewController {
    
    private func setupLayout() {
        view.addSubview(itemTableView)
        
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
    
    // 뷰-뷰모델 바인딩
    private func bind(){
        let input = DDayListViewModel.Input(tapAddButton: plusbutton.rx.tap)
        let output = viewModel.transform(input: input)
        
        output.buttonTap
            .drive(onNext: { [weak self] _ in self?.moveToAddItemVC() })
            .disposed(by: disposebag)
        
        
    }
    
    // plus 버튼 클릭 이벤트
    private func moveToAddItemVC() {
        let addItemVC = AddItemViewController()
        addItemVC.addItemHandler = { [weak self] item in
            self?.viewModel.ddayList.append(item)
            self?.itemTableView.reloadData()
        }
        present(addItemVC, animated: true)
    }
}

class CustomSwipeGesture: UISwipeGestureRecognizer {
    var itemView: DDayListItemTableViewCell?
}

// MARK: - UITableView Extension
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

extension DDayListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.ddayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DDayListItemTableViewCell.identifier) as? DDayListItemTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupView(data: viewModel.ddayList[indexPath.row])
        return cell
    }
}
