//
//  CategoryViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 23/4/2567 BE.
//

import UIKit
import PieCharts

class SummarizeViewController: UIViewController {
    @IBOutlet weak var chartView: PieChart!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var StatementCollection: UICollectionView!
    
    var filteredStatements: [Statement] = []
    
    var selectedSlice: PieSlice?
    var segmentSelected = "income"
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSummarize()
        segment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        
        // Do any additional setup after loading the view.
        StatementCollection.delegate = self
        StatementCollection.dataSource = self
        
        filterData()
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            segmentSelected = "income"
        } else {
            segmentSelected = "expenses"
        }
        
        filterData()
        
        updateChart()
        StatementCollection.reloadData()
    }
    
}

extension SummarizeViewController {
    func getDataSummarize() {
        guard let url = URL(string: "\(ipURL)/statement-getSummarize/\(userName)") else {
            print("Invalid URL")
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
                        if let decode = try? JSONDecoder().decode([CategorySummarize].self, from: data) {
                            summarizeIncomeCategory = decode.filter { category in
                                return category.type == "income"}
                            summarizeExpensesCategory = decode.filter { category in
                                return category.type == "expenses"}
                            print("Decode Summarize Success.")
                            //                            print("sumIncome ",summarizeIncomeCategory)
                            //                            print("sumExpen" ,summarizeExpensesCategory)
                            DispatchQueue.main.async {
                                self.updateChart()
                            }
                        } else {
                            print("Failed to decode Summarize JSON data.")
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
    
    func filterData() {
        if let data = statementDataDictionary[monthYear?.first?.yearMonth ?? ""] {
            filteredStatements = data.filter { $0.type == segmentSelected }
        }
    }
    
    func updateChart() {
        var selectedCategory: [CategorySummarize] = []
        
        chartView.clear()
        if segmentSelected == "income" {
            selectedCategory = summarizeIncomeCategory
        } else {
            selectedCategory = summarizeExpensesCategory
        }
        
        let textLayerSettings = PiePlainTextLayerSettings()
        textLayerSettings.viewRadius = 75
        textLayerSettings.hideOnOverflow = false
        textLayerSettings.label.font = UIFont.systemFont(ofSize: 12)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        textLayerSettings.label.textGenerator = { slice in
            if ((slice.data.percentage * 100) < 5) {
                return ""
            } else {
                return formatter.string(from: slice.data.percentage * 100 as NSNumber).map { "\($0)%" } ?? ""
            }
        }
        
        let textLayer = PiePlainTextLayer()
        textLayer.settings = textLayerSettings
        
        let viewLayer = PieCustomViewsLayer()
        
        let settings = PieCustomViewsLayerSettings()
        settings.viewRadius = 70
        settings.hideOnOverflow = false
        viewLayer.settings = settings
        
        viewLayer.viewGenerator = { slice, center in
            if ((slice.data.percentage * 100) < 5) {
                let myView = UIView()
                return myView
            } else {
                let myView = UIView(frame: CGRect(x: 0, y: 0, width: self.chartView.bounds.width, height: self.chartView.bounds.height))
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.center = center
                
                if self.segment.selectedSegmentIndex == 0 {
                    if let CategoryData = incomeCategory.first(where: { $0.name == "\(slice.data.model.obj ?? "")" }) {
                        imageView.image = UIImage(data: CategoryData.image ?? Data())
                    }
                } else {
                    if let CategoryData = expensesCategory.first(where: { $0.name == "\(slice.data.model.obj ?? "")" }) {
                        imageView.image = UIImage(data: CategoryData.image ?? Data())
                    }
                }
                
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
                label.font = UIFont.systemFont(ofSize: 18)
                label.textAlignment = .center
                label.textColor = UIColor(hex: "473C33")
                label.text = "\(slice.data.model.obj ?? "")"
                
                let totalHeight = imageView.bounds.height + label.bounds.height
                imageView.center = CGPoint(x: center.x, y: center.y - totalHeight / 2 + imageView.bounds.height / 2)
                label.center = CGPoint(x: center.x, y: imageView.frame.maxY + label.bounds.height / 2)
                
                myView.addSubview(imageView)
                myView.addSubview(label)
                
                return myView
            }
        }
        
        let lineTextLayer = PieLineTextLayer()
        lineTextLayer.settings = PieLineTextLayerSettings()
        lineTextLayer.settings.label.font = UIFont.systemFont(ofSize: 9)
        lineTextLayer.settings.label.textGenerator = { slice in
            let percentage = slice.data.percentage * 100
            if percentage < 5 {
                return formatter.string(from: percentage as NSNumber).map { "\($0)%" } ?? ""
            } else {
                return ""
            }
        }
        lineTextLayer.settings.lineWidth = 1
        lineTextLayer.settings.lineColor = UIColor.clear
        
        
        
        
        chartView.layers = [textLayer, viewLayer, lineTextLayer]
        
        var pieSliceModels: [PieSliceModel] = []
        let backgroundColors: [UIColor?] = [
            UIColor(hex: "#43bc51"),
            UIColor(hex: "#43bc51"),
            UIColor(hex: "#b5594a"),
            UIColor(hex: "#a655aa"),
            UIColor(hex: "#81bf40"),
            UIColor(hex: "#c57c3a"),
            UIColor(hex: "#5a9da5"),
            UIColor(hex: "#b34c5a")
        ]
        
        for (index, data) in selectedCategory.enumerated() {
            if let color = backgroundColors[index % backgroundColors.count] {
                if data.date == monthYear?.first?.yearMonth {
                    let pieSliceModel = PieSliceModel(value: data.amount, color: color, obj: data.category)
                    pieSliceModels.append(pieSliceModel)
                }
            } else {
                print("Warning: Color not available for index \(index)")
            }
        }
        
        chartView.innerRadius = 0
        chartView.strokeColor = .black
        chartView.strokeWidth = 2
        chartView.models = pieSliceModels
        chartView.delegate = self
    }
    
    
}

extension SummarizeViewController: PieChartDelegate {
    func onSelected(slice: PieCharts.PieSlice, selected: Bool) {
        if selected {
            let haveSelected = selectedSlice?.view.selected ?? false
            if haveSelected {
                selectedSlice?.view.selected = false
            }
            if let data = statementDataDictionary[monthYear?.first?.yearMonth ?? ""] {
                filteredStatements = data.filter { $0.category == "\(slice.data.model.obj ?? "")" }
            }
            StatementCollection.reloadData()
            selectedSlice = slice
        } else {
            filterData()
            selectedSlice = nil
            StatementCollection.reloadData()
        }
    }
}

extension SummarizeViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredStatements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cl = collectionView.dequeueReusableCell(withReuseIdentifier: "StatememtListCell", for: indexPath) as! StatememtListCell
        
        cl.listView.layer.cornerRadius = 20
        
        let statement = filteredStatements[indexPath.item]
        
        if statement.type == segmentSelected {
            cl.listCategory.text = statement.category
            if statement.description == "" {
                cl.listNote.text = "No Note."
            } else {
                cl.listNote.text = statement.description
            }
            cl.listTimestamp.text = statement.date
            if statement.type == "income" {
                if let incomeCategoryData = incomeCategory.first(where: { $0.name == statement.category }) {
                    cl.listImage.image = UIImage(data: incomeCategoryData.image ?? Data())
                    cl.listAmount.text = "+ \(demicalNumber(Double(statement.amount) ?? 0.0))"
                    cl.listAmount.textColor = UIColor(hex: "#177245")
                }
            } else {
                if let expensesCategoryData = expensesCategory.first(where: { $0.name == statement.category }) {
                    cl.listImage.image = UIImage(data: expensesCategoryData.image ?? Data())
                    cl.listAmount.text = "- \(demicalNumber(Double(statement.amount) ?? 0.0))"
                    cl.listAmount.textColor = UIColor(hex: "#f93f0b")
                }
            }
        }
        
        
        return cl
    }
    
    
}
