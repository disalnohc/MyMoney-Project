//
//  Notification.swift
//  MyMoney
//
//  Created by Chonlasit on 12/6/2567 BE.
//

import Foundation
import UserNotifications
import UIKit

func checkPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
        if granted {
            print("Notification authorization granted")
            NotificationHistory()
            NotificationRegular()
        } else {
            print("Notification authorization denied")
        }
    }
}

func NotificationHistory() {
    var dataMonth = dateHeader(yearMonth: "unknown", income: 0.0, expenses: 0.0)
    if let savedData = userDefaults.data(forKey: "currentMonth") {
        if let currentMonth = try? JSONDecoder().decode(dateHeader.self, from: savedData) {
            dataMonth = currentMonth
        }
    }
    let identify = "History Notic"
    let content = UNMutableNotificationContent()
    content.title = "Summarize"
    content.body = "In the past month, you have income \(demicalNumber(Double(dataMonth.income))) and expenses \(demicalNumber(Double(dataMonth.expenses)))."
    //    print("\(dataMonth.income)" + " " + "\(dataMonth.expenses)")
    content.sound = UNNotificationSound.default
    
    
    var dateComponents = DateComponents()
    dateComponents.calendar = Calendar.current
    dateComponents.day = 1
    
    let trigger = UNCalendarNotificationTrigger(dateMatching:dateComponents, repeats:false)
    
    let request = UNNotificationRequest(identifier: identify, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error.localizedDescription)")
        } else {
            print("Notification scheduled successfully")
        }
    }
}

func NotificationRegular() {
    if let savedData = userDefaults.data(forKey: "regularNoti") {
        if let currentMonth = try? JSONDecoder().decode([RegularNextPay].self, from: savedData) {
            regularNoti = currentMonth
        }
    }
    
    setupDateFormatter()
    let currentDate = simpleDateFormatter.string(from: Date())
    
    for item in regularNoti {
        if item.nextPay == /*"2567-06-18"*/ currentDate {
            let identify = "RegularNotic_\(item.id)"
            let content = UNMutableNotificationContent()
            content.title = "Regular Notification"
            content.body = "Today you have to pay regular \(item.name) with price \(item.price)"
            content.sound = UNNotificationSound.default
            
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                //dateComponents.minute = 39
                dateComponents.hour = 07
                
                //print("Current Date: \(currentDate)")
                //print("Item Next Pay: \(item.nextPay)")
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                
                let request = UNNotificationRequest(identifier: identify, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled successfully for \(item.id) : \(item.name) with price \(item.price) next pay is \(item.nextPay)")
                        updateCurrentPay("\(item.id)", item.nextPay)
                    }
                }
        }
    }
}

func updateCurrentPay(_ id : String , _ date : String) {
    guard let url = URL(string: "\(ipURL)/update-currentPay/\(id)/\(date)") else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        let statusCode = (response as! HTTPURLResponse).statusCode
        if statusCode == 200 {
            print("SUCCESS")
        } else {
            print(statusCode)
        }
    }

    task.resume()
}
