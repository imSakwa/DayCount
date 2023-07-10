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
    
    private let viewModel: AddDDayViewModel
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
    
    private let tagInputView: TagInputView = {
        let view = TagInputView(frame: .zero)
        return view
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
    
    // MARK: Initializers
    init(viewModel: AddDDayViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupLayout()
        addObserver()
        setupDateStackView()
        setupTagInputView()
        bind()
    }
}

// MARK: - Methods

extension AddDDayViewController {
    
    private func setupDateStackView() {
        dateStackView.setupTextFieldDelegate(self)
        dateStackView.setupUpDownSwitchDelegate(self)
        dateStackView.setupDatePickerDelegate(self)
    }
    
    private func setupTagInputView() {
        tagInputView.setupTagCollectionViewDelegateFlowLayout(self)
        tagInputView.setupTagCollectionViewDataSource(self)
        tagInputView.setupTagTextFieldDelegate(self)
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRect = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRect.height
            
            addButton.snp.remakeConstraints {
                $0.bottom.equalTo(view.layoutMarginsGuide).inset(keyboardHeight + 12)
                $0.directionalHorizontalEdges.size.equalTo(titleTextField)
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
            addButton.snp.remakeConstraints {
                $0.bottom.equalTo(view.layoutMarginsGuide).inset(44)
                $0.directionalHorizontalEdges.size.equalTo(titleTextField)
                $0.centerX.equalToSuperview()
            }
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
        
        output.tagItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] tagList in
                self?.viewModel.addTag(tagList: tagList)
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
        [titleTextField, dateStackView, tagInputView, addButton].forEach { view.addSubview($0) }
        
        titleTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(44)
            $0.width.equalToSuperview().dividedBy(1.2)
            $0.height.equalTo(36)
        }
        
        dateStackView.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(45)
            $0.directionalHorizontalEdges.size.equalTo(titleTextField)
            $0.height.equalTo(36)
        }
        
        tagInputView.snp.makeConstraints {
            $0.top.equalTo(dateStackView.snp.bottom).offset(30)
            $0.directionalHorizontalEdges.size.equalTo(titleTextField)
            $0.height.equalTo(36)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(44)
            $0.directionalHorizontalEdges.size.equalTo(titleTextField)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if viewModel.tagList.count < 3 {
            viewModel.tagList.append(Tag(title: textField.text!))
            tagInputView.reloadCollectionView()
            
            textField.text = ""
        }
        
        return true
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AddDDayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        return CGSize(width: 100, height: 30)
    }
}

extension AddDDayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCollectionCell.identifier, for: indexPath) as? TagCollectionCell else {
            return UICollectionViewCell()
        }
        
        cell.titleLabel.text = viewModel.tagList[indexPath.row].title
        return cell
    }
}

private enum Design {
    static let titleTextFieldPlaceholder = "디데이 제목"
    static let addButtonTitle = "추가하기"
}
