//
//  AddStatementViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 18/4/2567 BE.
//

import UIKit

class AddStatementViewController: UIViewController {
    
    var selectedIndexPath: IndexPath?
    
    var amount : String = ""
    let dateFormatter = DateFormatter()
    var dateString : String = ""
    
    var ImageChange : Bool = false
            
    var datePicker : UIDatePicker!
    
    @IBOutlet weak var insertImage: UIImageView!
    @IBOutlet weak var AmountField: UITextField!
    @IBOutlet weak var NoteField: UITextField!
    
    @IBOutlet weak var segmentSelect: UISegmentedControl!
    @IBOutlet weak var minusView: UIView!
    
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Date String
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDate = Date()
        dateString = dateFormatter.string(from: currentDate)
        
        //datasource
        categoryCollection.dataSource = self
        categoryCollection.delegate = self
        
    }
    
    class func initVC() -> AddStatementViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "AddStatementViewController") as! AddStatementViewController
        
        return vc
    }
    
    @IBAction func buttonCloseTap(_ sender: UIButton) {
        closeView()
    }
    
    // Button Tap Field
    
    // MARK: Number Field
    @IBAction func buttonOneTap(_ sender: UIButton) {
        amount.append("1")
        AmountField.text = amount
    }
    @IBAction func buttonTwoTap(_ sender: UIButton) {
        amount.append("2")
        AmountField.text = amount
    }
    @IBAction func buttonThreeTap(_ sender: UIButton) {
        amount.append("3")
        AmountField.text = amount
    }
    @IBAction func buttonFourTap(_ sender: UIButton) {
        amount.append("4")
        AmountField.text = amount
    }
    @IBAction func buttonFiveTap(_ sender: UIButton) {
        amount.append("5")
        AmountField.text = amount
    }
    @IBAction func buttonSixTap(_ sender: UIButton) {
        amount.append("6")
        AmountField.text = amount
    }
    @IBAction func buttonSevenTap(_ sender: UIButton) {
        amount.append("7")
        AmountField.text = amount
    }
    @IBAction func buttonEightTap(_ sender: UIButton) {
        amount.append("8")
        AmountField.text = amount
    }
    @IBAction func buttonNineTap(_ sender: UIButton) {
        amount.append("9")
        AmountField.text = amount
    }
    @IBAction func buttonZeroTap(_ sender: UIButton) {
        amount.append("0")
        AmountField.text = amount
    }
    @IBAction func buttonDotTap(_ sender: UIButton) {
        amount.append(".")
        AmountField.text = amount
    }
    @IBAction func buttonDoubleZeroTap(_ sender: UIButton) {
        amount.append("00")
        AmountField.text = amount
    }
    
    
    // MARK: - Button Action
    @IBAction func buttonPlusTap(_ sender: UIButton) {
        if ( !amount.isEmpty) {
            amount.append("+")
            AmountField.text = amount
            insertImage.image = UIImage(named: "equal")
            ImageChange = true
        }
    }
    @IBAction func buttonMinusTap(_ sender: UIButton) {
        if ( !amount.isEmpty) {
            amount.append("-")
            AmountField.text = amount
            insertImage.image = UIImage(named: "equal")
            ImageChange = true
        }
    }
    @IBAction func buttonRemoveTap(_ sender: UIButton) {
        if (!amount.isEmpty) {
            let lastCharacter = amount.last
            
            if lastCharacter == "+" || lastCharacter == "-" {
                insertImage.image = UIImage(named: "checked")
                ImageChange = false
            }
            
            amount.removeLast()
            AmountField.text = amount
        }
    }
    @IBAction func buttonClearTap(_ sender: UIButton) {
        clearField()
    }
    @IBAction func CalendatBuutonTap(_ sender: UIButton) {
        // Create the alert controller
            let alertController = UIAlertController(title: "Select Date and Time", message: nil, preferredStyle: .alert)
            
            // Create the date picker
            let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
            datePicker.datePickerMode = .dateAndTime
            datePicker.preferredDatePickerStyle = .compact
            
            // Add the date picker to the alert controller
            alertController.view.addSubview(datePicker)
            
            // Add constraints to the date picker to center it within the alert
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
                datePicker.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 50),
                datePicker.widthAnchor.constraint(equalToConstant: 250),
                datePicker.heightAnchor.constraint(equalToConstant: 150)
            ])
            
            // Add OK and Cancel actions
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle the date selected
                let selectedDate = datePicker.date
                print("Selected date: \(selectedDate)")
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // Present the alert controller
            present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func butonInsertOneTap(_ sender: UIButton) {
        if (ImageChange == true) {
            calculate()
        } else {
            postStatement { finish in
                if finish {
                        self.closeView()
                }
            }
        }
    }
    @IBAction func buttonInsertManyTap(_ sender: UIButton) {
        if (ImageChange == true) {
            calculate()
            postStatement { success in
                if success {
                    DispatchQueue.main.async {
                        self.clearField()
                    }
                }
            }
        } else {
            postStatement { success in
                if success {
                    DispatchQueue.main.async {
                        self.clearField()
                    }
                }
            }
        }
    }
    
    // MARK: Segment
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        if let selectedIndexPath = selectedIndexPath,
               let selectedCell = categoryCollection.cellForItem(at: selectedIndexPath) as? StatementCategoryCell {
                selectedCell.bgView.layer.borderColor = UIColor.clear.cgColor
                selectedCell.bgView.layer.borderWidth = 0.0
            }
            
        selectedIndexPath = nil
        categoryCollection.reloadData()
    }
}

