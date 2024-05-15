//
//  RegularSubscribeViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 2/5/2567 BE.
//

import UIKit

class RegularSubscribeViewController: UIViewController {

    @IBOutlet weak var collectionRegular: UICollectionView!
    
    var regularSubscribe : [Regular] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionRegular.dataSource = self
        getRegular()
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
                            self.regularSubscribe = decode
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
    
    
    
}

extension RegularSubscribeViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return regularSubscribe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rc = collectionView.dequeueReusableCell(withReuseIdentifier: "RegularCollectionViewCell", for: indexPath) as! RegularCollectionViewCell
        
        let regular = regularSubscribe[indexPath.row]
        
        rc.nameRegular.text = regular.name
        rc.priceRegular.text = regular.price
        rc.startRegular.text = regular.start
        rc.endRegular.text = regular.end
        rc.viewBackground.layer.cornerRadius = 20
        
        if regular.type == "income" {
            if let category = incomeCategory.first(where: { $0.name == regular.image}){
                rc.imageRegular.image = UIImage(data: category.image ?? Data())
                rc.viewBackground.backgroundColor = .green
            }
        } else {
            if let category = expensesCategory.first(where: { $0.name == regular.image}){
                rc.imageRegular.image = UIImage(data: category.image ?? Data())
                rc.viewBackground.backgroundColor = .red

            }
        }
                
        return rc
    }
    
    
}

