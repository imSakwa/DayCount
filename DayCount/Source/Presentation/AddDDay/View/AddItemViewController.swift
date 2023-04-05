//
//  AddItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import Combine
import UIKit

final class AddItemViewController: UIViewController {
    private var titles: [String] = []
    private var dates: [String] = []
    private var switchOn: Bool = false
    private let days = [["2021","2022","2023","2024","2025","2026","2027","2028","2029","2030"],["1","2","3","4","5","6","7","8","9","10","11","12"],["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"]]
    
    private let viewModel = AddDDayViewModel()
    private var cancellables = Set<AnyCancellable>()
    var addItemHandler: ((DDay) -> Void)?
    
    private let titleValue = PassthroughSubject<String, Never>()
    private let dateValue = PassthroughSubject<String, Never>()
    private let switchValue = PassthroughSubject<Bool, Never>()
    private let doneValue = PassthroughSubject<Void, Never>()
    
    
    private let titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "디데이 제목",
            attributes: [
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5960784314, green: 0.5921568627, blue: 0.6, alpha: 1)
            ]
        )
        textField.textFieldConfig(view: textField)
        return textField
    }()
    
    private let dateStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dateTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(
            string: "연도 / 월 / 일",
            attributes: [
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5966893435, green: 0.5931452513, blue: 0.5994156003, alpha: 1)
            ]
        )
        textField.textFieldConfig(view: textField)
        return textField
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "오늘 기준"
        label.textColor = .black
        return label
    }()
    
    private lazy var datePickerView: UIPickerView = {
        let pickerview = UIPickerView(frame: .zero)
        pickerview.delegate = self
        pickerview.dataSource = self
        return pickerview
    }()
    
    private lazy var upDownSwitch: UISwitch = {
        let switchBtn = UISwitch(frame: .zero)
        switchBtn.translatesAutoresizingMaskIntoConstraints = false
        switchBtn.isOn = false
        switchBtn.addTarget(self, action: #selector(changeSwitch), for: .valueChanged)
        return switchBtn
    }()
    
    private lazy var doneBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setTitle("추가하기", for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.backgroundColor = .systemGray2
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        bind()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        datePickerView.selectRow(Int(dateFormatter.string(from: Date()))!-2021, inComponent: 0, animated: false)
        dateFormatter.dateFormat = "M"
        datePickerView.selectRow(Int(dateFormatter.string(from: Date()))!-1, inComponent: 1, animated: false)
        dateFormatter.dateFormat = "d"
        datePickerView.selectRow(Int(dateFormatter.string(from: Date()))!-1, inComponent: 2, animated: false)
    }
}

extension AddItemViewController {
    private func bind() {
        let input = AddDDayViewModel.Input(
            titleStr: titleValue.eraseToAnyPublisher(),
            dateStr: dateValue.eraseToAnyPublisher(),
            isSwitchOn: switchValue.eraseToAnyPublisher(),
            tapDone: doneValue.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        output.enableSaveButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.doneBtn.isEnabled = value
                self?.doneBtn.backgroundColor = value ? .systemBlue : .systemGray2
            }
            .store(in: &cancellables)

        
        output.tapDoneButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (value1, value2, value3, value4) in
                let newItem = DDay(title: value2, date: value3, isSwitchOn: value4)
                self?.addItemHandler?(newItem)
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // 오늘부터 switch on/off 동작 함수
    @objc
    private func changeSwitch(_ sender: UISwitch) {
        switchValue.send(upDownSwitch.isOn)
        
        if upDownSwitch.isOn {
            let format_date = DateFormatter()
            format_date.dateFormat = "yyyy-M-d"
            let currentDate = format_date.string(from: Date())
            let date = currentDate.split(separator: "-")
            
            dateTextField.text = date[0]+"년 "+date[1]+"월 "+date[2]+"일"
        } else {
            dateTextField.text = ""
        }
        
        dateTextField.sendActions(for: .valueChanged)
        switchOn = !switchOn
        dateTextField.isEnabled = !dateTextField.isEnabled
    }
    
    private func setupView() {
        view.backgroundColor = .white
        dateTextField.inputView = datePickerView
    }
    
    private func setupLayout() {
        [titleTextField, dateStackView, doneBtn].forEach { view.addSubview($0) }
        [dateTextField, textLabel, upDownSwitch].forEach { dateStackView.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            titleTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 225),
            titleTextField.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.2),
            titleTextField.heightAnchor.constraint(equalToConstant: view.bounds.height / 24),
        ])
        
        NSLayoutConstraint.activate([
            dateStackView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 45),
            dateStackView.leftAnchor.constraint(equalTo: titleTextField.leftAnchor),
            dateStackView.rightAnchor.constraint(equalTo: titleTextField.rightAnchor),
            dateStackView.widthAnchor.constraint(equalTo: titleTextField.widthAnchor),
            dateStackView.heightAnchor.constraint(equalToConstant: view.bounds.height / 24)
        ])
        
        NSLayoutConstraint.activate([
            doneBtn.topAnchor.constraint(equalTo: dateStackView.bottomAnchor, constant: 100),
            doneBtn.widthAnchor.constraint(equalToConstant: 150),
            doneBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}



extension AddItemViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return days.count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
        return days[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
        return days[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
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
