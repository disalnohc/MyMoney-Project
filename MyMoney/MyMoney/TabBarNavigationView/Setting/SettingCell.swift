//
//  TableViewCell.swift
//  MyMoney
//
//  Created by Chonlasit on 6/6/2567 BE.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var labelSetting: UILabel!
    @IBOutlet weak var imageSetting: UIImageView!

    var click : (() ->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func clicky(_ sender: UIButton) {
        click?()
    }
}
