//
//  ViewController.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import CoreData
import UIKit

import Combine

final class DDayListViewController: UIViewController {
   
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = DDayListViewModel()
    private let tapButton = PassthroughSubject<Void, Never>()

    private lazy var itemTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(
            DDayListItemTableViewCell.self,
            forCellReuseIdentifier: DDayListItemTableViewCell.identifier
        )
        tableView.tableFooterView = plusbutton
        tableView.delegate = self
        tableView.dataSource = self
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
        
    override func viewDidLoad() {
        super.viewDidLoad()
 
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .white
        
        feedbackGenerator.prepare()    // 준비상태
        
        setupLayout()
        bind()
        fetchDDay()
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
    
    @objc
    private func clickPlusButton(_ sender: UIButton) {
        tapButton.send()
    }
    
    // 뷰-뷰모델 바인딩
    private func bind(){
        let input = DDayListViewModel.Input(tapAddButton: tapButton.eraseToAnyPublisher())
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
            self?.itemTableView.reloadData()
            self?.saveInCoreData(item: item)
        }
        present(addItemVC, animated: true)
    }
    
    private func fetchDDay() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
            
        do {
            let dday = try context.fetch(DDayModel.fetchRequest()) as! [DDayModel]
            var list = [DDay]()
            
            for model in dday {
                list.append(DDay(title: model.title!, date: model.date!, isSwitchOn: model.isSwitchOn))
            }
            viewModel.initDDayArray(array: list)
            itemTableView.reloadData()
            
        } catch {
           print(error.localizedDescription)
        }
    }
    
    private func saveInCoreData(item: DDay) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "DDayModel", in: context)
                
        if let entity = entity {
            let dday = NSManagedObject(entity: entity, insertInto: context)
            dday.setValue(item.title, forKey: "title")
            dday.setValue(item.date, forKey: "date")
            dday.setValue(item.isSwitchOn, forKey: "isSwitchOn")
        }
        
        do {
             try context.save()
           } catch {
             print(error.localizedDescription)
           }
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
        return viewModel.getDDayArrayCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DDayListItemTableViewCell.identifier) as? DDayListItemTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.setupView(data: viewModel.getDDayItem(row: indexPath.row))
        return cell
    }
}
