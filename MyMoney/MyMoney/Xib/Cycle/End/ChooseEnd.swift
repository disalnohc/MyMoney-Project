//
//  ChooseEnd.swift
//  MyMoney
//
//  Created by Chonlasit on 30/5/2567 BE.
//

import UIKit

class ChooseEnd: UIView {
    
    @IBOutlet weak var uiView: UIView!
    
    var onSave : ((_ endSelect : String ) -> Void)?

    @IBAction func chooseNerver(_ sender: UIButton) {
        onSave?("Never")
        self.removeFromSuperview()
    }
    @IBAction func chooseSelect(_ sender: UIButton) {
        onSave?("Calendar")
        self.removeFromSuperview()
    }
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            registerXIB()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            registerXIB()
        }
        
    func registerXIB() {
        if let sb = Bundle.main.loadNibNamed("ChooseEnd", owner: self)?.first as? UIView {
            sb.frame = bounds
            uiView.layer.cornerRadius = 10
            self.addSubview(sb)
        }
    }
    
}
