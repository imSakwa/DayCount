//
//  UpDownSwitchDelegate.swift
//  DayCount
//
//  Created by ChangMin on 2023/05/09.
//

protocol UpDownSwitchDelegate: AnyObject {
    func changeUpDownSwitch(isSwitchOn: Bool, dateString: String)
}
