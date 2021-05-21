//
//  AddItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import UIKit

class AddItemView: UIViewController{
    
    var titles:[String] = []
    var dates: [String] = []
    var switchOn: Bool = false
    
    let days = [["2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"],["1","2","3","4","5","6","7","8","9","10","11","12"],["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]]
    
    
    
    var titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "디데이 제목", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5966893435, green: 0.5931452513, blue: 0.5994156003, alpha: 1)])
        textField.textFieldConfig(view: textField)
    
        return textField
    }()
    
    var dateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var dateTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "연도 / 월 / 일", attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5966893435, green: 0.5931452513, blue: 0.5994156003, alpha: 1)])
        textField.textFieldConfig(view: textField)
        return textField
    }()
    
    var textLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 기준"
        label.textColor = .black
        return label
    }()
    
    var datePickerView: UIPickerView = {
        let pickerview = UIPickerView()
        return pickerview
    }()
    
    var upDownSwitch: UISwitch = {
        let switchBtn = UISwitch()
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.isOn = false
        switchBtn.addTarget(self, action: #selector(onSwitchChanged), for: .valueChanged)
        return switchBtn
    }()
    
    var doneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setTitle("추가하기", for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneBtnClicked), for: .touchUpInside)
        return button
    }()
    
    func setLayout(){
        view.addSubview(titleTextField)
        view.addSubview(dateStackView)
        view.addSubview(doneBtn)
        
        dateStackView.addArrangedSubview(dateTextField)
        dateStackView.addArrangedSubview(textLabel)
        dateStackView.addArrangedSubview(upDownSwitch)
        
        dateTextField.inputView = datePickerView
        
        titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 225).isActive = true
        titleTextField.widthAnchor.constraint(equalToConstant: view.bounds.width/1.2).isActive = true
        titleTextField.heightAnchor.constraint(equalToConstant: view.bounds.height/24).isActive = true
        
        dateStackView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 45).isActive = true
        dateStackView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor).isActive = true
        dateStackView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor).isActive = true
        dateStackView.widthAnchor.constraint(equalTo: titleTextField.widthAnchor).isActive = true
        dateStackView.heightAnchor.constraint(equalToConstant: view.bounds.height/24).isActive = true
    
        doneBtn.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 100).isActive = true
        doneBtn.widthAnchor.constraint(equalToConstant: 150).isActive = true
        doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // 오늘부터 switch on/off 동작 함수
    @objc func onSwitchChanged(){
        if upDownSwitch.isOn {
            let format_date = DateFormatter()
            format_date.dateFormat = "yyyy-MM-dd"
            let currentDate = format_date.string(from: Date())
            let date = currentDate.split(separator: "-")
            
            dateTextField.text = date[0]+"년 "+date[1]+"월 "+date[2]+"일"
            switchOn = true
            dateTextField.isEnabled = false
        }
        else{
            switchOn = false
            dateTextField.isEnabled = true
            dateTextField.text = ""
        }
    }
    
    // 메인 뷰로 추가된 디데이의 제목과 날짜를 추가
    @objc func doneBtnClicked(){
        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
        }
        
        if titleTextField.text == "" {
            let alert = UIAlertController(title: "", message: "제목을 입력해주세요.", preferredStyle: .alert)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else if dateTextField.text == "" {
            let alert = UIAlertController(title: "", message: "날짜를 입력해주세요.", preferredStyle: .alert)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        else {
            guard let mainVC = self.presentingViewController as? MainViewController  else {
                return
            }
        
            mainVC.ddayList.append(DDay(title: titleTextField.text!, date: dateTextField.text!, isSwitchOn: switchOn))
            mainVC.getDataAndPutItem()
            self.dismiss(animated: true, completion: nil)
        }
    }
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setLayout()
        datePickerView.delegate = self
        datePickerView.dataSource = self
        
        let dateFormatter = DateFormatter()
        datePickerView.selectRow(0, inComponent: 0, animated: false)
        dateFormatter.dateFormat = "M"
        datePickerView.selectRow(Int(dateFormatter.string(from: Date()))!-1, inComponent: 1, animated: false)
        dateFormatter.dateFormat = "d"
        datePickerView.selectRow(Int(dateFormatter.string(from: Date()))!-1, inComponent: 2, animated: false)
    }

}



extension AddItemView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return days[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return days[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var year: String = ""
        var month: String = ""
        var day: String = ""
        
        switch component {
        case 0:
            year = days[0][row]
            month = days[1][pickerView.selectedRow(inComponent: 1)]
            day = days[2][pickerView.selectedRow(inComponent: 2)]
        case 1:
            year = days[0][pickerView.selectedRow(inComponent: 0)]
            month = days[1][row]
            day = days[2][pickerView.selectedRow(inComponent: 2)]
        case 2:
            year = days[0][pickerView.selectedRow(inComponent: 0)]
            month = days[1][pickerView.selectedRow(inComponent: 1)]
            day = days[2][row]
        default:
            print("Error!!")
        }
        
        dateTextField.text = year+"년 "+month+"월 "+day+"일"
    }
    
}

extension UITextField {
    func textFieldConfig(view: UITextField){
        view.textAlignment = .center
        view.backgroundColor = #colorLiteral(red: 0.8564875722, green: 0.8513966799, blue: 0.8604011536, alpha: 1)
        view.layer.cornerRadius = 10
        view.textColor = .black
    }
}

