//
//  RegistrationViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.

import UIKit

class RegistrationViewController: UIViewController  {
    
   
    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var mobileTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var confirmPwTxt: UITextField!
    @IBOutlet var dobTxt: UITextField!
    @IBOutlet var btnTermsConditions: UIButton!
    var termsAccept = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btnTermsConditions.setImage(#imageLiteral(resourceName: "unCheck"), for:.normal)

        btnTermsConditions.setImage(UIImage(named: "unCheck"), for: .normal);
        
    }
    
    @IBAction func create_NewAccount(_ sender: Any) {
        
        // web service integration for sign up

    }
    
    @IBAction func agreeTerms_Conditions_Tapped(_ sender: Any) {
        
        if termsAccept
        {
            termsAccept = false
            btnTermsConditions.setImage(#imageLiteral(resourceName: "unCheck"), for:.normal)
        }
        else
        {
            termsAccept = true
            btnTermsConditions.setImage(#imageLiteral(resourceName: "check"), for:.normal)
        }
    }

    @IBAction func back_vc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    
}
