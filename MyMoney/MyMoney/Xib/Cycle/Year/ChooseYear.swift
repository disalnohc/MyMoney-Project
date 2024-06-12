//
//  ChooseYear.swift
//  MyMoney
//
//  Created by Chonlasit on 28/5/2567 BE.
//

import UIKit

class ChooseYear: UIView {

    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelSummarize: UILabel!
    
    @IBOutlet weak var dateSelect: UIDatePicker!
    var count = 1
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            registerXIB()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            registerXIB()
        }
        
    func registerXIB() {
        if let sb = Bundle.main.loadNibNamed("ChooseYear", owner: self)?.first as? UIView {
            sb.frame = bounds
            labelCount.text = String(count)
            self.addSubview(sb)
        }
    }

    @IBAction func plusTap(_ sender: UIButton) {
        count += 1
        labelCount.text = "\(count)"
        labelSummarize.text = "Cycle every \(count) year."
    }
    
    @IBAction func minusTap(_ sender: UIButton) {
        if count > 1 {
            count -= 1
            labelCount.text = "\(count)"
            labelSummarize.text = "Cycle every \(count) year."
        }
    }
}
