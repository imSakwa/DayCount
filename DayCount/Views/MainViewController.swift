//
//  ViewController.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import UIKit

class MainViewController: UIViewController {
    
    var ddayList: [DDay] = []
    var feedbackGenerator: UISelectionFeedbackGenerator?
       
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var plusbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.init(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(addItemView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setLayout(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentStackView)
        self.view.addSubview(plusbutton)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        contentStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        plusbutton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        plusbutton.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 10).isActive = true
        
       
    }
    
    func saveData(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(ddayList){
            UserDefaults.standard.set(encoded, forKey: "items")
        }
    }

    func loadData() {
        if let savedDDayData = UserDefaults.standard.data(forKey: "items") {
            let decoder = JSONDecoder()
            if let loadedDDayData = try? decoder.decode([DDay].self, from: savedDDayData) {
                ddayList = loadedDDayData
            }
        }
        if !ddayList.isEmpty{
            for dday in ddayList{
                let itemView = ItemView()
                itemView.title.text = dday.title
               
                let swipeGesture = CustomSwipeGesture(target: self, action: #selector(tapView(view: )))
                swipeGesture.itemView = itemView
                swipeGesture.direction = .right
                itemView.addGestureRecognizer(swipeGesture)
                
                if dday.isSwitchOn {
                    itemView.date.text = dday.date + "~"
                    let dday: String = String(itemView.calcDDay(date: dday.date, isSwitchOn: dday.isSwitchOn))
                    itemView.ddaylabel.text = "D+"+dday
                }
                else {
                    itemView.date.text = "~" + dday.date
                    let dday: String = String(itemView.calcDDay(date: dday.date, isSwitchOn: dday.isSwitchOn))
                    itemView.ddaylabel.text = "D-"+dday
                }
                contentStackView.addArrangedSubview(itemView)
            }
        }
    }

    
    // plus 버튼 클릭 이벤트
    @objc func addItemView() {
        let addItemView = AddItemView()
        addItemView.modalPresentationStyle = .popover
        self.present(addItemView, animated: true, completion: nil)
    }
    
    // 추가된 디데이 항목 받는 함수
    func getDataAndPutItem(){
        let ddayValue = ddayList[ddayList.endIndex-1]
        let itemView = ItemView()
        
        itemView.title.text = ddayValue.title
       
        let swipeGesture = CustomSwipeGesture(target: self, action: #selector(tapView(view: )))
        swipeGesture.itemView = itemView
        swipeGesture.direction = .right
        itemView.addGestureRecognizer(swipeGesture)
        
        if ddayValue.isSwitchOn {
            itemView.date.text = ddayValue.date + "~"
            let dday: String = String(itemView.calcDDay(date: ddayValue.date, isSwitchOn: ddayValue.isSwitchOn))
            itemView.ddaylabel.text = "D+"+dday
        }
        else {
            itemView.date.text = "~" + ddayValue.date
            let dday: String = String(itemView.calcDDay(date: ddayValue.date, isSwitchOn: ddayValue.isSwitchOn))
            itemView.ddaylabel.text = "D-"+dday
        }
        contentStackView.addArrangedSubview(itemView)
        saveData()
    }
    
    @objc func tapView(view: CustomSwipeGesture){
        feedbackGenerator?.selectionChanged()
        let item: ItemView = view.itemView!
        
        let alert = UIAlertController(title: "디데이 삭제", message: "\"\(item.title.text!)\" 삭제하시겠습니까?", preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .light
        
        let okAction = UIAlertAction(title: "확인", style: .cancel) { [self] (action) in
            item.removeFromSuperview()
            if let index = ddayList.firstIndex(where: {$0.title == item.title.text!}){
                ddayList.remove(at: index)
            }
            saveData()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .destructive) { (action) in

        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        
        feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator?.prepare()    // 준비상태
        
        loadData()
        setLayout()
    }
}

class CustomSwipeGesture: UISwipeGestureRecognizer {
    var itemView: ItemView?
}

