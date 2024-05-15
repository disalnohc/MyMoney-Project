//
//  AddRegularSubscribeViewController.swift
//  MyMoney
//
//  Created by Chonlasit on 2/5/2567 BE.
//

import UIKit

class AddRegularSubscribeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    class func initVC() -> AddRegularSubscribeViewController {
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(identifier: "AddRegularSubscribeViewController") as! AddRegularSubscribeViewController
        
        return vc
    }

}
