//
//  ChangePassword.swift
//  MyMoney
//
//  Created by Chonlasit on 18/6/2567 BE.
//

import UIKit

class ChangePassword: UIViewController {

    var email : String = ""
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var confirmpassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func initVC() -> ChangePassword {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "ChangePassword") as! ChangePassword
        
        return vc
    }

    @IBAction func changePassword(_ sender: UIButton) {
        var pass = passwordTextField.text ?? ""
        var confirm = confirmpassword.text ?? ""
        
        if pass == confirm {
            changePassword()
        } else {
            createAlert(on: self, message: "Password and Confirm password not match.")
        }
    }
    
    func changePassword() {
        guard let url = URL(string: "\(ipURL)/updatepassword") else {
            print("Invalid URL")
            return
        }
        
        let checkData = [
            "email" : email,
            "password" : passwordTextField.text ?? ""
        ]
        
        let postData = try! JSONEncoder().encode(checkData)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                print("SUCCESS")
                DispatchQueue.main.async {
                    createAlert(on: self, message: "Change Password Success.")
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                print(statusCode)
            }
        }

        task.resume()
    }
}
