//
//  ForgetPwOTPViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ForgetPwOTPViewController: UIViewController {

    @IBOutlet var otpTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    @IBAction func back_vc(_ sender: Any) {
        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(forgotVc, animated: true, completion: nil)
    }
    

}
