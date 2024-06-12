//
//  RegisterViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 12/4/2567 BE.
//

import UIKit

class RegisterViewController : UIViewController {
    
    var rgUsernameInput : String = ""
    var rgEmailInput : String = ""
    var rgPasswordInput : String = ""
    var rgConfirmPasswordInput : String = ""
    var rgPhoneInput : String = ""
        
    @IBOutlet weak var rgUsernameField: UITextField!
    
    @IBOutlet weak var rgPasswordField: UITextField!
    @IBOutlet weak var rgEmailField: UITextField!
    @IBOutlet weak var rgConfirmPasswordField: UITextField!
    @IBOutlet weak var rgPhoneField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap(on: self)
    }
    
    class func initVC() -> RegisterViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "RegisterViewController") as! RegisterViewController
        
        return vc
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        rgUsernameInput = rgUsernameField.text ?? ""
        rgEmailInput = rgEmailField.text ?? ""
        rgPasswordInput = rgPasswordField.text ?? ""
        rgConfirmPasswordInput = rgConfirmPasswordField.text ?? ""
        rgPhoneInput = rgPhoneField.text ?? ""
        checkDataField()
    }
    
}

extension RegisterViewController {
    func requestRegister() {
        guard let url = URL(string: "\(ipURL)/insert-user") else {
            print("Invalid URL")
            return
        }
        
        let registerData = RegisterData(
            email: rgEmailInput,
            password: rgPasswordInput,
            username: rgUsernameInput,
            phone: rgPhoneInput
        )
        
        let postData = try! JSONEncoder().encode(registerData)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                print("SUCCESS")
                createAlert(on: self, message : "Create New Account!")
            } else {
                print(statusCode)
            }
        }

        task.resume()
    }
    
    func checkDataField() {
        if (rgUsernameInput.isEmpty) {
           createAlert(on: self, message: "Username can't empty.")
        } else if (rgEmailInput.isEmpty) {
            createAlert(on: self, message: "Email can't empty.")
        } else if (rgPasswordInput.isEmpty) {
            createAlert(on: self, message: "Password can't empty.")
        } else if (rgPhoneInput.isEmpty) {
            createAlert(on: self, message: "Phone number can't empty.")
        } else if (rgPasswordInput != rgConfirmPasswordInput) {
            createAlert(on: self, message: "Password and Confirm Password doesn't match.")
        } else {
            requestRegister()
        }
    }

}
