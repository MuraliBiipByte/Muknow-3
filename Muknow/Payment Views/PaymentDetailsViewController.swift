//
//  PaymentDetailsViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class PaymentDetailsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        
        
        let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)

        
        let rightbarButton = UIBarButtonItem(customView: righticonButton)
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = rightbarButton
        
        
        
    }
    
    
    
    
    
    
    
}
