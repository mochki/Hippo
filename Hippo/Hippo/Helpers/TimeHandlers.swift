//
//  TimeHandlers.swift
//  Hippo
//
//  Created by mochki on 12/5/17.
//  Copyright © 2017 mochki. All rights reserved.
//

import Foundation

// TODO: Handle date formatters throughout the app

// TODO: String parser
fileprivate let taglines:[[String]] = [["It's been like... ", " ", ""], ["Yay, ", " ", "!"], ["Already ", " ", "?!"], ["", " whole ", ""]]

func returnYears(history: [Date]) -> [Int] {
  return Array(Set(history.map { Calendar.current.component(.year, from: $0) }))
}


func toShortMonthName(_ month: Int) -> String {
  switch month {
  case 1:
    return "Jan"
  case 2:
    return "Feb"
  case 3:
    return "Mar"
  case 4:
    return "Apr"
  case 5:
    return "May"
  case 6:
    return "June"
  case 7:
    return "July"
  case 8:
    return "Aug"
  case 9:
    return "Sept"
  case 10:
    return "Oct"
  case 11:
    return "Nov"
  case 12:
    return "Dec"
  default:
    return "___"
  }
}


// This about to be super gross
func timeGapToString(components time: DateComponents) -> String {
  // Destructuring
  let years  = abs(time.year!)
  let months = abs(time.month!)
  let days   = abs(time.day!)
  let hours  = abs(time.hour!)
  let yearsStr  = "\(years) \(years != 1 ? "years" : "year")"
  let monthsStr = "\(months) \(months != 1 ? "months" : "month")"
  let daysStr   = "\(days) \(days != 1 ? "days" : "day")"
  let hoursStr  = "\(hours) \(hours != 1 ? "hours" : "hour")"
  
  if years != 0 {
    if months != 0 {
      return "\(yearsStr) \(monthsStr)"
    } else if days != 0 {
      return "\(yearsStr) \(daysStr)"
    } else if hours != 0 {
      return "\(yearsStr) \(hoursStr)"
    } else {
      return yearsStr
    }
  } else if months != 0 {
    if days != 0 {
      return "\(monthsStr) \(daysStr)"
    } else if hours != 0 {
      return "\(monthsStr) \(hoursStr)"
    } else {
      return monthsStr
    }
  } else if days != 0 {
    if hours != 0 {
      return "\(daysStr) \(hoursStr)"
    } else {
      return daysStr
    }
  } else if hours != 0 {
    return hoursStr
  } else {
    return "0 hours"
  }
}


func prepareDatesForTableView(history dates: [Date]) -> [[[String:String]]] {
  var data = [[[String:String]]]()
  let cal = Calendar.current
  
  var workingYear: Int = -1
  var tempYear: Int = 0
  var workingArray: [[String:String]] = []
  
  for idx in 0..<dates.count {
    tempYear = cal.component(.year, from: dates[idx])
    let components = cal.dateComponents([.month, .day], from: dates[idx])
    let timeGapStr = (idx != dates.count - 1 ? timeGapToString(components: cal.dateComponents([.year, .month, .day, .hour], from: dates[idx], to: dates[idx + 1])) : "")
    
    if workingYear == tempYear {
      workingArray.append([
        "date": "\(toShortMonthName(components.month!)) \(components.day!)",
        "timeGap": timeGapStr
      ])
      if idx == dates.count - 1 {
        data.append(workingArray)
      }
    } else {
      workingYear = tempYear
      if workingArray.count != 0 {
        data.append(workingArray)
      }
      workingArray = [[
        "date": "\(toShortMonthName(components.month!)) \(components.day!)",
        "timeGap": timeGapStr
      ]]
      if idx == dates.count - 1 {
        data.append(workingArray)
      }
    }
  }
  
  return data
}


func toTimeSinceTagline(now: Date, since: Date) -> String{
  let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: since, to: now)
  let years  = components.year!
  let months = components.month!
  let days   = components.day!
  let hours  = components.hour!
  
  let idx = random(taglines.count)
  
  if years != 0 {
    return "\(taglines[idx][0])\(years)\(taglines[idx][1])\(years != 1 ? "years" : "year")\(taglines[idx][2])"
  } else if months != 0 {
    return "\(taglines[idx][0])\(months)\(taglines[idx][1])\(months != 1 ? "months" : "month")\(taglines[idx][2])"
  } else if days != 0 {
    return "\(taglines[idx][0])\(days)\(taglines[idx][1])\(days != 1 ? "days" : "day")\(taglines[idx][2])"
  } else if hours != 0 {
    return "\(taglines[idx][0])\(hours)\(taglines[idx][1])\(hours != 1 ? "hours" : "hour")\(taglines[idx][2])"
  } else {
    // TODO: Come up with more Zero hour phrases
    return "Welcome to zero hour"
  }
}
