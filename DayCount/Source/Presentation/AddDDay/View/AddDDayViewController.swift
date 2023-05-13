//
//  AddItemView.swift
//  DayCount
//
//  Created by 창민 on 2021/05/21.
//

import Combine
import UIKit

import SnapKit


final class AddDDayViewController: UIViewController {
    // MARK: Properties
    
    private var titles: [String] = []
    private var dates: [String] = []
    
    private let viewModel = AddDDayViewModel()
    private var cancellables = Set<AnyCancellable>()
    var addItemHandler: ((DDay) -> Void)?
    
    private let dateValue = PassthroughSubject<String, Never>()
    private let switchValue = PassthroughSubject<Bool, Never>()
    private let doneValue = PassthroughSubject<Void, Never>()
    
    
    private let titleTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.attributedPlaceholder = NSAttributedString(
            string: Design.titleTextFieldPlaceholder,
            attributes: [
                NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5960784314, green: 0.5921568627, blue: 0.6, alpha: 1)
            ]
        )
        textField.textFieldConfig(view: textField)
        return textField
    }()
    
    private let dateStackView: DateStackView = {
        let stackView = DateStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        return stackView
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.tintColor = .white
        button.setTitle(Design.addButtonTitle, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.backgroundColor = .systemGray2
        button.addTarget(self, action: #selector(addButtonTouched), for: .touchUpInside)
        return button
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        setupDateStackView()
        bind()
    }
}

// MARK: - Methods

extension AddDDayViewController {
    
    private func setupDateStackView() {
        dateStackView.setupTextFieldDelegate(self)
    }
    
    private func bind() {
        let input = AddDDayViewModel.Input(
            titleStr: titleTextField.publisher.eraseToAnyPublisher(),
            dateStr: dateValue.eraseToAnyPublisher(),
            isSwitchOn: switchValue.eraseToAnyPublisher(),
            tapDone: doneValue.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        output.enableSaveButton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.addButton.isEnabled = value
                self?.addButton.backgroundColor = value ? .systemBlue : .systemGray2
            }
            .store(in: &cancellables)

        output.ddayItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] dday in
                self?.addItemHandler?(dday)
                self?.dismiss(animated: true)
            }
            .store(in: &cancellables)

    }
 
    @objc private func addButtonTouched(_ sender: UIButton) {
        doneValue.send()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setupLayout() {
        [titleTextField, dateStackView, addButton].forEach { view.addSubview($0) }
        
        titleTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(200)
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.height.equalToSuperview().dividedBy(24)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(45)
            $0.directionalHorizontalEdges.size.equalTo(titleTextField)
        }
        
        addButton.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(100)
            $0.width.equalTo(150)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: - UpDownSwitchDelegate

extension AddDDayViewController: UpDownSwitchDelegate {
    func changeUpDownSwitch(isSwitchOn: Bool, dateString: String) {
        switchValue.send(isSwitchOn)
        dateValue.send(dateString)
    }
}

// MARK: - DatePickerDelegate

extension AddDDayViewController: DatePickerDelegate {
    func datePickerValueChanged(dateString: String) {
        dateValue.send(dateString)
    }
}

// MARK: - UITextField Delegate

extension AddDDayViewController: UITextFieldDelegate {
//    func textField(
//        _ textField: UITextField,
//        shouldChangeCharactersIn range: NSRange,
//        replacementString string: String
//    ) -> Bool {
//
//        return (textField == dateTextField) == false
//    }
}

private enum Design {
    static let titleTextFieldPlaceholder = "디데이 제목"
    static let addButtonTitle = "추가하기"
}