extension AddStatementViewController {
    
    func postStatement(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(ipURL)/insert-statement") else {
            print("Invalid URL")
            completion(false)
            return
        }

        // not select category
        guard selectedIndexPath != nil else {
            print("No category selected")
            completion(false)
            return
        }

        let categoryName = segmentSelect.selectedSegmentIndex == 0 ? incomeCategory[selectedIndexPath!.row].name : expensesCategory[selectedIndexPath!.row].name

        let formatAmount = String(format: "%.2f", Double(amount)!)

        let selectedSegmentIndex = segmentSelect.selectedSegmentIndex

        let type: String
        if selectedSegmentIndex == 0 {
            type = "income"
        } else {
            type = "expenses"
        }

        let statementData = StatememtData(
            username: userName,
            amount: formatAmount,
            description: NoteField.text ?? "",
            type: type,
            category: categoryName,
            date: dateString
        )

        let postData = try! JSONEncoder().encode(statementData)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Add Statement Success")
                self.updateBalance(type: type) { success in
                    completion(success)
                }
            } else {
                print("Error: Server returned an error.")
                completion(false)
            }
        }

        task.resume()
    }

    func updateBalance(type: String, completion: @escaping (Bool) -> Void) {
        var url: URL?
        if type == "income" {
            url = URL(string: "\(ipURL)/update-PlusBalance/\(userName)")
        } else {
            url = URL(string: "\(ipURL)/update-MinusBalance/\(userName)")
        }

        guard let url = url else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        let boundary = "Boundary-\(UUID().uuidString)"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        var requestBody = Data()
        request.httpMethod = "PUT"

        requestBody.append("--\(boundary)\r\n")
        requestBody.append("Content-Disposition: form-data; name=\"amount\"\r\n\r\n")
        requestBody.append("\(amount)\r\n")
        requestBody.append("--\(boundary)--\r\n")

        request.httpBody = requestBody
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }

            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                print("Update Balance Success")
                if let balance = Double(userBalance), let amountDouble = Double(self.amount) {
                    if type == "income" {
                        userBalance = String(balance + amountDouble)
                    } else {
                        userBalance = String(balance - amountDouble)
                    }
                }
                completion(true)
            } else {
                print("Error: Server returned an error.")
                completion(false)
            }
        }
        task.resume()
    }
    
    func closeView() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    func clearField() {
        amount = ""
        AmountField.text = amount
        NoteField.text = ""
        
        if let prevIndexPath = selectedIndexPath,
           let prevSelectedCell = categoryCollection.cellForItem(at: prevIndexPath) as? StatementCategoryCell {
            prevSelectedCell.bgView.layer.borderColor = UIColor.clear.cgColor
            prevSelectedCell.bgView.layer.borderWidth = 0.0
        }
        
        selectedIndexPath = nil
    }
    
    func calculate() {
        let mathString = amount
        
        if let expression = NSExpression(format: mathString) as? NSExpression {
            if let result = expression.expressionValue(with: nil, context: nil) as? NSNumber {
                amount = "\(result.floatValue)"
                AmountField.text = amount
                insertImage.image = UIImage(named: "checked")
                ImageChange = false
            } else {
                print("Invalid expression")
            }
        } else {
            print("Invalid expression")
        }
    }
}

    extension AddStatementViewController : UICollectionViewDataSource , UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return segmentSelect.selectedSegmentIndex == 0 ? incomeCategory.count : expensesCategory.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cateCell = collectionView.dequeueReusableCell(withReuseIdentifier: "StatementCategoryCell", for: indexPath) as! StatementCategoryCell
            
            let category = segmentSelect.selectedSegmentIndex == 0 ? incomeCategory : expensesCategory
            let categoryDisplay = category[indexPath.row]
            cateCell.categoryImage.image = UIImage(data: categoryDisplay.image ?? Data())
            cateCell.categoryLabel.text = categoryDisplay.name
            cateCell.backgroundCategory.backgroundColor = .init(hex: categoryDisplay.bgcolor)
            
            cateCell.backgroundCategory.layer.cornerRadius = 10

            cateCell.cellViewWidth.constant = (categoryCollection.frame.width / 3) - 10
            cateCell.cellViewHeight.constant = (categoryCollection.frame.height / 3 ) - 8
            
            return cateCell
        }
        
        // MARK: Selected Item
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let prevIndexPath = selectedIndexPath,
               let prevSelectedCell = collectionView.cellForItem(at: prevIndexPath) as? StatementCategoryCell {
                prevSelectedCell.bgView.layer.borderColor = UIColor.clear.cgColor
                prevSelectedCell.bgView.layer.borderWidth = 0.0
            }
            
            // Set border color for newly selected item
            let selectedCell = collectionView.cellForItem(at: indexPath) as? StatementCategoryCell
            selectedCell?.bgView.layer.borderColor = UIColor.green.cgColor
            selectedCell?.bgView.layer.borderWidth = 4.0
            selectedCell?.bgView.layer.cornerRadius = 20
            
            // Update selectedIndexPath
            selectedIndexPath = indexPath
        }
    }
