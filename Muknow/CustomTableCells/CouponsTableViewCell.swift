//
//  CouponsTableViewCell.swift
//  Muknow
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CouponsTableViewCell: UITableViewCell {

    
    
    @IBOutlet var couponCodeTxt: UILabel!
    
    @IBOutlet var couponDesc: UILabel!
    
    @IBOutlet var couponValidity: UILabel!
    
    @IBOutlet var discountPercentage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
