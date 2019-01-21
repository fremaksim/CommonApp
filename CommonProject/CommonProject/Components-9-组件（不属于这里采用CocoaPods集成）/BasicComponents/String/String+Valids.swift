//
//  String+Valids.swift
//  CommonProject
//
//  Created by mozhe on 2019/1/21.
//  Copyright © 2019 mozhe. All rights reserved.
//

import Foundation


// MARK: - 字符串校验
public extension String {
    
    //MARK: - 验证邮箱
    public static func validateEmail(email: String) -> Bool {
        if email.count == 0 { return false }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    //MARK: - 验证手机号
    public static func isPhoneNumber(phoneNumber: String) -> Bool {
        if phoneNumber.count == 0 { return false }
        //        let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
        let mobile = "1[0-9]{10}"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else {
            return false
        }
    }
    
    //MARK: - 密码正则  6-8位字母和数字组合
    public static func isPasswordRuler(password: String) -> Bool {
        let passwordRule = "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,8}$"
        let regexPassword = NSPredicate(format: "SELF MATCHES %@",passwordRule)
        if regexPassword.evaluate(with: password) == true {
            return true
        }else {
            return false
        }
    }
    //MARK: - 验证身份证号
    public static func isTrueIDNumber(text: String) -> Bool{
        var value = text
        value = value.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        var length : Int = 0
        length = value.count
        if length != 15 && length != 18{
            //不满足15位和18位，即身份证错误
            return false
        }
        // 省份代码
        let areasArray = ["11","12", "13","14", "15","21", "22","23", "31","32", "33","34", "35","36", "37","41", "42","43", "44","45", "46","50", "51","52", "53","54", "61","62", "63","64", "65","71", "81","82", "91"]
        // 检测省份身份行政区代码
        let index = value.index(value.startIndex, offsetBy: 2)
//        let valueStart2 = value.substring(to: index)
         let valueStart2 = value[value.startIndex..<index]
        //标识省份代码是否正确
        var areaFlag = false
        for areaCode in areasArray {
            if areaCode == valueStart2 {
                areaFlag = true
                break
            }
        }
        if !areaFlag {
            return false
        }
        var regularExpression : NSRegularExpression?
        var numberofMatch : Int?
        var year = 0
        switch length {
        case 15:
            //获取年份对应的数字
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 2)) as NSString
            year = yearStr.integerValue + 1900
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }else{
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$", options: NSRegularExpression.Options.caseInsensitive)
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            if numberofMatch! > 0 {
                return true
            }else {
                return false
            }
        case 18:
            let valueNSStr = value as NSString
            let yearStr = valueNSStr.substring(with: NSRange.init(location: 6, length: 4)) as NSString
            year = yearStr.integerValue
            if year % 4 == 0 || (year % 100 == 0 && year % 4 == 0) {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            }else {
                //测试出生日期的合法性
                regularExpression = try! NSRegularExpression.init(pattern: "^((1[1-5])|(2[1-3])|(3[1-7])|(4[1-6])|(5[0-4])|(6[1-5])|71|(8[12])|91)\\d{4}(((19|20)\\d{2}(0[13-9]|1[012])(0[1-9]|[12]\\d|30))|((19|20)\\d{2}(0[13578]|1[02])31)|((19|20)\\d{2}02(0[1-9]|1\\d|2[0-8]))|((19|20)([13579][26]|[2468][048]|0[048])0229))\\d{3}(\\d|X|x)?$", options: NSRegularExpression.Options.caseInsensitive)
                
            }
            numberofMatch = regularExpression?.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange.init(location: 0, length: value.count))
            
