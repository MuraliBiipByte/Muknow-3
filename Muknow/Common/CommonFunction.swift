//
//  CommonFunction.swift
//  Muknow
//
//  Created by Apple on 28/01/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit

class CommonFunctions{
    static let shared = CommonFunctions()
    
    func getCurrentDate()->Date{
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current //TimeZone(identifier: "UTC")
        let currentDateStr = dateFormatter.string(from: currentDate)
        let finalDate = dateFormatter.date(from: currentDateStr)
        return finalDate!
        
    }
    
    func getDateFrom(string:String,format:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current //TimeZone(identifier: "UTC")
        return dateFormatter.date(from: string) ?? Date()
    }
    
    /*
    func getCurrentDateTime()->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let currentDate = dateFormatter.string(from: Date())
        return currentDate
    }*/
//    func getCurrentDateTime()->Date {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
//        dateFormatter.timeZone = TimeZone.current //TimeZone(identifier: "UTC")
//        let currentDate = dateFormatter.string(from: Date())
//        return currentDate
//    }
//    func getCurrentDateTime(format:String)-> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = format
//        dateFormatter.timeZone = TimeZone.current
//        let currentDate = dateFormatter.string(from: Date())
//        return currentDate
//    }
    
    
}
