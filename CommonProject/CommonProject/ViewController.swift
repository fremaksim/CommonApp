//
//  ViewController.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/21.
//  Copyright © 2019 mozhe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let date = Date()
        print(Date.date2String(date))
        print(Date.weekday(from: date, language: .chinese))
        
        print(Date.week(by: date, results: { (weekOfyear, weekOfMonth, weekday, weekOfOrinal) in
            print(weekOfyear)
            print(weekOfMonth)
            print(weekday)
            print(weekOfOrinal)
            
        }))
        
        let specifyDate = "2018-12-28 18:03:45"
        let newDate = Date.string2Date(specifyDate, dateFormatter: "yyyy-MM-dd HH:mm:ss")!
        
        print(Date.timeInteral(newDate, results: { (days, hours, minutes, seconds) in
            print("相隔\(days)天,\(hours)小时，\(minutes)分钟，\(seconds)秒")
        }))
        

        var number = "430821199311078240"
        number = number.replacingOccurrences(of: " ", with: "")
        if  String.isTrueIDNumber(text: number) {
            print("合格银行卡")
        }else {
            print("未知卡")
        }
    }
}

