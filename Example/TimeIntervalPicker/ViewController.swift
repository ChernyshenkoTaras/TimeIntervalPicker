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
        timePicker.maxHours = 2
        timePicker.completion = { (timeInterval) in
            print(timeInterval)
        }
        timePicker.show()
    }
}
