//
//  ChooseCategory.swift
//  MyMoney
//
//  Created by Chonlasit on 30/5/2567 BE.
//

import UIKit

class ChooseCategory: UIView, UICollectionViewDelegate {
    
    
    @IBOutlet weak var segmentSelect: UISegmentedControl!
    
    @IBOutlet weak var collectionCategory: UICollectionView!
    
    var onSelect : ((_ selectCategory : String , _ typeCategory : String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerXIB()
    }
    
    func registerXIB() {
        if let sb = Bundle.main.loadNibNamed("ChooseCategory", owner: self)?.first as? UIView {
            sb.frame = bounds
            self.addSubview(sb)
        }
    }
    
    func setupCollectionView() {
        let nibCell = UINib(nibName: "ChooseCategoryCell", bundle: nil)
        collectionCategory.register(nibCell, forCellWithReuseIdentifier: "ChooseCategoryCell")
        collectionCategory.dataSource = self
        collectionCategory.delegate = self
    }
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        collectionCategory.reloadData()
    }
    
}

extension ChooseCategory : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return segmentSelect.selectedSegmentIndex == 0 ? incomeCategory.count : expensesCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseCategoryCell", for: indexPath) as! ChooseCategoryCell
        
        let category = segmentSelect.selectedSegmentIndex == 0 ? incomeCategory : expensesCategory
        let categoryDisplay = category[indexPath.row]
        cell.label.text = categoryDisplay.name
        cell.image.image = UIImage(data: categoryDisplay.image ?? Data())
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ChooseCategoryCell
        if let selectCell = cell.label.text {
            let typeCategory = segmentSelect.selectedSegmentIndex == 0 ? "income" : "expenses"
            
            onSelect?(selectCell,typeCategory)
            self.removeFromSuperview()
        }
    }
    
}
