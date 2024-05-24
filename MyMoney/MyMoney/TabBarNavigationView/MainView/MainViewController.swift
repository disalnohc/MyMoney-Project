//
//  MainViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 17/4/2567 BE.
//

import UIKit
import FSCalendar
class MainViewController: UIViewController {

    @IBOutlet weak var statementCollection: UICollectionView!
    
    //view
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var regularView: UIView!
    @IBOutlet weak var categoryView: UIView!
    
    @IBOutlet weak var walletView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var expensesAmount: UILabel!
    @IBOutlet weak var incomeAmount: UILabel!
    @IBOutlet weak var balanceAmount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statementCollection.delegate = self
        statementCollection.dataSource = self
        
        statementCollection.reloadData()
        
        getDateRequest()
                
        historyView.layer.cornerRadius = 10
        calendarView.layer.cornerRadius = 10
        categoryView.layer.cornerRadius = 10
        regularView.layer.cornerRadius = 10
        walletView.layer.cornerRadius = 10
        
        userNameLabel.text = "Username : \(userName)"
        balanceAmount.text = String(demicalNumber(Double(userBalance) ?? 0.0))

        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideCalendar))
//            self.view.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    class func initVC() -> MainViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "MainViewController") as! MainViewController
        
        return vc
    }
    
    @IBAction func buttonInsertTap(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "AddStatementViewController") as! AddStatementViewController
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
        }
    }
    
    @IBAction func buttonCategoryTap(_ sender: UIButton) {
        navigationController?.pushViewController(AddCategoryViewController.initVC(), animated: true)
    }
    
    @IBAction func buttonRegularTap(_ sender: UIButton) {
        navigationController?.pushViewController(RegularSubscribeViewController.initVC(), animated: true)
    }
    @IBAction func buttonHistoryTap(_ sender: UIButton) {
        navigationController?.pushViewController(HistoryViewController.initVC(), animated: true)
    }
    
    @IBAction func buttonCalendarTap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let calendarController = storyboard.instantiateViewController(withIdentifier: "CalendarViewController") as! CalendarViewController
        
        calendarController.statementDataDictionary = statementDataDictionary
        calendarController.monthYear = monthYear
        
        calendarController.modalPresentationStyle = .formSheet
        navigationController?.present(calendarController, animated: true)
        
    }
}

extension MainViewController {
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
                            monthYear = decodedData
                            DispatchQueue.main.async {
                                self.incomeAmount.text = "\(String(demicalNumber(Double(monthYear?.first?.income ?? 0.0))))"
                                self.expensesAmount.text = "\(String(demicalNumber(Double(monthYear?.first?.expenses ?? 0.0))))"
                            }
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
                                    statementDataDictionary[i.yearMonth] = decodedData
                                    self.getCategoryData()
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
    
    func getCategoryData() {
        
        guard let url = URL(string: "\(ipURL)/category/\(userName)") else {
            print("Invalid Url")
            return
        }
            
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url) { data , response , error in
            if let error = error {
                print("Error : \(error)")
            }
            
            if let statusCode = response as? HTTPURLResponse {
                if statusCode.statusCode == 200 {
                    if let data = data {
                        if let decode = try? JSONDecoder().decode([CategoryData].self, from: data) {
                            
                            incomeCategory = decode.filter { category in
                                return category.type == "income"}
                            expensesCategory = decode.filter { category in
                                return category.type == "expenses"}
//                            print("income : \(incomeCategory)")
//                            print("expense : \(expensesCategory)")
                            DispatchQueue.main.async {
                                self.statementCollection.reloadData()
                            }
                            print("Decode Category Success.")
                        } else {
                            print("Failed to decode Category JSON data.")
                        }
                    } else {
                        print("Response data is empty.")
                    }
                } else {
                    print("Received non-200 status code: \(statusCode.statusCode)")
                }
            }
        }
        task.resume()
    }
}

extension MainViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthYear?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let sd = collectionView.dequeueReusableCell(withReuseIdentifier: "StatementDateCell", for: indexPath) as! StatementDateCell
        
        if let monthYear = monthYear {
            sd.stateDate.text = monthYear[indexPath.row].yearMonth
            let income = String(format: "%.2f", monthYear[indexPath.row].income)
            let expenses = String(format: "%.2f", monthYear[indexPath.row].expenses)
            sd.stateStatement.text = "Income: \(income) , Expenses: \(expenses)"
            sd.statementData = statementDataDictionary[monthYear[indexPath.row].yearMonth]
            sd.listStatementCollection.reloadData()
        }
        sd.dateView.clipsToBounds = true
        sd.dateView.layer.cornerRadius = 10
        sd.dateView.layer.maskedCorners = [.layerMinXMinYCorner , .layerMaxXMinYCorner]
            sd.listStatementCollection.dataSource = sd
            
            return sd
    }

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width 
        let cellHeight: CGFloat = 85
        
        if let monthYear = monthYear, let statementData = statementDataDictionary[monthYear[indexPath.row].yearMonth], !statementData.isEmpty {
            let dataCount = CGFloat(statementData.count)
            let totalHeight = (dataCount * cellHeight) + 30
            return CGSize(width: cellWidth, height: totalHeight)
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
