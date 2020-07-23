//
//  Users.swift
//  Practical
//
//  Created by HariKrishna Kundariya on 14/07/20.
//  Copyright © 2020 HariKrishna Kundariya. All rights reserved.
//

import Foundation
import UIKit

class UserDataList {
    
    init() {}
    
    var map: Map!
    
    var arrUserData = [UserData]()
    
    init(data: [[String: AnyObject]]) {
        
        for dictDishCategory in data {
            arrUserData.append(UserData(data: dictDishCategory))
        }
    }
    
    class UserData {
        
        init() {}
        
        var map: Map!
        
        var name = ""
        var email = ""
        var contact = ""
        var birthdate = ""
        var description = ""
        var profile_photo = [String: AnyObject]()
        
        init(data: [String: AnyObject]) {
            map = Map(data: data)
            name = map.value("name") ?? ""
            email = map.value("email") ?? ""
            contact = map.value("contact") ?? ""
            birthdate = map.value("birthdate") ?? ""
            description = map.value("description") ?? ""
            profile_photo = map.value("profile_photo") ?? [:]
        }
    }
}


class Map {
    
    init() {}
    
    var data: [String: AnyObject]?
    
    init(data: [String: AnyObject]) {
        self.data = data
    }
    
    func value<T>(_ forKey: String, transformDate: (format: String , timeZone: String)? = nil, isMilliseconds: Bool = false) -> T? {
        
        let strValue = data?[forKey] as? String ?? data?[forKey]?.stringValue ?? ""
        
        if T.self == String.self || T.self == Optional<String>.self || T.self == Optional<String>.self {
            return strValue as? T
        }
        
        if T.self == Int.self || T.self == Optional<Int>.self || T.self == Optional<Int>.self {
            if let value = data?[forKey] as? NSNumber { return value.intValue as? T }
            return (strValue as NSString).integerValue as? T
        }
        else if T.self == Date.self || T.self == Optional<Date>.self || T.self == Optional<Date>.self {
            if isNumber(str: strValue)
            {
                return convertDateFrom(timeInterval: (strValue as NSString).doubleValue, isMilliseconds: isMilliseconds) as? T
            }
            
            return getDateFromString(dateStr: strValue, formate: (transformDate?.format)!, timeZone: (transformDate?.timeZone)!) as? T
        }
        else if T.self == Double.self || T.self == Optional<Double>.self || T.self == Optional<Double>.self {
            return data?[forKey]?.doubleValue as? T
        }
        else if T.self == Float.self || T.self == Optional<Float>.self || T.self == Optional<Float>.self {
            return data?[forKey]?.floatValue as? T
        }
        else if T.self == Bool.self  || T.self == Optional<Bool>.self || T.self == Optional<Bool>.self {
            return data?[forKey]?.boolValue as? T
        }
        else if T.self == URL.self  || T.self == Optional<URL>.self || T.self == Optional<URL>.self {
            return URL(string: strValue) as? T
        }
        else if T.self == [AnyObject].self || T.self == Optional<[AnyObject]>.self || T.self == Optional<[AnyObject]>.self {
            return data?[forKey] as? T
        }
        else if T.self == [String: AnyObject].self || T.self == Optional<[String: AnyObject]>.self || T.self == Optional<[String: AnyObject]>.self {
            return data?[forKey] as? T
        }
        
        return nil
    }
    
    private func convertDateFrom(timeInterval: Double, isMilliseconds: Bool = false) -> Date {
        let seconds = isMilliseconds ? (timeInterval / 1000) : timeInterval
        return Date(timeIntervalSince1970: TimeInterval(seconds))
    }
    
    private func getDateFromString(dateStr: String, formate: String, timeZone: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = formate
        
        return dateFormatter.date(from: dateStr)
    }
    
    private func getStringFromDate(date: Date,formate: String, timeZone: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        dateFormatter.dateFormat = formate
        
        return dateFormatter.string(from: date)
    }
    
    private func isNumber(str: String) -> Bool {
        let numberCharacters = NSCharacterSet.decimalDigits.inverted
        return !str.isEmpty && str.rangeOfCharacter(from: numberCharacters) == nil
    }
}

