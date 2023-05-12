//
//  DatePickerDelegate.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/12.
//

protocol DatePickerDelegate: AnyObject {
    func datePickerValueChanged(dateString: String)
}
