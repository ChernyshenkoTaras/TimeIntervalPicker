# TimeIntervalPicker
UIDatePicker-like picker in .countDownTimer mode with range selection support

[![](https://raw.githubusercontent.com/ChernyshenkoTaras/TimeIntervalPicker/blob/master/TimeIntervalPicker/Images/time_interval_picker_example_1.png)](https://raw.githubusercontent.com/ChernyshenkoTaras/TimeIntervalPicker/blob/master/TimeIntervalPicker/Images/time_interval_picker_example_1.png)

## Requirements

TimeIntervalPicker works on iOS 8 and 9. It depends on the following Apple frameworks, which should already be included with most Xcode templates:

* Foundation
* UIKit

## Installation
#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `TimeIntervalPicker` by adding it to your `Podfile`:

```ruby
platform :ios, '8.0'
use_frameworks!
pod 'TimeIntervalPicker'
```
#### Manually
1. Download and drop ```TimeIntervalPicker.swift``` in your project.
2. Congratulations!

## Example

```swift
import UIKit
import TimeIntervalPicker

class ViewController: UIViewController {
    
    @IBAction private func showButtonPressed(button: UIButton) {
        let timePicker = TimeIntervalPicker()
        timePicker.titleString = "Select time:"
        timePicker.maxMinutes = 180
        timePicker.completion = { (timeInterval) in
            print(timeInterval)
        }
        timePicker.show(at: 0)
    }
}
```

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).