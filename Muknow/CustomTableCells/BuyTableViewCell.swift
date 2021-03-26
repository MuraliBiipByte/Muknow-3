//
//  BuyTableViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class BuyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
       func showSeparator() {
           DispatchQueue.main.async {
               self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
           }
       }

       func hideSeparator() {
              DispatchQueue.main.async {
                  self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
              }
          }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
