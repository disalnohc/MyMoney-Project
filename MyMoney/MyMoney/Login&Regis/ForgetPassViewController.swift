//
//  ForgetPassViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 13/6/2567 BE.
//

import UIKit

class ForgetPassViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupHideKeyboardOnTap(on: self)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    class func initVC() -> ForgetPassViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "ForgetPassViewController") as! ForgetPassViewController
        
        return vc
    }
    

    @IBAction func checkButton(_ sender: UIButton) {
        checkEmailPhone()
    }
    
    func checkEmailPhone() {
        guard let url = URL(string: "\(ipURL)/findemail-phone") else {
            print("Invalid URL")
            return
        }
        
        let checkData = [
            "email" : emailTextField.text ?? "",
            "phone" : phoneTextField.text ?? ""
        ]
        
        let postData = try! JSONEncoder().encode(checkData)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR : \(error)")
            }
            
            let statusCode = response as! HTTPURLResponse
            if statusCode.statusCode == 200 {
                print("SUCCESS")
                DispatchQueue.main.async {
                    let st = UIStoryboard(name: "Main", bundle: nil)
                    let vc = st.instantiateViewController(identifier: "ChangePassword") as! ChangePassword
                    vc.email = self.emailTextField.text ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                print(statusCode)
            }
        }

        task.resume()
    }
    
}
