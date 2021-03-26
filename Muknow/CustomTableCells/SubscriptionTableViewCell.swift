//
//  SubscriptionTableViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

  
    
    @IBOutlet var SubscriptionName: UILabel!
    @IBOutlet var SubscriptionAmount: UILabel!
    @IBOutlet var subscriptionValidityMonth: UILabel!
    
    @IBOutlet var payBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
