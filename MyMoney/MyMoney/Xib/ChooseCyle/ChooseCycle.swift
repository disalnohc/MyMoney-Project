//
//  ChooseCycle.swift
//  MyMoney
//
//  Created by Chonlasit on 24/5/2567 BE.
//

import UIKit

class ChooseCycle: UIView {
    
    @IBOutlet var uiView: UIView!
    @IBOutlet weak var segmentSelect: UISegmentedControl!
    
    @IBOutlet weak var viewShowItem: UIView!
    @IBOutlet weak var heightView: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var onSave: ((_ dateSelect: String, _ cycle: String) -> Void)?

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
            uiView.layer.cornerRadius = 10
            self.addSubview(sb)
        }
    }
    
    @IBAction func segmentChange(_ sender: UISegmentedControl) {
        displayChooseDay()
    }
    
    func displayChooseDay() {
            clearSubviews()
            
            if segmentSelect.selectedSegmentIndex == 0 {
                ChooseDaySelect()
            } else if segmentSelect.selectedSegmentIndex == 1 {
                ChooseMonthSelect()
            } else {
                ChooseYearSelect()
            }
        }
        
        func clearSubviews() {
            for subview in viewShowItem.subviews {
                subview.removeFromSuperview()
            }
        }
        
        func ChooseDaySelect() {
            let chooseDayView = ChooseDay(frame: viewShowItem.bounds)
            viewShowItem.addSubview(chooseDayView)
            
            chooseDayView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chooseDayView.topAnchor.constraint(equalTo: viewShowItem.topAnchor),
                chooseDayView.bottomAnchor.constraint(equalTo: viewShowItem.bottomAnchor),
                chooseDayView.leadingAnchor.constraint(equalTo: viewShowItem.leadingAnchor),
                chooseDayView.trailingAnchor.constraint(equalTo: viewShowItem.trailingAnchor)
            ])
            
            heightView.constant = chooseDayView.bounds.height
        }
        
        func ChooseMonthSelect() {
            let chooseMonthView = ChooseMonth(frame: viewShowItem.bounds)
            viewShowItem.addSubview(chooseMonthView)
            
            chooseMonthView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chooseMonthView.topAnchor.constraint(equalTo: viewShowItem.topAnchor),
                chooseMonthView.bottomAnchor.constraint(equalTo: viewShowItem.bottomAnchor),
                chooseMonthView.leadingAnchor.constraint(equalTo: viewShowItem.leadingAnchor),
                chooseMonthView.trailingAnchor.constraint(equalTo: viewShowItem.trailingAnchor)
            ])
            
            heightView.constant = chooseMonthView.bounds.height
        }
        
        func ChooseYearSelect() {
            let chooseYearView = ChooseYear(frame: viewShowItem.bounds)
            viewShowItem.addSubview(chooseYearView)
            
            chooseYearView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chooseYearView.topAnchor.constraint(equalTo: viewShowItem.topAnchor),
                chooseYearView.bottomAnchor.constraint(equalTo: viewShowItem.bottomAnchor),
                chooseYearView.leadingAnchor.constraint(equalTo: viewShowItem.leadingAnchor),
                chooseYearView.trailingAnchor.constraint(equalTo: viewShowItem.trailingAnchor)
            ])
            
            heightView.constant = chooseYearView.bounds.height
        }

    @IBAction func saveTapped(_ sender: UIButton) {
            var date : String = ""
            var cycle : String = ""
        
            if let chooseDayView = viewShowItem.subviews.first as? ChooseDay {
                cycle = "\(chooseDayView.count) day"
                date = simpleDateFormatter.string(from: Date())
            } else if let chooseMonthView = viewShowItem.subviews.first as? ChooseMonth {
                cycle = "\(chooseMonthView.count) month"
                date = simpleDateFormatter.string(from: chooseMonthView.dateSelect.date)
            } else if let chooseYearView = viewShowItem.subviews.first as? ChooseYear {
                cycle = "\(chooseYearView.count) year"
                date = simpleDateFormatter.string(from: chooseYearView.dateSelect.date)
            } else {
                return
            }
            onSave?(date, cycle)
            self.removeFromSuperview()
        }
        
        @IBAction func cancelTapped(_ sender: UIButton) {
            self.removeFromSuperview()
        }
    
    }
