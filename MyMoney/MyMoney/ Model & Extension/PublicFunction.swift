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

public func checkUsernameEmail(_ username: String, _ email: String, completion: @escaping (String) -> Void) {
    guard let url = URL(string: "\(ipURL)/check-user") else {
        print("Invalid URL")
        return 
    }
    
    let Data = checkExist(username: username, email: email)
    
    let checkData = try! JSONEncoder().encode(Data)
    
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = checkData
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
                    print("Error: \(error.localizedDescription)")
                }


        let statusCode = (response as? HTTPURLResponse)?.statusCode
                if statusCode == 200 {
                    if let data = data, let outputString = String(data: data, encoding: .utf8) {
                        completion(outputString)
                    }
                } else if statusCode == 204 {
                    completion("Username and Email Are Avaliable.")
                } else {
                    completion("")
                }
    }
    task.resume()
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
