//
//  RegularCollectionViewCell.swift
//  MyMoney
//
//  Created by Chonlasit on 2/5/2567 BE.
//

import UIKit
import SwipeCellKit

class RegularCollectionViewCell: SwipeCollectionViewCell {
    @IBOutlet weak var imageRegular: UIImageView!
    @IBOutlet weak var nameRegular: UILabel!
    @IBOutlet weak var priceRegular: UILabel!
    @IBOutlet weak var startRegular: UILabel!
    @IBOutlet weak var endRegular: UILabel!
    @IBOutlet weak var cycleRegular: UILabel!
    @IBOutlet weak var viewBackground: UIView!
}
