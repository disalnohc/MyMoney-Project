//
//  AddRegularSubscribeViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 2/5/2567 BE.
//

import UIKit

class AddRegularSubscribeViewController: UIViewController {

    @IBOutlet weak var cycleButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet var categoryImage: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    
    var cycle : String = ""
    var dateStart : String = ""
    var dateEnd : String = "Never"
    var endDate : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupHideKeyboardOnTap(on: self)
        setupDateFormatter()
    }

    class func initVC() -> AddRegularSubscribeViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "AddRegularSubscribeViewController") as! AddRegularSubscribeViewController
        
        return vc
    }

    @IBAction func cycleButtonTap(_ sender: UIButton) {
        let chooseCycleView = ChooseCycle(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
                chooseCycleView.center = self.view.center
                self.view.addSubview(chooseCycleView)
                
                chooseCycleView.onSave = { [weak self] dateSelect , cycle in
                    self?.cycle = cycle
                    print(dateSelect)
                    print(cycle)
                    self?.dateStart = dateSelect
                    if let date = simpleDateFormatter.date(from: dateSelect) {
                        let dayString = onlydayFormatter.string(from: date)
                            self?.cycleButton.setTitle("Every \(cycle) (\(dayString))", for: .normal)
                    } else {
                        self?.cycleButton.setTitle("Every \(cycle).", for: .normal)
                    }
                }
        
                // Display the ChooseDay view
                chooseCycleView.displayChooseDay()
    }
    
    @IBAction func endButtonTap(_ sender: UIButton) {
        
        let chooseEndView = ChooseEnd(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
            chooseEndView.center = self.view.center
            self.view.addSubview(chooseEndView)
            
            chooseEndView.onSave = { [weak self] endSelect in
                guard let self = self else { return }
                
                if endSelect == "Never" {
                    self.dateEnd = "Never"
                    self.endButton.setTitle(endSelect, for: .normal)
                    chooseEndView.removeFromSuperview()
                } else {
                    let chooseCalendarView = SelectDate(frame: UIScreen.main.bounds)
                    chooseCalendarView.center = self.view.center
                    
                    chooseCalendarView.onSelect = { [weak self] selectDate in
                        guard let self = self else { return }
                        print(selectDate)
                        self.dateEnd = selectDate
                        // Handle the selected date, update the button title, etc.
                        self.endButton.setTitle(selectDate, for: .normal)
                        
                        chooseCalendarView.removeFromSuperview()
                    }
                    
                    chooseEndView.removeFromSuperview()
                    self.view.addSubview(chooseCalendarView)
                }
            }
    }
    
    
    @IBAction func categoryButtonTap(_ sender: UIButton) {
        let chooseCategoryView = ChooseCategory(frame: CGRect(x: 0, y: 0, width: 300, height: 450))
                chooseCategoryView.center = self.view.center
                self.view.addSubview(chooseCategoryView)
                chooseCategoryView.setupCollectionView()
        
        chooseCategoryView.onSelect = { [weak self] select , type in
            let typeCategory = type == "income" ? incomeCategory : expensesCategory
            
            if let selectCategory = typeCategory.first(where: { $0.name == select}) {
                self?.categoryImage.image = UIImage(data: selectCategory.image ?? Data())
                self?.nameTextField.text = selectCategory.name
                self?.typeTextField.text = selectCategory.type
            }
        }
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        postRegular()
    }
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}

extension AddRegularSubscribeViewController {
    func postRegular(){
        guard let url = URL(string: "\(ipURL)/insert-regular") else {
            print("Invalid URL")
            return
        }
        var priceDouble : Double = 0.0
        
        if let text = priceTextField.text {
            priceDouble = Double(text) ?? 0.0
        }
        
        if dateEnd == "Never" {
            endDate = "Never"
        } else {
            endDate = dateEnd
        }
        
        if nameTextField.text == "" || priceTextField.text == "" || dateStart == "" {
            createAlert(on: self, message: "Please fill all data.")
        }
                
        let regularData = Regular(
            id : 0, // Auto Increment Column
            username: userName,
            name: nameTextField.text ?? "",
            price: priceDouble,
            start: dateStart,
            end: endDate,
            cycle: cycle,
            type: typeTextField.text ?? "", 
            currentPay: dateStart
        )
        
          print(regularData)
        
        let postData = try! JSONEncoder().encode(regularData)


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                print("SUCCESS")
                regularSubscribe.append(regularData)
                DispatchQueue.main.async {
                    createAlert(on: self, message : "Create New Regular!")
                    NotificationCenter.default.post(name: Notification.Name("RegularDataAdded"), object: nil)
                    self.resetFields()
                }
            } else {
                print(statusCode)
            }
        }

        task.resume()
    }
    
    func resetFields() {
            cycle = ""
            dateStart = ""
            dateEnd = "Never"
            endDate = ""
            nameTextField.text = ""
            typeTextField.text = ""
            priceTextField.text = ""
            cycleButton.setTitle("Select Cycle", for: .normal)
            endButton.setTitle("Select End Date", for: .normal)
            categoryImage.image = UIImage(systemName: "pencil.line")
        }
}
