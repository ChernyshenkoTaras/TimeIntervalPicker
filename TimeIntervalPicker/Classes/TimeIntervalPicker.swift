//
//  TimeIntervalPicker.swift
//  TimeIntervalPicker
//
//  Created by Taras Chernyshenko on 2/6/17.
//  Copyright © 2017 Taras Chernyshenko. All rights reserved.
//

import UIKit

open class TimeIntervalPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let grayColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
    private let background = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0)
    private let blueColor = UIColor(red: 22/255, green: 131/255, blue: 250/255, alpha: 1.0)
    
    private let font = UIFont(name: "Helvetica", size: 13.0)
    private let boldFont = UIFont(name: "Helvetica-Bold", size: 15.0)
    
    public typealias Completion = (TimeInterval) -> Void
    
    private enum Component: Int {
        case hours
        case minutes
    }
    
    open var completion: Completion?
    
    open var maxMinutes: Int = 60 {
        didSet {
            self.hours = 0
            self.minutes = 0
            self.pickerView?.reloadAllComponents()
        }
    }
    
    private var maxHours: Int {
        get {
            let hours = self.maxMinutes / 60
            return hours < 1 ? 1 : hours
        }
    }
    
    open var titleString: String = "Time Interval" {
        didSet {
            self.titleLabel?.text = self.titleString
        }
    }
    
    open var doneString: String = "Done" {
        didSet {
            self.doneButton?.setTitle(self.doneString, for: .normal)
        }
    }
    
    open var closeString: String = "Close" {
        didSet {
            self.closeButton?.setTitle(self.closeString, for: .normal)
        }
	}
	
	open var hourSuffix: String?
	open var minuteSuffix: String?
	
    private var hours: Int = 0 {
        didSet {
            if self.maxHours == self.hours { self.minutes = 0 }
            
            let minutes: Component = .minutes
            self.pickerView?.reloadComponent(minutes.rawValue)
        }
    }
    private var minutes: Int = 0
    
    private var titleLabel: UILabel?
    private var doneButton: UIButton?
    private var closeButton: UIButton?
    
    private var pickerView: UIPickerView?
    private var containerView: UIView?
    
    public init() {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let frame: CGRect = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let width: CGFloat = screenWidth - 64
        let height: CGFloat = 250
        let x: CGFloat = 32
        let y: CGFloat = (screenHeight - height) / 2
        let frame: CGRect = CGRect(x: x, y: y, width: width, height: height)
        
        self.containerView = UIView(frame: frame)
        self.pickerView = UIPickerView(frame: CGRect.zero)
        self.doneButton = UIButton(frame: CGRect.zero)
        self.closeButton = UIButton(frame: CGRect.zero)
        self.titleLabel = UILabel(frame: CGRect.zero)
        
        self.pickerView?.dataSource = self
        self.pickerView?.delegate = self
        
        self.doneButton?.addTarget(self, action: #selector(TimeIntervalPicker.done),
            for: .touchUpInside)
        self.closeButton?.addTarget(self, action: #selector(TimeIntervalPicker.close),
            for: .touchUpInside)
        
        self.setupUI()
        self.updateUI()
    }
    
    private func setupUI() {
        guard let containerView = self.containerView,
            let pickerView = self.pickerView,
            let doneButton = self.doneButton,
            let closeButton = self.closeButton,
            let titleLabel = self.titleLabel else {
            return
        }
        
        let topSeparator = UIView(frame: CGRect.zero)
        let bottomSeparator = UIView(frame: CGRect.zero)
        
        topSeparator.backgroundColor = self.grayColor
        bottomSeparator.backgroundColor = self.grayColor
        
        self.addSubview(containerView)
        containerView.addSubview(pickerView)
        containerView.addSubview(doneButton)
        containerView.addSubview(closeButton)
        containerView.addSubview(titleLabel)
        containerView.addSubview(topSeparator)
        containerView.addSubview(bottomSeparator)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        //buttons
        containerView.addConstraint(NSLayoutConstraint(item: containerView,
            attribute: .trailing, relatedBy: .equal, toItem: doneButton,
            attribute: .trailing, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: containerView,
            attribute: .bottom, relatedBy: .equal, toItem: doneButton,
            attribute: .bottom, multiplier: 1.0, constant: 0))
        
        containerView.addConstraint(NSLayoutConstraint(item: containerView,
            attribute: .leading, relatedBy: .equal, toItem: closeButton,
            attribute: .leading, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: containerView,
            attribute: .bottom, relatedBy: .equal, toItem: closeButton,
            attribute: .bottom, multiplier: 1.0, constant: 0))
        
        containerView.addConstraint(NSLayoutConstraint(item: doneButton,
            attribute: .leading, relatedBy: .equal, toItem: closeButton,
            attribute: .trailing, multiplier: 1.0, constant: 0))
        
        closeButton.addConstraint(NSLayoutConstraint(item: closeButton,
            attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1.0, constant: 40))
        doneButton.addConstraint(NSLayoutConstraint(item: doneButton,
            attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1.0, constant: 40))
        containerView.addConstraint(NSLayoutConstraint(item: closeButton,
            attribute: .width, relatedBy: .equal, toItem: containerView,
            attribute: .width, multiplier: 0.5, constant: 0))

        //titles
        containerView.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .top, relatedBy: .equal, toItem: containerView,
            attribute: .top, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .leading, relatedBy: .equal, toItem: containerView,
            attribute: .leading, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .trailing, relatedBy: .equal, toItem: containerView,
            attribute: .trailing, multiplier: 1.0, constant: 0))
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel,
            attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1.0, constant: 40))
        
        //pickerView
        containerView.addConstraint(NSLayoutConstraint(item: pickerView,
            attribute: .leading, relatedBy: .equal, toItem: containerView,
            attribute: .leading, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: pickerView,
            attribute: .trailing, relatedBy: .equal, toItem: containerView,
            attribute: .trailing, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: pickerView,
            attribute: .top, relatedBy: .equal, toItem: titleLabel,
            attribute: .bottom, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: pickerView,
            attribute: .bottom, relatedBy: .equal, toItem: closeButton,
            attribute: .top, multiplier: 1.0, constant: 0))
        
        //separators
        containerView.addConstraint(NSLayoutConstraint(item: topSeparator,
            attribute: .leading, relatedBy: .equal, toItem: containerView,
            attribute: .leading, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: topSeparator,
            attribute: .trailing, relatedBy: .equal, toItem: containerView,
            attribute: .trailing, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: topSeparator,
            attribute: .bottom, relatedBy: .equal, toItem: pickerView,
            attribute: .top, multiplier: 1.0, constant: 0))
        topSeparator.addConstraint(NSLayoutConstraint(item: topSeparator,
            attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1.0, constant: 0.5))
        
        containerView.addConstraint(NSLayoutConstraint(item: bottomSeparator,
            attribute: .leading, relatedBy: .equal, toItem: containerView,
            attribute: .leading, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: bottomSeparator,
            attribute: .trailing, relatedBy: .equal, toItem: containerView,
            attribute: .trailing, multiplier: 1.0, constant: 0))
        containerView.addConstraint(NSLayoutConstraint(item: bottomSeparator,
            attribute: .bottom, relatedBy: .equal, toItem: pickerView,
            attribute: .bottom, multiplier: 1.0, constant: 0))
        bottomSeparator.addConstraint(NSLayoutConstraint(item: bottomSeparator,
            attribute: .height, relatedBy: .equal, toItem: nil,
            attribute: .height, multiplier: 1.0, constant: 0.5))
    }
    
    private func updateUI() {
        
        self.backgroundColor = UIColor.clear
        self.titleLabel?.textAlignment = .center
        
        self.closeButton?.setTitle(self.closeString, for: .normal)
        self.doneButton?.setTitle(self.doneString, for: .normal)
        self.titleLabel?.text = self.titleString
        
        self.closeButton?.titleLabel?.font = self.font
        self.doneButton?.titleLabel?.font = self.font
        self.titleLabel?.font = self.boldFont
        
        self.closeButton?.setTitleColor(self.blueColor, for: .normal)
        self.doneButton?.setTitleColor(self.blueColor, for: .normal)
        self.containerView?.backgroundColor = self.background
        
        self.containerView?.layer.borderColor = self.grayColor.cgColor
        self.containerView?.layer.borderWidth = 0.5
        self.containerView?.layer.cornerRadius = 10
        self.pickerView?.layer.opacity = 0.5
    }
    
    open func show(at selectedMinute: Int = 0) {
        guard let appDelegate = UIApplication.shared.delegate else {
            assertionFailure()
            return
        }
        guard let window = appDelegate.window else {
            assertionFailure()
            return
        }
        
        if selectedMinute <= self.maxMinutes {
            let minute = selectedMinute % 60
            let hour = selectedMinute <= 60 ? 0 : selectedMinute / 60
            
            self.hours = hour
            self.minutes = minute
            self.pickerView?.reloadAllComponents()
            
            if hour > 0 {
                self.pickerView?.selectRow(hour, inComponent: 0, animated: true)
                self.pickerView?.selectRow(minute, inComponent: 1, animated: true)
            } else {
                self.pickerView?.selectRow(minute, inComponent:
                    self.pickerView?.numberOfComponents == 1 ?
                    0 : 1, animated: true)
            }
        }
        
        window?.addSubview(self)
        window?.bringSubview(toFront: self)
        window?.endEditing(true)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.containerView?.backgroundColor = UIColor.groupTableViewBackground
            self.pickerView?.layer.opacity = 1
            self.pickerView?.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
    
    @objc private func done() {
        let hours: Int = self.hours
        let minutes: Int = self.minutes
        let seconds: Int = hours * 3600 + minutes * 60
        self.completion?(TimeInterval(seconds))
        self.close()
    }
    
    @objc private func close() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0.0
        }) { (isFinished) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: UIPickerViewDataSource methods
    
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.maxHours > 1 ? 2 : 1
    }
    
    public func pickerView(_ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int) -> Int {
        let comp = self.maxHours > 1 ? component : 1
        switch Component(rawValue: comp)! {
            case .hours: return self.maxHours + 1
            case .minutes:
                if self.hours == self.maxHours { return (self.maxMinutes % 60) + 1}
                return self.maxHours > 1 ? 60 : self.maxMinutes + 1
        }
    }
    
    //MARK: UIPickerViewDelegate methods
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,
        inComponent component: Int) {
        let comp = self.maxHours > 1 ? component : 1
        switch Component(rawValue: comp)! {
            case .hours: self.hours = row
            case .minutes: self.minutes = row
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int,
        forComponent component: Int) -> String? {
        let isMinuteComponent = numberOfComponents(in: pickerView) == 1 || component > 0
        
        let suffixType:String? = isMinuteComponent ?
            self.minuteSuffix : self.hourSuffix
        
        if let existingSuffix = suffixType {
            return "\(row) \(existingSuffix)"
        } else {
            return "\(row)"
        }
    }

    public func pickerView(_ pickerView: UIPickerView,
        widthForComponent component: Int) -> CGFloat {
        return 80
    }
    
    public func pickerView(_ pickerView: UIPickerView,
        rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
}
