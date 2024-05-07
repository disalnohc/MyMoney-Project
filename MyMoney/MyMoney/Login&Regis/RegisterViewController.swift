//
//  RegisterViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 12/4/2567 BE.
//

import UIKit

struct RegisterData : Codable {
    let email : String
    let password : String
    let username : String
    let phone : String
}


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
        guard let url = URL(string: "http://localhost:8080/insert-user") else {
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
                self.createAlert("Create New Account!")
            } else {
                print(statusCode)
            }
        }

        task.resume()
    }
    
    func checkDataField() {
        if (rgUsernameInput.isEmpty) {
           createAlert("Username can't empty.")
        } else if (rgEmailInput.isEmpty) {
           createAlert("Email can't empty.")
        } else if (rgPasswordInput.isEmpty) {
            createAlert("Password can't empty.")
        } else if (rgPhoneInput.isEmpty) {
            createAlert("Phone number can't empty.")
        } else if (rgPasswordInput != rgConfirmPasswordInput) {
            createAlert("Password and Confirm Password doesn't match.")
        } else {
            requestRegister()
        }
    }
    
    public func createAlert(_ message : String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(ok)
        self.present(alert, animated: true)
    }

}
