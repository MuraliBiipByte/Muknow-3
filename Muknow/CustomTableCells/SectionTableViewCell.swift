//
//  SectionTableViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SectionTableViewCell: UITableViewCell {

    @IBOutlet weak var sectionLbl: UILabel!

    @IBOutlet var lessonPageTitleLbl: UILabel!
    
    @IBOutlet var rightArrImg: UIImageView!
    
    @IBOutlet var categoriesImg: UIImageView!
    
    
    
    
    // smiles content Category Table content
    
    @IBOutlet var contentTitleLbl: UILabel!
    
    @IBOutlet var contentRightArr: UIImageView!
    
    
    
    // Aticles Objects
    
    @IBOutlet var articleTitleLbl: UILabel!
    @IBOutlet var articleDescLbl: UILabel!
    
    
    // Articles Search Objects
    
    @IBOutlet var searchTitleLbl: UILabel!
    @IBOutlet var searchDescLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
