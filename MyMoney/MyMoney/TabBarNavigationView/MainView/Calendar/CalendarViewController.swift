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
    }
    

    class func initVC() -> CalendarViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "CalendarViewController") as! CalendarViewController
        
        return vc
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
                    if Calendar.current.isDate(statementDate, equalTo: date, toGranularity: .day) {
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
            return demicalNumber(amount)
            } else {
                return nil
            }
        }
    }
