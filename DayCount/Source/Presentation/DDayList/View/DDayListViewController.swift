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
    
    typealias DDayDataSource = UICollectionViewDiffableDataSource<Section, DDay>
    private lazy var ddayDataSource: DDayDataSource = setupCollectionViewDataSource()
    private let viewModel: DDayListViewModel
    private var currentCellType: DDayCellStyleType = .list
           
    private weak var tagButtonDelegate: TagButtonDelegate?
    
    private let listSettingView: ListSettingView = {
        return ListSettingView(frame: .zero)
    }()
    
    private let tagScrollView: TagScrollView = {
        return TagScrollView(frame: .zero)
    }()
    
    private lazy var itemCollectionView: UICollectionView = {
        let compositionalLayout = getCellType()
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )
        return collectionView
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
        
        initViewController()
    }
}

// MARK: - Methods

extension DDayListViewController {
    private func initViewController() {
        setupBaseView()
        setupSubviews()
        setupLayouts()
        
        setupTagScrollView()
        setupListSettingView()
        setupSnapshot()

        bind()
    }
    
    private func setupBaseView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupSubviews() {
        [tagScrollView, listSettingView, itemCollectionView]
            .forEach { view.addSubview($0) }
    }
    
    private func setupLayouts() {
        listSettingView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(36)
        }
        
        tagScrollView.snp.makeConstraints {
            $0.top.equalTo(listSettingView.snp.bottom)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        itemCollectionView.snp.makeConstraints {
            $0.top.equalTo(tagScrollView.snp.bottom)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.directionalHorizontalEdges.equalToSuperview().inset(8)
        }
    }
    
    private func setupTagScrollView() {
        viewModel.fetchTagList()
        
        tagScrollView.setupContent(with: viewModel.getTagList())
        tagScrollView.setupTagButtonDelegate(self)
    }
    
    private func setupListSettingView() {
        listSettingView.setupListSettingDelegate(self)
    }
    
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
    
    private func setupCollectionViewDataSource() -> DDayDataSource {
        let listStyleCell = UICollectionView.CellRegistration<DDayListCell, DDay> { (cell, index, dday) in
            cell.setupContentView(type: self.currentCellType,dday: dday)
        }
        
        let dataSource = UICollectionViewDiffableDataSource<Section, DDay> (
            collectionView: itemCollectionView,
            cellProvider: { (collectionView, indexPath, dday) -> UICollectionViewCell? in
                
                return collectionView.dequeueConfiguredReusableCell(
                    using: listStyleCell,
                    for: indexPath,
                    item: dday
                )
            }
        )
        return dataSource
    }
    
    private func setupSnapshot() {
        viewModel.fetchDDayList()
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, DDay>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.getDDayList())
        ddayDataSource.apply(snapShot)
    }
    
    private func filtered(with tagTitle: String) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DDay>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.getFilteredDDayList(with: tagTitle))
        ddayDataSource.apply(snapShot)
    }
    
    private func bind(){
        let input = DDayListViewModel.Input()
        
        let _ = viewModel.transform(input: input)
    }
    
    private func changeCellStyle(style: DDayCellStyleType) {
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

// MARK: - AddButtonDelegate
extension DDayListViewController: ListSettingDelegate {
    func addButtonTap() {
        let repository = TagRepository()
        let usecase = TagUsecase(repository: repository)
        let addDDayViewModel = AddDDayViewModel(usecase: usecase)
        let addItemVC = AddDDayViewController(viewModel: addDDayViewModel)
        
        addItemVC.addItemHandler = { [weak self] item in
            self?.viewModel.addDDayItem(item: item)
            self?.viewModel.fetchTagList()
        
            self?.setupSnapshot()
            if let tagList = self?.viewModel.getTagList() {
                self?.tagScrollView.setupContent(with: tagList)
                self?.tagScrollView.setupTagButtonDelegate(self!)
            }
        }
        
        present(addItemVC, animated: true)
    }
    
    func styleButtonTap() {
        let alertController = UIAlertController(
            title: Design.styleAlertControllerTitle,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        DDayCellStyleType.allCases.map { $0.rawValue }.forEach { style in
            let action = UIAlertAction(title: style, style: .default) { _ in
                self.changeCellStyle(style: DDayCellStyleType(rawValue: style)!)
            }
            
            alertController.addAction(action)
        }
        
        
        let cancel = UIAlertAction(title: Design.cancelAlertActionTitle, style: .cancel)
        alertController.addAction(cancel)
        
        
        present(alertController, animated: true)
    }
}

// MARK: - TagButtonDelegate
extension DDayListViewController: TagButtonDelegate {
    func tagButtonTap(tagTitle: String) {
        filtered(with: tagTitle)
    }
}

private enum Design {
    static let styleAlertControllerTitle = "스타일"
    static let cancelAlertActionTitle = "취소"
}
