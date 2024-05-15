//
//  CalendarViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 14/5/2567 BE.
//

import UIKit
import FSCalendar
class CalendarViewController: UIViewController {

    var monthYear : [dateHeader]?
    var statementDataDictionary: [String: [Statement]] = [:]
    @IBOutlet weak var calendarFS: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()

        calendarFS.delegate = self
        calendarFS.dataSource = self
        // Do any additional setup after loading the view.
        getDateRequest()
    }
    

    class func initVC() -> CalendarViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
        
        return vc
    }

    func getDateRequest() {
        guard let url = URL(string: "\(ipURL)/statement-getMonth/\(userName)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
                print("Error : \(error)")
            }
            if let statuscode = response as? HTTPURLResponse {
                // 200 Success
                if statuscode.statusCode == 200 {
                    if let data = data {
                        if let decodedData = try? JSONDecoder().decode([dateHeader].self, from: data) {
                            self.monthYear = decodedData
                            self.getStatementData()
                            print("Decoded Date to monthYear success.")
                        } else {
                        print("Failed to decode JSON data.")
                        }
                    } else {
                        print("Response data is empty.")
                    }
                } else {
                    // Fail
                    print("Received non-200 status code: \(statuscode.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func getStatementData() {
        if let monthYear = monthYear {
            for i in monthYear {
                guard let url = URL(string: "\(ipURL)/statement-getData/\(userName)/\(i.yearMonth)") else {
                    print("Invalid URL")
                    return
                }
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let task = URLSession.shared.dataTask(with: request) { data , response , error in
                    if let error = error {
                        print("Error : \(error)")
                    }
                    if let statuscode = response as? HTTPURLResponse {
                        // 200 Success
                        if statuscode.statusCode == 200 {
                            if let data = data {
                                if let decodedData = try? JSONDecoder().decode([Statement].self, from: data) {
                                    // Add the decoded data to statementDataDictionary
                                    if var statementData = self.statementDataDictionary[i.yearMonth] {
                                        statementData.append(contentsOf: decodedData)
                                        self.statementDataDictionary[i.yearMonth] = statementData
                                    } else {
                                        self.statementDataDictionary[i.yearMonth] = decodedData
                                    }
                                    print("Decoded Statement to Dictionnary success.")
                                } else {
                                    print("Failed to decode JSON data.")
                                }
                            } else {
                                print("Response data is empty.")
                            }
                        } else {
                            // Fail
                            print("Received non-200 status code: \(statuscode.statusCode)")
                        }
                    }
                }
                task.resume()
            }
        }
    }
    }

extension CalendarViewController : FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        var amount = 0.0

        // Ex 2567-05
        let yearMonthFormatter = DateFormatter()
        yearMonthFormatter.dateFormat = "yyyy-MM"
        let yearMonthString = yearMonthFormatter.string(from: date)
        
        // Ex 2567-05-15 17:02:33
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputDateFormatter.calendar = Calendar(identifier: .buddhist)
        
        // Ex 2567-05-15
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd"
        outputDateFormatter.calendar = Calendar(identifier: .buddhist)
        
        // Get Statement in month
        if let statementData = statementDataDictionary[yearMonthString] {
            // Reversed Data
            for statement in statementData.reversed() {
                // Convert String to Date Formatted Input
                if let statementDate = inputDateFormatter.date(from: statement.date) {
                    // Convert Date Input to Formatted Outout
                    let dateString = outputDateFormatter.string(from: statementDate)
                    // Check Date in Calendar = Date Data
                    if outputDateFormatter.string(from: date) == dateString {
                        if statement.type == "income" {
                            amount += Double(statement.amount) ?? 0.0
                        } else {
                            amount -= Double(statement.amount) ?? 0.0
                        }
                    }
                } else {
                    print("Invalid date format: \(statement.date)")
                }
            }
        }
        
        if amount > 0.0 {
            let numberFormatted = NumberFormatter()
            numberFormatted.numberStyle = .decimal
            if let amountFormatted = numberFormatted.string(from: NSNumber(value: amount)) {
                return "\(amountFormatted)\n Item"
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    }
