//
//  ForgotPasswordViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController {

    
    @IBOutlet var txtEmail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func submit_Tapped(_ sender: Any) {
        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPwOTPViewController") as! ForgetPwOTPViewController
        self.present(forgotVc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func back_VC(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
