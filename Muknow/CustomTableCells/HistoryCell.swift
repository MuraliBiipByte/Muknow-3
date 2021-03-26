//
//  HistoryCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    
    @IBOutlet var courseImg: UIImageView!
    @IBOutlet var courseNameLbl: UILabel!
    
    @IBOutlet var bookingId: UILabel!
    
    
    @IBOutlet var bookingDate: UILabel!
    
    @IBOutlet var bookingTotal: UILabel!
    
    @IBOutlet var bookingStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
