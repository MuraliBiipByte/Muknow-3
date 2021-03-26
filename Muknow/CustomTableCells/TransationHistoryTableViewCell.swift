//
//  TransationHistoryTableViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TransationHistoryTableViewCell: UITableViewCell {

    
    @IBOutlet var transactionId: UILabel!
    
    @IBOutlet var transaction_amount: UILabel!
    
    @IBOutlet var transaction_status: UILabel!
    
    @IBOutlet var transaction_date: UILabel!
    
    
    
    // referral history
    
    @IBOutlet var referral_amount: UILabel!
    
    @IBOutlet var referral_id: UILabel!
    
    @IBOutlet var referral_date: UILabel!
    
    
    
    // filter price cell
    @IBOutlet var filterPriceLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
  
    func getTransactionHistoryData() {
        
    }
    
    
    
    
    
    
    
}
