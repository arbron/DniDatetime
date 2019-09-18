//
//  DniTimeIntervalPickerViewController.swift
//  dniDateTimeUI
//
//  Created by Jeff Hitchcock on 2019-09-17.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import UIKit
import dniDateTime

class DniTimeIntervalPickerViewController: UIViewController { }

extension DniTimeIntervalPickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let unit = findUnit(forComponent: component)
        return unit.max - unit.min
    }
}

extension DniTimeIntervalPickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let unit = findUnit(forComponent: component)
        let string = NSAttributedString(string: "\(row + unit.min)")
        return string
    }
}

extension DniTimeIntervalPickerViewController {
    fileprivate func findUnit(forComponent component: Int) -> DniDateTimeUnit {
        switch component {
        case 0: return .pahrtahvo
        case 1: return .tahvo
        case 2: return .gorahn
        case 3: return .prorahn
        default: fatalError("Invalid Component: \(component)")
        }
    }
}
