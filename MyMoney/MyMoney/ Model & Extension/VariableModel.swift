//
//  VariableModel.swift
//  MyMoney
//
//  Created by Chonlasit on 31/5/2567 BE.
//

import Foundation

var userName : String = ""
var userBalance : String = ""
var userIncome : String = ""
var userExpenses : String = ""

// Check Device and Change IP
#if targetEnvironment(simulator)
var ipURL = "http://localhost:8080" // Simulator Test
#else
var ipURL = "http://172.20.10.4:8080" // Device Test
#endif

let simpleDateFormatter = DateFormatter()
let fullDateFormatter = DateFormatter()
let isoDateFormatter = DateFormatter()
let onlydayFormatter = DateFormatter()
let yearMonthFormatter = DateFormatter()

func setupDateFormatter() {
    simpleDateFormatter.dateFormat = "yyyy-MM-dd"
    simpleDateFormatter.calendar = Calendar(identifier: .buddhist)
    simpleDateFormatter.locale = Locale(identifier: "th_TH")
    
    fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    fullDateFormatter.locale = Locale(identifier: "th_TH")
    
    isoDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    isoDateFormatter.calendar = Calendar(identifier: .buddhist)
    isoDateFormatter.locale = Locale(identifier: "th_TH")
    
    onlydayFormatter.dateFormat = "dd"
    onlydayFormatter.calendar = Calendar(identifier: .buddhist)
    onlydayFormatter.locale = Locale(identifier: "th_TH")
    
    yearMonthFormatter.dateFormat = "yyyy-MM"
    yearMonthFormatter.calendar = Calendar(identifier: .buddhist)
    yearMonthFormatter.locale = Locale(identifier: "th_TH")
}
