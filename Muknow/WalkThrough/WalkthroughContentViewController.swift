//
//  WalkthroughContentViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var headingLabel : UILabel! {
        didSet {
            headingLabel.numberOfLines = 0
        }
    }
    @IBOutlet var subHeadingLabel : UILabel! {
           didSet {
               subHeadingLabel.numberOfLines = 0
           }
       }
    
     @IBOutlet var contentImageView : UIImageView!
    var index = 0
    var heading = ""
    var subheading = ""
    var imagefile = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headingLabel.text = heading
        subHeadingLabel.text = subheading
        contentImageView.image = UIImage(named: imagefile)
        
        // Do any additional setup after loading the view.
    }
    


}
