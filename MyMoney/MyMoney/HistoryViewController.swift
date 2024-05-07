//
//  HistoryViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 3/5/2567 BE.
//

import UIKit

class HistoryViewController: UIViewController {

    var historyData : [History] = []
    
    @IBOutlet weak var collectionHistory: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionHistory.dataSource = self
        getHistory()
    }
    
    class func initVC() -> HistoryViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        
        return vc
    }

    func getHistory() {
        guard let url = URL(string: "http://localhost:8080/history/\(userName)") else {
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
                                if let decode = try? JSONDecoder().decode([History].self, from: data) {
                                    self.historyData = decode
                                    DispatchQueue.main.async {
                                        self.collectionHistory.reloadData()
                                    }
                                    print("Decode Regular Success.")
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

extension HistoryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return historyData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hc = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        
        let hd = historyData[indexPath.row]
        hc.dateLabel.text = "Month : \(hd.date)"
        hc.incomeLabel.text = "Income : \(hd.income)"
        hc.expensesLabel.text = "Expenses : \(hd.expenses)"
        hc.bgView.layer.cornerRadius = 20
        
        return hc
    }
    
    
}
