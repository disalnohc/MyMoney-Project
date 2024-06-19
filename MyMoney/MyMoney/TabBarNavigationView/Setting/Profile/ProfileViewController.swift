//
//  ProfileViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 6/6/2567 BE.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var confirmpasswordTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var password : String = ""
    var conpassword : String = ""
    var phone : String = ""
    var username : String = ""
    var email : String = ""
    
    
    var editMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile Setting"
        // Do any additional setup after loading the view.
        emailTextField.text = userInfo[0].email
        usernameTextField.text = userInfo[0].username
        phoneTextField.text = userInfo[0].phone
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    class func initVC() -> ProfileViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        
        return vc
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        if editMode == false {
            editMode = true
            editModeOn()
        } else {
            editMode = false
            editModeOff()
            checkPassword()
        }
    }
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        editMode = false
        editModeOff()
    }
    
}

extension ProfileViewController {
    func editModeOff() {
        saveButton.setTitle("Edit", for: .normal)
        cancelButton.setTitle("Back", for: .normal)
    }
    
    func editModeOn() {
        saveButton.setTitle("Save", for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
    }
    
    func updateUserData() {
        guard let url = URL(string: "\(ipURL)/update-password") else {
            print("Invalid URL")
            return
        }
        
        var usersData = [
            "email": email,
            "password": password,
            "username": userName,
            "newUsername" : username,
            "phone": phone,
            "balance": userBalance
        ]
        
        let postData = try! JSONEncoder().encode(usersData)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = postData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                userName = self.username
                if let index = userInfo.firstIndex(where: { $0.username == "sss" }) {
                    // User found, now update the user data
                    userInfo[index].email = self.email
                    userInfo[index].password = self.password
                    userInfo[index].phone = self.phone
                    userInfo[index].username = self.username
                    print("Updated user: \(userInfo[index])")
                }
                
                DispatchQueue.main.async {
                    createAlert(on: self, message : "Update User Success.")
                }
            } else {
                print(statusCode)
            }
        }
        
        task.resume()
    }
    
    func checkPassword() {
        email = emailTextField.text ?? ""
        username = usernameTextField.text ?? ""
        password = passwordTextField.text ?? ""
        conpassword = confirmpasswordTextField.text ?? ""
        phone = phoneTextField.text ?? ""
        
        if (email != "" || username != "" || password != "" || conpassword != "" || phone != "") {
            if password == conpassword {
                checkUsernameEmail(username, email) { result in
                    if result == "Username and Email Are Avaliable." {
                        self.updateUserData()
                    } else {
                        DispatchQueue.main.async {
                            createAlert(on: self, message: result)
                        }
                    }
                }
            }
        }
    }
}
