//
//  UserModel.swift
//  MyMoney
//
//  Created by Chonlasit on 19/4/2567 BE.
//

import Foundation

let userDefaults = UserDefaults.standard

var monthYear : [dateHeader]?
var statementDataDictionary: [String: [Statement]] = [:] // keep data fetching

var incomeCategory : [CategoryData] = []
var expensesCategory : [CategoryData] = []

var summarizeIncomeCategory : [CategorySummarize] = []
var summarizeExpensesCategory : [CategorySummarize] = []

var regularSubscribe : [Regular] = []

var userInfo : [UserData] = []
var regularNoti : [RegularNextPay] = []

struct UserData : Codable {
    let id : Int
    var email : String
    var password : String
    var username : String
    var phone : String
    var balance : String
}

struct RegisterData : Codable {
    let email : String
    let password : String
    let username : String
    let phone : String
    let balance : String
}

struct Statement: Codable {
    let id: Int
    let username: String
    let amount: String
    let description: String
    let type: String
    let category: String
    let date: String
}

struct StatememtData : Codable {
    let username : String
    let amount : String
    let description : String
    let type : String
    let category : String
    let date : String
}

struct dateHeader : Codable {
    let yearMonth : String
    let income : Double
    let expenses : Double
}

struct CategoryData : Codable {
    let username : String
    let name : String
    let bgcolor : String
    let type : String
    let image : Data?
}

struct form : Codable {
    let categoryData : String
    let image : Data
}

struct Regular : Codable {
    let id : Int
    let username : String
    let name : String
    let price : Double
    let start : String
    let end : String
    let cycle : String
    let type : String
    let currentPay : String
}

struct History : Codable {
    let id : Int
    let username : String
    let date : String
    let income : String
    let expenses : String
}

struct CategorySummarize : Codable {
    let category : String
    let type : String
    let amount : Double
    let date : String
}

struct checkExist : Codable {
    let username : String
    let email : String
}

struct OutputString : Codable {
    let message : String
}

struct RegularNextPay : Codable {
    let id : Int
    let username : String
    let name : String
    let price : Double
    let start : String
    let end : String
    let cycle : String
    let type : String
    let currentPay : String
    let nextPay : String
    let pay : String
}
