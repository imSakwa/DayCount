//
//  ItemViewModel.swift
//  DayCount
//
//  Created by 창민 on 2021/06/28.
//

import RxCocoa
import RxSwift

class ItemViewModel {
    struct Input {
        let tapDone = PublishSubject<Void>() 
        let title = PublishSubject<String>()
        let date = PublishSubject<String>()
        let isSwitchOn = PublishSubject<Bool>()
    }

    struct Output {
        let list = BehaviorRelay<[DDay]>(value: [])
        let enableDoneButton: Driver<Bool>
        let goToMain = PublishRelay<Void>()
    }
    
    var input = Input()
    var output: Output
    var disposeBag = DisposeBag()
    
    init() {
        // title과 date가 비어있지 않으면 true, 비어있으면 false
        let enableDoneButton = Observable
            .combineLatest(input.title, input.date)
            .map{ !$0.0.isEmpty && !$0.1.isEmpty }
            .asDriver(onErrorJustReturn: false)
    
        self.output = Output(enableDoneButton: enableDoneButton)
    
        // 버튼을 누르면 addDDay 메서드 실행
        input.tapDone.withLatestFrom(Observable.combineLatest(input.title, input.date, input.isSwitchOn))
            .bind { [weak self] (title, date, isSwitchOn) in
                print("\(title), \(date), \(isSwitchOn)")
                var date = date
                if isSwitchOn {
                    let format_date = DateFormatter()
                    format_date.dateFormat = "yyyy-MM-dd"
                    let currentDate = format_date.string(from: Date())
                    let splitdate = currentDate.split(separator: "-")
                    
                    date = splitdate[0]+"년 "+splitdate[1]+"월 "+splitdate[2]+"일"
                }
                else {
                    date = ""
                }
                self?.addDDay(title: title, date: date, isSwitchOn: isSwitchOn)
            }
            .disposed(by: disposeBag)
    }
        
    // dday 추가 메서드
    func addDDay(title: String, date: String, isSwitchOn: Bool){
        let dday = self.output.list.value + [DDay(title: title, date: date, isSwitchOn: isSwitchOn)]
        self.output.list.accept(dday)
        self.output.goToMain.accept(())
    }
    
    // dday 계산 메서드
    func calcDDay(date: String, isSwitchOn: Bool) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") as TimeZone?
        let todayDate: Date = dateFormatter.date(from: dateFormatter.string(from: Date()))!
        let textFieldDate: Date = dateFormatter.date(from: date)!
        
        var interval: TimeInterval
        if isSwitchOn {
            interval = todayDate.timeIntervalSince(textFieldDate)
        } else {
            interval = textFieldDate.timeIntervalSince(todayDate)
        }
        return Int(interval/86400)
    }

}

// 디데이 항목 세이브 메서드
//    func saveData(){
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(){
//            UserDefaults.standard.set(encoded, forKey: "items")
//        }
//    }
//
//    // 저장된 디데이 항목 로드 메서드
//    func loadData() {
//
//        UserDefaults.standard.rx
//            .observe()
//        if let savedDDayData = UserDefaults.standard.data(forKey: "items") {
//            let decoder = JSONDecoder()
//            if let loadedDDayData = try? decoder.decode([DDay].self, from: savedDDayData) {
//                ddayList = loadedDDayData
//            }
//        }
//        if !ddayList.isEmpty{
//            for dday in ddayList{
//                let itemView = ItemView()
//                itemView.title.text = dday.title
//
////                let swipeGesture = CustomSwipeGesture(target: self, action: #selector(tapView(view: )))
////                swipeGesture.itemView = itemView
////                swipeGesture.direction = .right
////                itemView.addGestureRecognizer(swipeGesture)
//
//                if dday.isSwitchOn {
//                    itemView.date.text = dday.date + "~"
//                    let dday: String = String(itemView.calcDDay(date: dday.date, isSwitchOn: dday.isSwitchOn))
//                    itemView.ddaylabel.text = "D+"+dday
//                }
//                else {
//                    itemView.date.text = "~" + dday.date
//                    let dday: String = String(itemView.calcDDay(date: dday.date, isSwitchOn: dday.isSwitchOn))
//                    itemView.ddaylabel.text = "D-"+dday
//                }
//               // contentStackView.addArrangedSubview(itemView)
//            }
//        }
//    }
