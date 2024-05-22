//
//  CategoryViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 23/4/2567 BE.
//

import UIKit
import PieCharts

class CategoryViewController: UIViewController {
    @IBOutlet weak var chartView: PieChart!
    @IBOutlet weak var segment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataSummarize()
        segment.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)

        // Do any additional setup after loading the view.
    }

    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        updateChart()
        }

}

extension CategoryViewController {
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
    
    func updateChart() {
        var selectedCategory: [CategorySummarize]
        selectedCategory = []
        
        chartView.clear()
        if segment.selectedSegmentIndex == 0 {
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

        viewLayer.viewGenerator = {slice, center in
            if ((slice.data.percentage * 100) < 5) {
                let myView = UIView()
                
                return myView
            } else {
                let myView = UIView(frame: CGRect(x: 0, y: 0, width: self.chartView.bounds.width, height: self.chartView.bounds.height))
                // add images, animations, etc.
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
                    label.textColor = .black
                    label.textAlignment = .center
                    label.text = "\(slice.data.model.obj ?? "")"

                    let totalHeight = imageView.bounds.height + label.bounds.height
                    imageView.center = CGPoint(x: center.x, y: center.y - totalHeight / 2 + imageView.bounds.height / 2)
                    label.center = CGPoint(x: center.x, y: imageView.frame.maxY + label.bounds.height / 2)

                    myView.addSubview(imageView)
                    myView.addSubview(label)

                return myView
            }
        }
        
        chartView.layers = [textLayer , viewLayer]

        var pieSliceModels: [PieSliceModel] = []
        
        
        
        for data in selectedCategory {
            let randomColor = UIColor(red: CGFloat.random(in: 0...1),
                                       green: CGFloat.random(in: 0...1),
                                       blue: CGFloat.random(in: 0...1),
                                       alpha: 1.0)
            if data.date == monthYear?.first?.yearMonth {
                let pieSliceModel = PieSliceModel(value: data.amount, color: randomColor , obj: data.category)
                pieSliceModels.append(pieSliceModel)
            }
        }

        chartView.models = pieSliceModels

    }
}
