//
//  UITextField+.swift
//  DayCount
//
//  Created by ChangMin on 2023/01/15.
//

import Combine
import UIKit

extension UITextField {
    func textFieldConfig(view: UITextField) {
        view.textAlignment = .center
        view.backgroundColor = #colorLiteral(red: 0.8564875722, green: 0.8513966799, blue: 0.8604011536, alpha: 1)
        view.layer.cornerRadius = 10
        view.textColor = .black
    }
    
    var publisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { ($0.object as? UITextField)?.text }
            .eraseToAnyPublisher()
    }
}
