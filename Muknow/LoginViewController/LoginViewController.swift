//
//  ViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // launch screen image should adjust with width.
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func forgotPassword_Tapped(_ sender: Any) {
        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.present(forgotVc, animated: true, completion: nil)
    }
    
    @IBAction func login_Tapped(_ sender: Any) {
        
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Nav") as! UINavigationController
        
        UITabBar.appearance().tintColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        
        self.present(nextViewController, animated: true, completion: nil)
   
    }
    
    
    
}

