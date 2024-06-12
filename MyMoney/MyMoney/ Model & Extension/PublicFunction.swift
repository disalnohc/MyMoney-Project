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
    numberFormatted.maximumFractionDigits = 2
    numberFormatted.minimumFractionDigits = 2
    
    if let amountFormatted = numberFormatted.string(from: NSNumber(value: number)) {
            return amountFormatted
        }
        return String(format: "%.2f", number)
}

public func createAlert(on viewController: UIViewController, message: String) {
    let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default)
    
    alert.addAction(ok)
    viewController.present(alert, animated: true)
}

public func setupHideKeyboardOnTap(on viewController : UIViewController) {
    let tapGesture = UITapGestureRecognizer(target: viewController, action: #selector(viewController.hideKeyboard))
    tapGesture.cancelsTouchesInView = false // Allows other touches to pass through to the view
    viewController.view.addGestureRecognizer(tapGesture)
}
    
extension UIViewController {
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
