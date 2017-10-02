//
//  ViewController.swift
//  TimeIntervalPicker
//
//  Created by Taras Chernyshenko on 02/08/2017.
//  Copyright (c) 2017 Taras Chernyshenko. All rights reserved.
//

import UIKit
import TimeIntervalPicker

class ViewController: UIViewController {
    
    @IBAction private func showButtonPressed(button: UIButton) {
        let timePicker = TimeIntervalPicker()
        timePicker.titleString = "Select time:"
        timePicker.maxMinutes = 180
        timePicker.minuteSuffix = "m"
        timePicker.hourSuffix = "h"
        timePicker.completion = { (timeInterval) in
            print(timeInterval)
        }
        timePicker.show(at: 0)
    }
}
