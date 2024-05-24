//
//  UserModel.swift
//  MyMoney
//
//  Created by Chonlasit on 19/4/2567 BE.
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

var monthYear : [dateHeader]?
var statementDataDictionary: [String: [Statement]] = [:] // keep data fetching

var incomeCategory : [CategoryData] = []
var expensesCategory : [CategoryData] = []

var summarizeIncomeCategory : [CategorySummarize] = []
var summarizeExpensesCategory : [CategorySummarize] = []

struct UserData : Codable {
    let id : Int
    let email : String
    let password : String
    let username : String
    let phone : String
    let balance : String
}

struct RegisterData : Codable {
    let email : String
    let password : String
    let username : String
    let phone : String
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
    let price : String
    let start : String
    let end : String
    let image : String
    let type : String
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


