//
//  PublicFunction.swift
//  MyMoney
//
//  Created by Chonlasit on 22/5/2567 BE.
//

import Foundation
import UIKit

public func demicalNumber(_ number : Double) -> String {
    let numberFormatted = NumberFormatter()
    numberFormatted.numberStyle = .decimal
    
    if let amountFormatted = numberFormatted.string(from: NSNumber(value: number)) {
            return amountFormatted
        }
        return "\(number)"
}

public func createAlert(on viewController: UIViewController, message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default)
    
    alert.addAction(ok)
    viewController.present(alert, animated: true)
}
