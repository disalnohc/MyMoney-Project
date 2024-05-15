//
//  StatememtListCell.swift
//  MyMoney
//
//  Created by Chonlasit on 17/4/2567 BE.
//

import UIKit

class StatememtListCell: UICollectionViewCell {
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var backgroundCategory: UIView!
    
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var listCategory: UILabel!
    @IBOutlet weak var listNote: UILabel!
    @IBOutlet weak var listAmount: UILabel!
    @IBOutlet weak var listTimestamp: UILabel!
}

