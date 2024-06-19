//
//  SettingViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 17/4/2567 BE.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var settingTable: UITableView!
    
    let settingsOptions = ["Profile"]
    let iconSetting = ["person.circle.fill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        settingTable.dataSource = self
        settingTable.delegate = self
    }
    
    func logout() {
        userInfo = []
        userDefaults.removeObject(forKey: "email")
        userDefaults.removeObject(forKey: "password")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        logout()
    }
    
}

extension SettingViewController : UITableViewDataSource , UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        cell.labelSetting?.text = settingsOptions[indexPath.row]
        cell.imageSetting.image = UIImage(systemName: iconSetting[indexPath.row])
                cell.click = {
                        self.navigationController?.pushViewController(ProfileViewController.initVC(), animated: true)
                }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Setting"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(ProfileViewController.initVC(), animated: true)
    }
    
}


