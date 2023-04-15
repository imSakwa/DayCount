//
//  ViewController.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import Combine
import CoreData
import UIKit

import SnapKit


final class DDayListViewController: UIViewController {
   
    private var cancellables = Set<AnyCancellable>()
    private let tapAddButton = PassthroughSubject<Void, Never>()
    private let tapFilterButton = PassthroughSubject<String, Never>()
    private let tapMoreButton = PassthroughSubject<String, Never>()
    
    
    private var ddayDataSource: UITableViewDiffableDataSource<Section, DDay>!
    private let viewModel: DDayListViewModel

    private lazy var itemTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(
            DDayListItemTableViewCell.self,
            forCellReuseIdentifier: DDayListItemTableViewCell.identifier
        )
        tableView.tableFooterView = plusbutton
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var plusbutton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(clickPlusButton), for: .touchUpInside)
        return button
    }()
    
    private let feedbackGenerator: UISelectionFeedbackGenerator = {
        return UISelectionFeedbackGenerator()
    }()
    
    private let listSettingView: ListSettingView = {
        return ListSettingView(frame: .zero)
    }()
    
    init(viewModel: DDayListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()    // 준비상태
        
        setupLayout()
        setupTableViewDataSource()
        configureSnapshot()

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureFilterButton()
        configureMoreButton()
    }
}

// MARK: - Functions
extension DDayListViewController {
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [listSettingView, itemTableView]
            .forEach { view.addSubview($0) }
        
        listSettingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        itemTableView.snp.makeConstraints {
            $0.top.equalTo(listSettingView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    private func setupTableViewDataSource() {
        ddayDataSource = UITableViewDiffableDataSource<Section, DDay> (
            tableView: itemTableView,
            cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
                
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: DDayListItemTableViewCell.identifier,
                    for: indexPath
                ) as? DDayListItemTableViewCell else { return nil }
                
                cell.selectionStyle = .none
                cell.setupView(data: self.viewModel.getDDayItem(row: indexPath.row))
                
                return cell
        })
    }
    
    private func configureSnapshot() {
        viewModel.fetchDDayList()
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, DDay>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.getDDayList())
        ddayDataSource.apply(snapShot)
    }
    
    /// ListSettingView - FilterButton 설정 메서드
    private func configureFilterButton() {
        let filterAction = UIAction { _ in
            self.showActionSheet(type: .filter)
        }
        listSettingView.filterButton.addAction(filterAction, for: .touchUpInside)
    }
    
    /// ListSettingView - MoreButton 설정 메서드
    private func configureMoreButton() {
        let moreAction = UIAction { _ in
            self.showActionSheet(type: .more)
        }
        listSettingView.moreButton.addAction(moreAction, for: .touchUpInside)
    }
    
    @objc
    private func clickPlusButton(_ sender: UIButton) {
        tapAddButton.send()
    }
    
    // 뷰-뷰모델 바인딩
    private func bind(){
        let input = DDayListViewModel.Input(
            tapAddButton: tapAddButton.eraseToAnyPublisher(),
            tapFilterButton: tapFilterButton.eraseToAnyPublisher(),
            tapMoreButton: tapMoreButton.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.buttonTap
            .sink { [weak self] _ in
                self?.moveToAddItemVC()
            }
            .store(in: &cancellables)
    }
    
    // plus 버튼 클릭 이벤트
    private func moveToAddItemVC() {
        let addItemVC = AddItemViewController()
        addItemVC.addItemHandler = { [weak self] item in
            self?.viewModel.addDDayItem(item: item)
            self?.configureSnapshot()
        }
        present(addItemVC, animated: true)
    }
    
    private func showActionSheet(type: ActionType) {
        let alertController = UIAlertController(
            title: type.rawValue,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for actionTitle in viewModel.getActionTitleArray(type: type) {
            let action = UIAlertAction(title: actionTitle, style: .default) { _ in
                self.tapFilterButton.send(actionTitle)
            }
            
            alertController.addAction(action)
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancel)
        
        
        present(alertController, animated: true)
    }
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.removeDDayItem(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()


        }
    }
}
