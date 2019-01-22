//
//  Date+StringFormatter.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/21.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation

public enum Weekday: Int {
    
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    public enum Language {
        case chinese, english
    }
    
    enum FormatterStyle {
        case normal, short
    }
    
    func name(_ language: Language = .chinese, style: FormatterStyle = .normal) -> String {
        switch language {
        case .chinese:
            return chineseWeekdayNames(with: style)
        case .english:
            return englishWeekdayNames(with: style)
        }
    }
    
    private func chineseWeekdayNames(with style: FormatterStyle) -> String {
        let shortNames = [
            1: "周日",
            2: "周一",
            3: "周二",
            4: "周三",
            5: "周四",
            6: "周五",
            7: "周六",
            ]
        let normalNames = [
            1: "星期日",
            2: "星期一",
            3: "星期二",
            4: "星期三",
            5: "星期四",
            6: "星期五",
            7: "星期六",
            ]
        switch style {
        case .short:
            return shortNames[self.rawValue]!
        case .normal:
            return normalNames[self.rawValue]!
        }
    }
    
    private func englishWeekdayNames(with style: FormatterStyle) -> String {
        let shortNames = [
            1: "Sun",
            2: "Mon",
            3: "Tue",
            4: "Wed",
            5: "Thu",
            6: "Fri",
            7: "Sat",
            ]
        let normalNames = [
            1: "Sunday",
            2: "Monday",
            3: "Tuesday",
            4: "Wednesday",
            5: "Thursday",
            6: "Friday",
            7: "Saturday",
            ]
        switch style {
        case .short:
            return shortNames[self.rawValue]!
        case .normal:
            return normalNames[self.rawValue]!
        }
    }
}


public extension Date {
    
    public var era: Int {
        return Calendar.current.component(.era, from: self)
    }
    
    //闰年
    
    //相对现在日期间隔天数
    
    //一个时间与当前时间间隔详情字符串
    
    //一个时间戳与当前时间的间隔详情字符串
    
    //MARK: - 天数间隔 day hour minute seconds 比如相隔 1天5小时2分钟20秒 或者 相隔-2天，-23小时，-49分钟，-27秒
    typealias TimeInteralBlock = (_ days: Int,_ hours: Int, _ minutes: Int, _ seconds: Int) -> ()
    public static func timeInteral(_ date: Date, referenceDate: Date = Date(), results: TimeInteralBlock) {
        let interal =  date.timeIntervalSince(referenceDate)
        
        let days  = Int(interal / (24 * 3600))
        var hours = Int(interal / 3600)
        hours = hours - days * 24
        
        let minutes = Int(interal / 60) - days * 24 * 60 - hours * 60
        
        let seconds = Int(interal) - (Int(interal / 60 ) * 60)
        
        results(days,hours,minutes,seconds)
    }
    
    //MARK: - 日期是星期几
    public static func weekday(from date: Date,
                               language: Weekday.Language = .chinese) -> String {
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "zh_CN")
        //        calendar.timeZone = TimeZone(identifier: "Asia/Shanghai")
        
        let weekday = calendar.component(.weekday, from: date)
        let wd = Weekday(rawValue: weekday)!
        return wd.name(language)
    }
    
    //MARK: - 日期是全年中的第多少周
    typealias WeekBlock = (_ weekOfYear: Int,_ weekOfMonth: Int,_ weekday: Int, _ weekdayOrdinal: Int) -> ()
    public static func week(by date: Date,
                            results: WeekBlock) {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekOfYear,.weekOfMonth,.weekday,.weekdayOrdinal], from: date)
        
        //今年的第几周
        let weekOfYear = components.weekOfYear!
        
        //这个月第几周
        let weekOfMonth = components.weekOfMonth!
        //周几
        let weekday = components.weekday!
        //这个月第几周
        let weekdayOrdinal = components.weekdayOrdinal!
        
        results(weekOfYear,weekOfMonth,weekday,weekdayOrdinal)
    }
    
    
    //MARK: - 日期转字符串
    public static func date2String(_ date: Date,
                                   dateFormatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = dateFormatter
        return formatter.string(from: date)
    }
    
    //MARK: - 字符串转日期
    public static func string2Date(_ dateString: String,
                                   dateFormatter: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateFormat = dateFormatter
        return formatter.date(from: dateString)
    }
    //字符串转日期详细时间
    
    //Mark: - 将时间戳转成日期
    // 一般请求回的时间戳是毫秒级的 / 1000 ,否则不用除
    public static func timestamp2Date(_ timestamp: Double,
                                      dateFormatter: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeInteral = TimeInterval(timestamp / 1000)
        let date = Date(timeIntervalSince1970: timeInteral)
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        return formatter.string(from: date)
    }
    //MARK: - 日期串转时间戳
    public static func date2Timestamp(_ date: String,
                                      dateFormatter: String = "yyyy-MM-dd HH:mm:ss") -> Double {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        if let formatterDate = formatter.date(from: date){
            return formatterDate.timeIntervalSince1970
        } else {
            fatalError()
        }
    }
    //时间戳格式字符串
    //生日转年龄
    public static func age(from birthday: String, dateFormatter: String = "yyyy-MM-dd") -> Int {
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormatter
        formatter.locale = Locale.current
        guard let formaterDate = formatter.date(from: birthday) else {
            fatalError()
        }
        
        let zone = TimeZone.current
        let timeInternal = Double(zone.secondsFromGMT(for: formaterDate))
        let lastDate = formaterDate.addingTimeInterval(timeInternal)
        
        let calendar    = Calendar.current
        let currentDate = Date()
        //获取年月日
        let birthYear  = calendar.component(.year, from: lastDate)
        let birthMonth = calendar.component(.month, from: lastDate)
        let birthDay   = calendar.component(.day, from: lastDate)
        //获取当前年月日
        let currentYear  = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentDay   = calendar.component(.day, from: currentDate)
        //对比
        var age = currentYear - birthYear
        if (currentMonth > birthMonth) || (currentMonth == birthMonth && currentDay > birthDay) {
            age += 1
        }
        return age
    }
    
    
    //日期转星座
    //时间戳转星座
    //获取当前时间戳，精确到毫秒
    //获取当前时间戳，精确到秒
    
    
    
}
