//
//  DateStackView.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/08.
//

import UIKit

import SnapKit

final class DateStackView: UIStackView {
    
    // MARK: Properties
    
    private weak var upDownSwitchDelegate: UpDownSwitchDelegate?
    private weak var datePickerDelegate: DatePickerDelegate?
    
    private let dateTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(
            string: Design.dateTextFieldPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5966893435, green: 0.5931452513, blue: 0.5994156003, alpha: 1)
            ]
        )
        textField.tintColor = .clear
        textField.textFieldConfig(view: textField)
        return textField
    }()
    
    private let upDownSwitchLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = Design.upDownSwitchLabelText
        label.textColor = .black
        return label
    }()
        
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    
    private let upDownSwitch: UISwitch = {
        let switchBtn = UISwitch(frame: .zero)
        switchBtn.isOn = false
        return switchBtn
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
    // MARK: Methods
    
    private func initView() {
        setupSubviews()
        setupDateTextField()
        setupUpDownSwitch()
        setupDatePicker()
    }
    
    private func setupSubviews() {
        [dateTextField, upDownSwitchLabel, upDownSwitch]
            .forEach { addArrangedSubview($0) }
    }
    
    private func setupDateTextField() {
        dateTextField.inputView = datePicker
    }
    
    private func setupUpDownSwitch() {
        upDownSwitch.addTarget(self, action: #selector(changeUpDownSwitch), for: .valueChanged)
    }
    
    @objc private func changeUpDownSwitch(_ sender: UISwitch) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Design.dateFormatYearMonthDay
        let currentDateString: String = dateFormatter.string(from: Date())
            
        dateTextField.text = sender.isOn ?  currentDateString : ""
        
        dateTextField.sendActions(for: .valueChanged)
        dateTextField.isEnabled = !dateTextField.isEnabled
        
        upDownSwitchDelegate?.changeUpDownSwitch(
            isSwitchOn: sender.isOn,
            dateString: dateTextField.text ?? ""
        )
    }
    
    func setupTextFieldDelegate(_ delegate: UITextFieldDelegate) {
        dateTextField.delegate = delegate
    }
        
    private func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = Design.dateFormatYearMonthDay
        
        let formattedDate = formatter.string(from: sender.date)
        
        dateTextField.text = formattedDate
        datePickerDelegate?.datePickerValueChanged(dateString: formattedDate)
    }
    
}

private enum Design {
    static let dateTextFieldPlaceholder = "연도 / 월 / 일"
    static let upDownSwitchLabelText = "오늘기준"
    static let dateFormatYearMonthDay = "yyyy년 M월 d일"
}
