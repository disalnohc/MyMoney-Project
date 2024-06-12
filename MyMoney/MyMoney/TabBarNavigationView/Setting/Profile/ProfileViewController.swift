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
    
    var editMode : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Profile Setting"
        // Do any additional setup after loading the view.
    }
    
    class func initVC() -> ProfileViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "ProfileViewController") as! ProfileViewController
        
        return vc
    }
    
    @IBAction func saveButtonTap(_ sender: UIButton) {
        if editMode == true {
            editMode = false
            editModeOn()
        } else {
            editMode = true
            editModeOff()
        }
    }
    @IBAction func cancelButtonTap(_ sender: UIButton) {
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
        
    }
}
