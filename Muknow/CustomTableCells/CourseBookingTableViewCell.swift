//
//  CourseBookingTableViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CourseBookingTableViewCell: UITableViewCell {

    
    
    @IBOutlet var addressLbl: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var bookingPeriodLbl: UILabel!
    @IBOutlet var bookingDateLbl: UILabel!
    @IBOutlet var bookBtn: UIButton!
    @IBOutlet weak var soldoutLbl: UILabel!
    @IBOutlet weak var ticketNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
