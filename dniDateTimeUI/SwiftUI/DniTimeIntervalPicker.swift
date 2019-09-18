//
//  DniTimeIntervalPicker.swift
//  dniDateTimeUI
//
//  Created by Jeff Hitchcock on 2019-09-17.
//  Copyright © 2019 Jeff Hitchcock. All rights reserved.
//

import SwiftUI
import dniDateTime

public struct DniTimeIntervalPicker: UIViewRepresentable {
    @Binding public var interval: Data

    public init(interval: Binding<Data>) {
        self._interval = interval
    }

    public typealias UIViewType = UIPickerView

    public func makeUIView(context: UIViewRepresentableContext<DniTimeIntervalPicker>) -> DniTimeIntervalPicker.UIViewType {
        let view = UIPickerView()
        view.dataSource = context.coordinator
        view.delegate = context.coordinator
        return view
    }

    public func updateUIView(_ uiView: DniTimeIntervalPicker.UIViewType, context: UIViewRepresentableContext<DniTimeIntervalPicker>) {
        
    }

    public func makeCoordinator() -> DniTimeIntervalPicker.Coordinator {
        return Coordinator(self)
    }

    public class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: DniTimeIntervalPicker

        init(_ picker: DniTimeIntervalPicker) {
            self.parent = picker
        }

        // MARK: Data Source
        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 4
        }

        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            let unit = findUnit(forComponent: component)
            return unit.max - unit.min
        }

        // MARK: Delegate
        public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
            let unit = findUnit(forComponent: component)
            let string = NSAttributedString(
                string: "\(row + unit.min)"
            )
            return string
        }

        public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let unit = findUnit(forComponent: component)
            let selectedValue = row + unit.min
            parent.setValue(selectedValue, forUnit: unit)
        }

        // MARK: Helper
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

    public struct Data {
        var selectedUnits: [DniDateTimeUnit: Int] = [:]

        public init() { }

        public mutating func set(unit: DniDateTimeUnit, to value: Int) {
            selectedUnits[unit] = value
        }

        public func interval() -> TimeInterval {
            let value: TimeInterval = selectedUnits.reduce(0.0) {
                return $0 + DniTimeInterval(DniDateTimeComponent($1.value, type: $1.key)).toSeconds
            }
            return value
        }
    }
}

extension DniTimeIntervalPicker {
    fileprivate func setValue(_ value: Int, forUnit unit: DniDateTimeUnit) {
        interval.set(unit: unit, to: value)
    }
}

//struct DniTimeIntervalPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        DniTimeIntervalPicker()
//    }
//}
