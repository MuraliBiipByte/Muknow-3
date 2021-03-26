//
//  MyCourseCell.swift
//  Muknow
//
//  Created by Apple on 16/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


protocol MyCourseCellDelegate : class {
}

class MyCourseCell: UITableViewCell {

    @IBOutlet weak var loaderCourse: UIActivityIndicatorView!
    @IBOutlet var courseImg: UIImageView!
    @IBOutlet var courseNameLbl: UILabel!
    @IBOutlet var bookingId: UILabel!
    @IBOutlet var bookingDate: UILabel!
    @IBOutlet var bookingTotal: UILabel!
    @IBOutlet var bookingStatus: UILabel!
    @IBOutlet weak var bookedOnLbl: UILabel!
    
    @IBOutlet weak var bookingTotalTopCons: NSLayoutConstraint!
    var delegate: MyCourseCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
