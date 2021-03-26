//
//  ProfileTableViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {

    @IBOutlet var lblProfileListName: UILabel!
    @IBOutlet var layoutView: UIView!
    
    @IBOutlet var view1: UIView!
    
    
    @IBOutlet var view1Height: NSLayoutConstraint!
    
    
    
    
    @IBOutlet var prifileNameLbl: UILabel!
    
    
    @IBOutlet var profileImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
 
    
    
}
