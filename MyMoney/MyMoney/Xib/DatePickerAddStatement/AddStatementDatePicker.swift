//
//  AddStatementDatePicker.swift
//  MyMoney
//
//  Created by Chonlasit on 24/5/2567 BE.
//

import UIKit

class AddStatementDatePicker: UIView {

    @IBOutlet weak var uiView: UIView!
    
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var onSave: ((_ selectedDateTime: Date) -> Void)?
        var onCancel: (() -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerXIB()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerXIB()
        setupActions()
    }
    
    func registerXIB() {
        if let sb = Bundle.main.loadNibNamed("AddStatementDatePicker", owner: self)?.first as? UIView {
            sb.frame = bounds
            self.addSubview(sb)
        }
    }
    
    private func setupActions() {
            saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        }
    
    @objc private func saveButtonTapped() {
            let selectedDate = datePicker.date
            let selectedTime = timePicker.date
            
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
            let timeComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)
            
            if let finalDate = calendar.date(bySettingHour: timeComponents.hour!, minute: timeComponents.minute!, second: 0, of: selectedDate) {
                onSave?(finalDate)
            }
        }
        
        @objc private func cancelButtonTapped() {
            onCancel?()
        }

}
