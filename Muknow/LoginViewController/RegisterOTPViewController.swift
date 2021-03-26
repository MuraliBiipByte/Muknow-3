//
//  RegisterOTPViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class RegisterOTPViewController: UIViewController {
 
    var params : [String:Any] = [:]
    var id : String?
    
    @IBOutlet var OTPTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAlert(message: "Mail Sent Successfully")
    }
    

    @IBAction func submitOtp_Tapped(_ sender: Any) {
        
        if self.OTPTxt.text == "" {
            self.showAlert(message: "Enter OTP sent to your Email")
        }else{
            params["email_otp"] = self.OTPTxt.text
            params["id"] = self.id
            
            print(params)
            self.sendOTP()
        }
    }
  
    func sendOTP() {
        
        self.view.StartLoading()
        ApiManager().postRequestToGetAccessToken(service:WebServices.OTP_SUCCESS, params: params as [String : Any])
        { (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String )
                return
            }
            else
            {
                let resultDictionary = result as! [String:Any]
                print("\(resultDictionary)")
                
                let msg = resultDictionary["message"]! as! String
                if msg == "Invalid OTP" {
                    DispatchQueue.main.async {
                        self.showAlert(message: "Invalid OTP")
                    }
                }else{
                    UserDefaults.standard.set(self.params["email"], forKey: "user_email")
                    UserDefaults.standard.set(self.params["id"], forKey: "user_id")

                    
                    self.showAlertWithAction(message: "Registered successfully", selector:#selector(self.moveToLoginPage))
                }
            }
        }
    }
    
    @objc func moveToLoginPage()
    {
        let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginVc, animated: true, completion: nil)
                        
        
    }
    
    @IBAction func resend_OTP_Tapped(_ sender: Any) {
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.REGISTRATION, params: self.params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                _ = User(userDictionay: resultDictionary)
                print("OTP Resent.....")
                self.showAlert(message: "Mail Sent Successfully")
                print(resultDictionary)
                self.id = "\(resultDictionary["id"]!)"
            }
        }
    }
    
     func showAlertWithAction(message:String,selector:Selector)
      {
          Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
      }
      
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    @IBAction func back_VC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
