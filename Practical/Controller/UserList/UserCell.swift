//
//  UserCell.swift
//  Practical
//
//  Created by HariKrishna Kundariya on 14/07/20.
//  Copyright © 2020 HariKrishna Kundariya. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblContact: UILabel!
    @IBOutlet var lblBirth: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var imageData: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageData.layer.cornerRadius = self.imageData.frame.height / 2
        self.imageData.layer.borderWidth = 1.0
        self.imageData.layer.borderColor = UIColor.lightGray.cgColor
        self.imageData.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
