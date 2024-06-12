//
//  RegularSubscribeViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 2/5/2567 BE.
//

import UIKit
import SwipeCellKit

class RegularSubscribeViewController: UIViewController {
    
    @IBOutlet weak var collectionRegular: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        collectionRegular.dataSource = self
        getRegular()
        collectionRegular.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView), name: Notification.Name("RegularDataAdded"), object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("RegularDataAdded"), object: nil)
    }
    
    @objc func reloadCollectionView() {
        collectionRegular.reloadData()
    }
    
    class func initVC() -> RegularSubscribeViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "RegularSubscribeViewController") as! RegularSubscribeViewController
        
        return vc
    }
    
    @IBAction func addRegularButtonTap(_ sender: UIButton) {
        navigationController?.pushViewController(AddRegularSubscribeViewController.initVC(), animated: true)
    }
}

extension RegularSubscribeViewController {
    func getRegular(){
        guard let url = URL(string: "\(ipURL)/regular/\(userName)") else {
            print("Invalid Url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: url) { data , response , error in
            if let error = error {
                print("Error : \(error)")
            }
            
            if let statusCode = response as? HTTPURLResponse {
                if statusCode.statusCode == 200 {
                    if let data = data {
                        if let decode = try? JSONDecoder().decode([Regular].self, from: data) {
                            regularSubscribe = decode
                            DispatchQueue.main.async {
                                self.collectionRegular.reloadData()
                            }
                            print("Decode Regular Success.")
                        } else {
                            print("Failed to decode Category JSON data.")
                        }
                    } else {
                        print("Response data is empty.")
                    }
                } else {
                    print("Received non-200 status code: \(statusCode.statusCode)")
                }
            }
        }
        task.resume()
    }
    
    func deleteItem(_ id: Int) {
        guard let url = URL(string: "\(ipURL)/regular-delete/\(userName)/\(id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            if statusCode == 200 {
                DispatchQueue.main.async {
                    createAlert(on: self, message: "Delete Regular! Success")
                }
            } else {
                DispatchQueue.main.async {
                    createAlert(on: self, message: "Delete Regular! Failed with status code: \(statusCode)")
                }
                print("Failed with status code: \(statusCode)")
            }
        }
        task.resume()
    }

}

extension RegularSubscribeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regularSubscribe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rc = collectionView.dequeueReusableCell(withReuseIdentifier: "RegularCollectionViewCell", for: indexPath) as! RegularCollectionViewCell
        
        let regular = regularSubscribe[indexPath.row]
        
        rc.nameRegular.text = "Name : \(regular.name)"
        rc.startRegular.text = "Start : \(regular.start)"
        rc.endRegular.text = "End : \(regular.end)"
        rc.viewBackground.layer.cornerRadius = 20
        rc.cycleRegular.text = "Cycle : \(regular.cycle)"
        if regular.type == "income" {
            if let category = incomeCategory.first(where: { $0.name == regular.name}){
                rc.imageRegular.image = UIImage(data: category.image ?? Data())
                rc.priceRegular.text = "Price : + \(regular.price)"
            }
        } else {
            if let category = expensesCategory.first(where: { $0.name == regular.name}){
                rc.imageRegular.image = UIImage(data: category.image ?? Data())
                rc.priceRegular.text = "Price : - \(regular.price)"
            }
        }
        rc.delegate = self
        return rc
    }
}

extension RegularSubscribeViewController: SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.handleDeletion(at: indexPath)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return [deleteAction]
    }
    
    func handleDeletion(at indexPath: IndexPath) {
        let deletedItem = regularSubscribe[indexPath.row]
        deleteItem(deletedItem.id)
        regularSubscribe.remove(at: indexPath.row)
        collectionRegular.deleteItems(at: [indexPath])
    }
}


