//
//  StatementDateCell.swift
//  MyMoney
//
//  Created by Chonlasit on 17/4/2567 BE.
//

import UIKit

class StatementDateCell: UICollectionViewCell {
    @IBOutlet weak var stateDate: UILabel!
    @IBOutlet weak var stateStatement: UILabel!
    @IBOutlet weak var listStatementCollection: UICollectionView!
    
    @IBOutlet weak var dateView: UIView!
    
    var statementData: [Statement]?
    
}


extension StatementDateCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  statementData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sl = collectionView.dequeueReusableCell(withReuseIdentifier: "StatememtListCell", for: indexPath) as! StatememtListCell
        
        if indexPath.row == 0 {
            sl.listView.clipsToBounds = true
            sl.listView.layer.cornerRadius = 10
            sl.listView.layer.maskedCorners = [.layerMinXMaxYCorner , .layerMaxXMaxYCorner]
        } else {
            sl.listView.layer.cornerRadius = 10
            sl.listView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner] // Fix UI Bug
        }
        if let data = statementData {
                    let statement = data[indexPath.item]
            sl.listAmount.text = demicalNumber(Double(statement.amount) ?? 0.0)
                    sl.listCategory.text = statement.category
            if statement.description == "" {
                sl.listNote.text = "No Note."
            } else {
                sl.listNote.text = statement.description
            }            
            sl.backgroundCategory.layer.cornerRadius = 10
            sl.listTimestamp.text = statement.date
            if statement.type == "income" {
                if let incomeCategoryData = incomeCategory.first(where: { $0.name == statement.category }) {
                    sl.listImage.image = UIImage(data: incomeCategoryData.image ?? Data())
                }
            } else {
                if let expensesCategoryData = expensesCategory.first(where: { $0.name == statement.category }) {
                    sl.listImage.image = UIImage(data: expensesCategoryData.image ?? Data())
                }
            }
            
                }
        
        return sl
    }
    
    
}
