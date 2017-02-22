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
    
    open var maxHours: Int = 1 {
        didSet {
            self.hours = 0
            self.minutes = 0
            self.pickerView?.reloadAllComponents()
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
    private var hoursTitleLabel: UILabel?
    private var minutesTitleLabel: UILabel?
    
    public init() {
        let screenWidth: CGFloat = UIScreen.main.bounds.width
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let width: CGFloat = screenWidth - 64
        let height: CGFloat = 250
        let x: CGFloat = 32
        let y: CGFloat = (screenHeight - height) / 2
        let frame: CGRect = CGRect(x: x, y: y, width: width, height: height)
        
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    private func initialize() {
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
        guard let pickerView = self.pickerView,
            let doneButton = self.doneButton,
            let closeButton = self.closeButton,
            let titleLabel = self.titleLabel else {
            return
        }
        
        self.clipsToBounds = false
        let screenSize = UIScreen.main.bounds.size
        let x: CGFloat = (self.frame.width - screenSize.width) / 2
        let y: CGFloat = (self.frame.height - screenSize.height) / 2
        let overlayView = UIView(frame: CGRect(x: x, y: y, width: screenSize.width,
            height: screenSize.height))
        overlayView.backgroundColor = UIColor.clear
        
        self.addSubview(overlayView)
        let topSeparator = UIView(frame: CGRect.zero)
        let bottomSeparator = UIView(frame: CGRect.zero)
        let bottomMiddleSeparator = UIView(frame: CGRect.zero)
        let topMiddleSeparator = UIView(frame: CGRect.zero)
        
        topSeparator.backgroundColor = self.grayColor
        bottomSeparator.backgroundColor = self.grayColor
        topMiddleSeparator.backgroundColor = self.grayColor
        bottomMiddleSeparator.backgroundColor = self.grayColor
        
        self.addSubview(pickerView)
        self.addSubview(doneButton)
        self.addSubview(closeButton)
        self.addSubview(titleLabel)
        self.addSubview(topSeparator)
        self.addSubview(bottomSeparator)
        self.addSubview(topMiddleSeparator)
        self.addSubview(bottomMiddleSeparator)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomSeparator.translatesAutoresizingMaskIntoConstraints = false
        topMiddleSeparator.translatesAutoresizingMaskIntoConstraints = false
        bottomMiddleSeparator.translatesAutoresizingMaskIntoConstraints = false
        
        //buttons
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: doneButton, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: doneButton, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: closeButton, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: closeButton, attribute: .bottom, multiplier: 1.0, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .leading, relatedBy: .equal, toItem: closeButton, attribute: .trailing, multiplier: 1.0, constant: 0))
        
        closeButton.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40))
        doneButton.addConstraint(NSLayoutConstraint(item: doneButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40))
        self.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0))

        //titles
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        titleLabel.addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 40))
        
        //pickerView
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .bottom, relatedBy: .equal, toItem: closeButton, attribute: .top, multiplier: 1.0, constant: 0))
        
        //separators
        self.addConstraint(NSLayoutConstraint(item: topSeparator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: topSeparator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: topSeparator, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .top, multiplier: 1.0, constant: 0))
        topSeparator.addConstraint(NSLayoutConstraint(item: topSeparator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5))
        
        self.addConstraint(NSLayoutConstraint(item: bottomSeparator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: bottomSeparator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: bottomSeparator, attribute: .bottom, relatedBy: .equal, toItem: pickerView, attribute: .bottom, multiplier: 1.0, constant: 0))
        bottomSeparator.addConstraint(NSLayoutConstraint(item: bottomSeparator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5))
        
        self.addConstraint(NSLayoutConstraint(item: topMiddleSeparator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: -15))
        self.addConstraint(NSLayoutConstraint(item: topMiddleSeparator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: topMiddleSeparator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        topMiddleSeparator.addConstraint(NSLayoutConstraint(item: topMiddleSeparator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5))
        
        self.addConstraint(NSLayoutConstraint(item: bottomMiddleSeparator, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 15))
        self.addConstraint(NSLayoutConstraint(item: bottomMiddleSeparator, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: bottomMiddleSeparator, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0))
        bottomMiddleSeparator.addConstraint(NSLayoutConstraint(item: bottomMiddleSeparator, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 0.5))
    }
    
    private func updateUI() {
        
        self.titleLabel?.textAlignment = .center
        
        self.closeButton?.setTitle(self.closeString, for: .normal)
        self.doneButton?.setTitle(self.doneString, for: .normal)
        self.titleLabel?.text = self.titleString
        
        self.closeButton?.titleLabel?.font = self.font
        self.doneButton?.titleLabel?.font = self.font
        self.titleLabel?.font = self.boldFont
        
        self.closeButton?.setTitleColor(self.blueColor, for: .normal)
        self.doneButton?.setTitleColor(self.blueColor, for: .normal)
        self.backgroundColor = self.background
        
        self.layer.borderColor = self.grayColor.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10
        self.pickerView?.layer.opacity = 0.5
    }
    
    open func show() {
        guard let appDelegate = UIApplication.shared.delegate else {
            assertionFailure()
            return
        }
        guard let window = appDelegate.window else {
            assertionFailure()
            return
        }
        
        window?.addSubview(self)
        window?.bringSubview(toFront: self)
        window?.endEditing(true)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.backgroundColor = UIColor.groupTableViewBackground
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
                if self.hours == self.maxHours { return 1 }
                return self.maxHours > 1 ? 60 : 61
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
        return "\(row)"
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
