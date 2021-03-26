//
//  DateExtension.swift
//  Muknow
//
//  Created by Apple on 28/01/21.
//  Copyright © 2021 Admin. All rights reserved.
//

import UIKit
extension Date {
    
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    
    //To get week number and symbol
    func getWeekDaySymbol()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    func getWeekDayNumber()->Int{
        return Calendar.current.component(.weekday, from: self)
    }
    //To add time interval with current date
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    func adding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    //To convert the date to particular format
    
    //To get the number of days in a month or year
    func getNumberOfDaysInMonth()->Int{
        let range = Calendar.current.range(of: .day, in: .month, for: self)!
        return range.count
    }
    func getNumberOfDaysInYear()->Int{
        let range = Calendar.current.range(of: .day, in: .year, for: self)!
        return range.count
    }
    func generateDates(startDate: Date, endDate: Date) -> [String] {

        var calendar = NSCalendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
            let normalizedStartDate = calendar.startOfDay(for: startDate)
            let normalizedEndDate = calendar.startOfDay(for: endDate)

            var dates = [String]()
            let df = DateFormatter()
            df.timeZone = TimeZone(identifier: "UTC")!
            df.dateFormat = "dd-MM-yyyy"
            var currentDate = normalizedStartDate

            repeat {

                currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
                dates.append(df.string(from: currentDate))

            } while !calendar.isDate(currentDate, inSameDayAs: normalizedEndDate)

            return dates
    }

    
}
