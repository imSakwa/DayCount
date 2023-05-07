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
   
    // MARK: Properties
    
    private var cancellables = Set<AnyCancellable>()
    private let tapAddButton = PassthroughSubject<Void, Never>()
    private let tapFilterButton = PassthroughSubject<String, Never>()
    private let tapMoreButton = PassthroughSubject<String, Never>()
    
    private var ddayDataSource: UICollectionViewDiffableDataSource<Section, DDay>!
    private let viewModel: DDayListViewModel
    
    private var currentCellType: DDayListCellType = .list
    
    private lazy var itemCollectionView: UICollectionView = {
        let compositionalLayout = getCellType()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: compositionalLayout)
        collectionView.register(
            DDayCell.self,
            forCellWithReuseIdentifier: DDayCell.identifier
        )
        return collectionView
    }()
         
    private let feedbackGenerator: UISelectionFeedbackGenerator = {
        return UISelectionFeedbackGenerator()
    }()
    
    private let listSettingView: ListSettingView = {
        return ListSettingView(frame: .zero)
    }()
    
    // MARK: Initializers
    
    init(viewModel: DDayListViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedbackGenerator.prepare()
        
        setupLayout()
        setupCollectionViewDataSource()
        setupSnapshot()

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSettingView()
    }
}

// MARK: - Methods

extension DDayListViewController {
    private func setupSquareCellLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupListCellLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.3)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupLayout() {
        view.backgroundColor = .systemBackground
        
        [listSettingView, itemCollectionView]
            .forEach { view.addSubview($0) }
        
        listSettingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        itemCollectionView.snp.makeConstraints {
            $0.top.equalTo(listSettingView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    private func setupCollectionViewDataSource() {
        ddayDataSource = UICollectionViewDiffableDataSource<Section, DDay> (
            collectionView: itemCollectionView,
            cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: DDayCell.identifier,
                    for: indexPath
                ) as? DDayCell else { return nil }
                
                cell.setupContentView(
                    type: self.currentCellType,
                    dday: self.viewModel.getDDayItem(row: indexPath.row)
                )
                
                return cell
            }
        )
    }
    
    private func setupSnapshot() {
        viewModel.fetchDDayList()
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, DDay>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.getDDayList())
        ddayDataSource.apply(snapShot)
    }
    
    private func setupSettingView() {
        setupFilterButton()
        setupMoreButton()
        setupAddButton()
    }
    
    private func setupAddButton() {
        let addAction = UIAction { _ in
            self.clickPlusButton()
        }
        listSettingView.plusButton.addAction(addAction, for: .touchUpInside)
    }
    
    private func setupFilterButton() {
        let filterAction = UIAction { _ in
            self.showActionSheet(type: .filter)
        }
        listSettingView.filterButton.addAction(filterAction, for: .touchUpInside)
    }
    
    private func setupMoreButton() {
        let moreAction = UIAction { _ in
            self.showActionSheet(type: .more)
        }
        listSettingView.moreButton.addAction(moreAction, for: .touchUpInside)
    }
    
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
    
    private func clickPlusButton() {
        tapAddButton.send()
    }
    
    private func moveToAddItemVC() {
        let addItemVC = AddItemViewController()
        addItemVC.addItemHandler = { [weak self] item in
            self?.viewModel.addDDayItem(item: item)
            self?.setupSnapshot()
        }
        present(addItemVC, animated: true)
    }
    
    private func showActionSheet(type: AlertActionType) {
        let alertController = UIAlertController(
            title: type.rawValue,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        for actionTitle in viewModel.getActionTitleArray(type: type) {
            let action = UIAlertAction(title: actionTitle, style: .default) { _ in
                switch type {
                case .filter:
                    self.filterCollectionView(filter: DDayType(rawValue: actionTitle)!)
                case .more:
                    self.changeCellStyle(style: DDayListCellType(rawValue: actionTitle)!)
                }
            }
            
            alertController.addAction(action)
        }
        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alertController.addAction(cancel)
        
        
        present(alertController, animated: true)
    }
    
    private func filterCollectionView(filter: DDayType) {
        print(filter.rawValue)
    }
    
    private func changeCellStyle(style: DDayListCellType) {
        currentCellType = style
        
        itemCollectionView.setCollectionViewLayout(getCellType(), animated: true)
        itemCollectionView.collectionViewLayout.invalidateLayout()
        
        var snapShot = ddayDataSource.snapshot()
        snapShot.reloadSections([.main])
        ddayDataSource.apply(snapShot)
    }
    
    private func getCellType() -> UICollectionViewLayout {
        switch currentCellType {
        case .list:
            return setupListCellLayout()
        case .square:
            return setupSquareCellLayout()
        }
    }
}
