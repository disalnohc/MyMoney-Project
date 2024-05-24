//
//  ChooseCycle.swift
//  MyMoney
//
//  Created by Chonlasit on 24/5/2567 BE.
//

import UIKit

class ChooseCycle: UIView {

    @IBOutlet weak var segmentSelected: UISegmentedControl!
    
    @IBOutlet weak var viewShowItem: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerXIB()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerXIB()
    }
    
    func registerXIB() {
        if let sb = Bundle.main.loadNibNamed("ChooseCycle", owner: self)?.first as? UIView {
            sb.frame = bounds
            self.addSubview(sb)
        }
    }

}
