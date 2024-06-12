//
//  ViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 12/4/2567 BE.
//

import UIKit

class LoginViewController: UIViewController {
    
    var userData : UserData?

    var emailInput : String = ""
    var passwordInput : String = ""

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordField: UITextField!
    
    var loadingBGView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupHideKeyboardOnTap(on: self)
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingBGView = UIView(frame: view.bounds)
        loadingBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingBGView.isHidden = true
                view.addSubview(loadingBGView)
                view.bringSubviewToFront(loadingIndicator)
    }

    class func initVC() -> LoginViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "ViewController") as! LoginViewController
        
        return vc
    }
    
    func showLoadingIndicator() {
            loadingBGView.isHidden = false
            loadingIndicator.startAnimating()
        }
        
        func hideLoadingIndicator() {
            loadingBGView.isHidden = true
            loadingIndicator.stopAnimating()
        }
    
    @IBAction func loginButton(_ sender: UIButton) {
        emailInput = emailField.text ?? ""
        passwordInput = passwordField.text ?? ""
        requestLogin()
        showLoadingIndicator()
    }
    
    @IBAction func forgetPasswordTap(_ sender: UIButton) {
        navigationController?.pushViewController(RegisterViewController.initVC(), animated: true)
    }
}

extension LoginViewController {
    
    func requestLogin() {
        guard let url = URL(string: "\(ipURL)/users/\(emailInput)")else{
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data , response , error in
            if let error = error {
                print("Error : \(error)")
            }
            if let statuscode = response as? HTTPURLResponse {
                // 200 Success
                if statuscode.statusCode == 200 {
                    if let data = data {
                        if let personData = try? JSONDecoder().decode(UserData.self, from: data) {
                            self.userData = personData
                            self.userLogin(self.userData!.email, self.userData!.password)
                            userName = self.userData!.username // setUserName
                            userBalance = self.userData!.balance // setAmount
                            userInfo.append(self.userData!)
                            //print(userInfo)
                            DispatchQueue.main.async {
                                self.hideLoadingIndicator()
                            }
                        } else {
                            print("Failed to decode JSON data.")
                        }
                    } else {
                        print("Response data is empty.")
                    }
                } else {
                    // Fail
                    print("Received non-200 status code: \(statuscode.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func userLogin(_ email : String , _ password : String) {
        //print("Email : \(email) , Password : \(password)")
        
        if(email == emailInput && password == passwordInput) {
            //print("LoginSuccess")
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//                    UIApplication.shared.windows.first?.rootViewController = tabBarController
//                    UIApplication.shared.windows.first?.makeKeyAndVisible()
                    tabBarController.modalPresentationStyle = .fullScreen
                    self.navigationController?.present(tabBarController, animated: true)
                }
        } else {
            print("Password not correct")
        }
        
    }
    
}
