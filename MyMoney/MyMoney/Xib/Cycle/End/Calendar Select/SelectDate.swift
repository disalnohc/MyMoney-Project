//
//  SelectDate.swift
//  MyMoney
//
//  Created by Chonlasit on 30/5/2567 BE.
//

import UIKit
import FSCalendar

class SelectDate: UIView, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    var onSelect : ((_ select : String) -> Void)?
    
    override init(frame: CGRect) {
            super.init(frame: frame)
            registerXIB()
            setupCalendar()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            registerXIB()
            setupCalendar()
        }
        
    func registerXIB() {
        if let sb = Bundle.main.loadNibNamed("SelectDate", owner: self)?.first as? UIView {
            sb.frame = bounds
            self.addSubview(sb)
        }
    }
    
    func setupCalendar() {
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formattedDate = simpleDateFormatter.string(from: date)
            onSelect?(formattedDate)
            self.removeFromSuperview()
        }
}


