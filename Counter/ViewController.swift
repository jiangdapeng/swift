//
//  ViewController.swift
//  Counter
//
//  Created by 江大鹏 on 15/1/17.
//  Copyright (c) 2015年 江大鹏. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var remainSeconds: Int = 0 {
        willSet(newVal) {
            let mins = newVal/60
            let seconds = newVal%60
            self.timeLabel!.text = NSString(format: "%02d:%02d", mins,seconds)
        }
    }
    
    var isCounting: Bool = false
    var timer: NSTimer?
    
    var timeLabel: UILabel?
    var timeButtons: [UIButton]?
    var startStopButton: UIButton?
    var resetButton: UIButton?
    
    let timeButtonsInfo = [("1分",60),("3分",180),("5分",300),("1秒",1)]
    
    func setupTimeLabel() {
        timeLabel = UILabel()
        timeLabel!.text = "00:00"
        timeLabel!.textColor = UIColor.whiteColor()
        timeLabel!.font = UIFont.systemFontOfSize(70)
        timeLabel!.backgroundColor = UIColor.blackColor()
        timeLabel!.textAlignment = NSTextAlignment.Center
        self.view.addSubview(timeLabel!)
        
    }
    
    func setupTimeButtons(){
        var buttons: [UIButton] = []
        for (index,(info,count)) in enumerate(timeButtonsInfo) {
            let button = UIButton()
            button.tag = index
            button.backgroundColor = UIColor.orangeColor()
            
            button.setTitle("\(info)", forState: UIControlState.Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            
            buttons.append(button)
            self.view.addSubview(button)
        }
        timeButtons = buttons
    }
    
    func setupControlButtons() {
        startStopButton = UIButton()
        startStopButton!.setTitle("开始", forState: UIControlState.Normal)
        startStopButton!.backgroundColor = UIColor.orangeColor()
        startStopButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        startStopButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        startStopButton!.addTarget(self, action: "startStopButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        resetButton = UIButton()
        resetButton!.backgroundColor = UIColor.redColor()
        resetButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        resetButton!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        resetButton!.setTitle("复位", forState: UIControlState.Normal)
        resetButton?.addTarget(self, action: "resetButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(startStopButton!)
        self.view.addSubview(resetButton!)
        
    }
    
    func updateTimer(timer: NSTimer) {
        self.remainSeconds -= 1
        if (self.remainSeconds <= 0) {
            stopCounting()
            let alert = UIAlertView()
            alert.title = "计时完成"
            alert.message = ""
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    
    func createAndFireLocalNotificationAfterSeconds(seconds:Int) {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let notification = UILocalNotification()
        let timeIntervalSinceNow = Double(seconds)
        notification.fireDate = NSDate(timeIntervalSinceNow: timeIntervalSinceNow)
        notification.timeZone = NSTimeZone.systemTimeZone();
        notification.alertBody = "计时完成！";
        UIApplication.sharedApplication().scheduleLocalNotification(notification);
    }
    
    func stopCounting() {
        self.isCounting = false
        startStopButton!.setTitle("开始", forState: UIControlState.Normal)
        startStopButton!.backgroundColor = UIColor.orangeColor()
        self.timer?.invalidate()
        self.timer = nil
        setTimeButtonEnabled(true)
    }
    func startCounting() {
        self.isCounting = true
        createAndFireLocalNotificationAfterSeconds(remainSeconds)
        startStopButton!.setTitle("停止", forState: UIControlState.Normal)
        startStopButton!.backgroundColor = UIColor.redColor()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimer:", userInfo: nil, repeats: true)
        setTimeButtonEnabled(false)
    }
    
    func startStopButtonTapped(sender: UIButton) {
        //
        if remainSeconds <= 0 {
            let alert = UIAlertView()
            alert.title = "请先设置计时量"
            alert.message = ""
            alert.addButtonWithTitle("OK")
            alert.show()
            return
        }
        if isCounting {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            stopCounting()
        }
        else {
            startCounting()
        }
    }
    func resetButtonTapped(sender: UIButton) {
        remainSeconds = 0
        startStopButton!.setTitle("开始", forState: UIControlState.Normal)
    }
    func timeButtonTapped(sender: UIButton) {
        let (_, seconds) = timeButtonsInfo[sender.tag]
        remainSeconds += seconds
    }
    
    
    func setTimeButtonEnabled(enabled: Bool) {
        for button in self.timeButtons! {
            button.enabled = enabled
            button.alpha = enabled ? 1.0 : 0.3
        }
        resetButton!.enabled = enabled
        resetButton!.alpha = enabled ? 1.0 : 0.3
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        timeLabel!.frame = CGRectMake(10, 100, self.view.bounds.size.width-20, 140)
        let gap = ( self.view.bounds.size.width - 10*2 - (CGFloat(timeButtons!.count) * 64) ) / CGFloat(timeButtons!.count - 1)
        for (index, button) in enumerate(timeButtons!) {
            let buttonLeft = 10 + (64 + gap) * CGFloat(index)
            button.frame = CGRectMake(buttonLeft, self.view.bounds.size.height-120, 64, 44)
        }
        
        resetButton!.frame = CGRectMake(10, self.view.bounds.size.height-60, 80, 44)
        startStopButton!.frame = CGRectMake(110, self.view.bounds.size.height-60, self.view.bounds.size.width-20-100, 44)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTimeLabel()
        setupTimeButtons()
        setupControlButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