            if numberofMatch! > 0 {
                let a = getStringByRangeIntValue(str: valueNSStr, location: 0, length: 1) * 7
                let b = getStringByRangeIntValue(str: valueNSStr, location: 10, length: 1) * 7
                let c = getStringByRangeIntValue(str: valueNSStr, location: 1, length: 1) * 9
                let d = getStringByRangeIntValue(str: valueNSStr, location: 11, length: 1) * 9
                let e = getStringByRangeIntValue(str: valueNSStr, location: 2, length: 1) * 10
                let f = getStringByRangeIntValue(str: valueNSStr, location: 12, length: 1) * 10
                let g = getStringByRangeIntValue(str: valueNSStr, location: 3, length: 1) * 5
                let h = getStringByRangeIntValue(str: valueNSStr, location: 13, length: 1) * 5
                let i = getStringByRangeIntValue(str: valueNSStr, location: 4, length: 1) * 8
                let j = getStringByRangeIntValue(str: valueNSStr, location: 14, length: 1) * 8
                let k = getStringByRangeIntValue(str: valueNSStr, location: 5, length: 1) * 4
                let l = getStringByRangeIntValue(str: valueNSStr, location: 15, length: 1) * 4
                let m = getStringByRangeIntValue(str: valueNSStr, location: 6, length: 1) * 2
                let n = getStringByRangeIntValue(str: valueNSStr, location: 16, length: 1) * 2
                let o = getStringByRangeIntValue(str: valueNSStr, location: 7, length: 1) * 1
                let p = getStringByRangeIntValue(str: valueNSStr, location: 8, length: 1) * 6
                let q = getStringByRangeIntValue(str: valueNSStr, location: 9, length: 1) * 3
                let S = a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q
                
                let Y = S % 11
                
                var M = "F"
                
                let JYM = "10X98765432"
                
                M = (JYM as NSString).substring(with: NSRange.init(location: Y, length: 1))
                
                let lastStr = valueNSStr.substring(with: NSRange.init(location: 17, length: 1))
                
                if lastStr == "x" {
                    if M == "X" {
                        return true
                    }else {
                        return false
                    }
                }else {
                    if M == lastStr {
                        return true
                    }else {
                        return false
                    }
                }
            }else {
                return false
            }
        default:
            return false
        }
        
    }
    
    //MARK: - 银行卡 16位和19位校验
    public static func isBankCardNo(_ cardNo: String) -> Bool {
        guard cardNo.count == 16 || cardNo.count == 19 else {
            return false
        }
        guard isAllNumeric(str: cardNo) == true else {
            return false
        }
        
        var oddSum  = 0
        var evenSum = 0
        var allSum  = 0
        let cardNoLength = cardNo.count
        let lastNumber = Int(String(cardNo[(cardNoLength - 1)]))!
        let cardNo = cardNo[safe: 0...(cardNoLength - 2)]! //去掉最后一位
        
        for i in stride(from: cardNoLength - 1, to: 0, by: -1) {
            let tempString = cardNo[safe: (i - 1 )...(i - 1)]! //倒数取每一位 一共15位或者18位
            var tmpVal = Int(tempString)!
            if (cardNoLength % 2 == 1) {
                if ((i % 2) == 0) {
                    tmpVal *= 2
                    if(tmpVal>=10){
                        tmpVal -= 9
                    }
                    evenSum += tmpVal
                }else{
                    oddSum += tmpVal
                }
            }else {
                if((i % 2) == 1){
                    tmpVal *= 2;
                    if(tmpVal >= 10) {
                        tmpVal -= 9
                    }
                    evenSum += tmpVal
                }else {
                    oddSum += tmpVal
                }
            }
        }
        
        allSum = oddSum + evenSum
        allSum += lastNumber
        if ((allSum % 10) == 0) {
            return true
        }else {
            return false
        }
    }
    
    
    private static func getStringByRangeIntValue(str : NSString,location : Int, length : Int) -> Int{
        let a = str.substring(with: NSRange(location: location, length: length))
        let intValue = (a as NSString).integerValue
        return intValue
    }
    //TODO: - ToDoList
    //字符串是否合法URL
    //字符串是否合法座机
    //字符串是否合法车牌号
    
    //MARK: - 只包含
    //MARK: - 字符串是否只包含数字
    public static func isAllNumeric(str: String) -> Bool {
        if str.count == 0 { return false }
        let numericRegex = "^[0-9]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", numericRegex)
        return predicate.evaluate(with: str)
    }
    
    //MARK: - 字符串是否只包含中文字符
    public static func isAllChinese(str: String) -> Bool {
        if str.count == 0  { return false }
        //NSString *match = @"(^[\u4e00-\u9fa5]+$)";
        let chineseRegex = "(^[\\u4e00-\\u9fa5]+$)"
        let predicate = NSPredicate(format: "SELF matches %@", chineseRegex)
        return predicate.evaluate(with: str)
    }
    
    // 判断一个字符串是否在某个范围 比如2~15个汉字，代码如下
    // 一个汉字对应两个字符
    public static func isAvailableLength(str: String, miniLength: Int, maxlength: Int) -> Bool {
        if str.count == 0 { return false }
        var character = 0
        for i in 0..<str.count {
            let a = str[i]
            if a >= "\u{4E00}" && a <= "\u{9FA5}" {
                character += 2
            }else {
                character += 1
            }
        }
        return (character >= miniLength && character <= maxlength)
    }
    
    //MARK: - 字符串是否只有英文字符，26个英文字符
    public  static func isAllEnglishCharacters(str: String) -> Bool {
        if str.count == 0 { return false}
        let characterRegex = "[A-Za-z]"
        let predicate = NSPredicate(format: "SELF MATCHES %@", characterRegex)
        return predicate.evaluate(with: str)
    }
    
    //字符串是否只有字符、中文、数字
    fileprivate  subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
}
