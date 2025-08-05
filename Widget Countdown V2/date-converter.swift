//
//  date-converter.swift
//  Widget Countdown V2
//
//  Created by Bradley Cable on 03/08/2025.
//

import Foundation

func dateFormatterHomepage(date: Date) -> (amount: Int, type: String) {
    let calendar = Calendar.current
    let today = calendar.startOfDay(for: Date.now)
    let target = calendar.startOfDay(for: date)

    let now = Date.now
    let absInterval = abs(date.timeIntervalSince(now))

    // If under 1 day, get hours, minutes, seconds
    if absInterval < 86400 {
        let hours = Calendar.current.dateComponents([.hour], from: now, to: date).hour ?? 0
        if abs(hours) >= 1 {
            return (hours, "Hours")
        }
        let minutes = Calendar.current.dateComponents([.minute], from: now, to: date).minute ?? 0
        if abs(minutes) >= 1 {
            return (minutes, "Minutes")
        }
        let seconds = Calendar.current.dateComponents([.second], from: now, to: date).second ?? 0
        return (seconds, "Seconds")
    }

    guard let totalDays = calendar.dateComponents([.day], from: today, to: target).day else {
        return (0, "")
    }

    if abs(totalDays) < 999 {
        return (totalDays, "Days")
    }
    
    // Calculate months difference
    guard let months = calendar.dateComponents([.month], from: today, to: target).month else {
        return (0, "")
    }
    if abs(months) < 999 {
        return (months, "Months")
    }
    
    // Calculate years difference
    guard let years = calendar.dateComponents([.year], from: today, to: target).year else {
        return (0, "")
    }
    return (years, "Years")
}

