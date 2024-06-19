//
//  HistoryViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 3/5/2567 BE.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var collectionHistory: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionHistory.dataSource = self
    }
    
    class func initVC() -> HistoryViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "HistoryViewController") as! HistoryViewController
        
        return vc
    }
}
extension HistoryViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthYear?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hc = collectionView.dequeueReusableCell(withReuseIdentifier: "HistoryCollectionViewCell", for: indexPath) as! HistoryCollectionViewCell
        
        if let mY = monthYear?[indexPath.row] {
            hc.dateLabel.text = "Month : \(mY.yearMonth)"
            hc.incomeLabel.text = "Income : \(demicalNumber(Double(mY.income)))"
            hc.expensesLabel.text = "Expenses : \(demicalNumber(Double(mY.expenses)))"
            hc.bgView.layer.cornerRadius = 20
        }
        return hc
    }
    
    
}
