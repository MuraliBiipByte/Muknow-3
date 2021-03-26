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
        
        
        
        
        if self.txtEmail.text == "" {
            self.showAlert(message: "Enter Email")
        }
        if !(txtEmail.text?.isValidEmail())! {
            self.showAlert(message: "Please Enter valid Email")
            return
        }
        
        // web service integration for Forget PW
        let paramsDict = [
            "email":self.txtEmail.text!,
            
        ]
        
        
        
        print("\(paramsDict)")
        
        self.view.StartLoading()
        
        ApiManager().postRequestToGetAccessToken(service:WebServices.FORGET_PWD, params: paramsDict)
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
//                ["message": Mail sent successfully, "result": 1, "otp_id": 37, "id": 27274]
                
                /*
                let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPwOTPViewController") as! ForgetPwOTPViewController
               
                forgotVc.EmailId = self.txtEmail.text!
                forgotVc.OtpId = resultDictionary["otp_id"] as? String
                
                
                self.present(forgotVc, animated: true, completion: nil)*/
                
                
                let keyExists = resultDictionary["error"] != nil
                if keyExists{
                    
                    /*let valDict = resultDictionary["error"] as! [String : Any]
                    let msg = valDict["email"]! as! String */
                    
                    DispatchQueue.main.async {
                        self.showAlert(message: "The email must be a valid email address")
                    }
                    
                }else {
                    let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPwOTPViewController") as! ForgetPwOTPViewController
                                  
                                   forgotVc.EmailId = self.txtEmail.text!
                                   forgotVc.OtpId = resultDictionary["otp_id"] as? String
                    forgotVc.idFromFirstResponse = "\(resultDictionary["id"]!)" //resultDictionary["id"] as? String
                                   
                                   
                                   self.present(forgotVc, animated: true, completion: nil)
                }
                
                
            }
            
        }
      
        //        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPwOTPViewController") as! ForgetPwOTPViewController
        //        self.present(forgotVc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func back_VC(_ sender: Any) {
        
         let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
              self.present(forgotVc, animated: true, completion: nil)
        
    }
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
     

}
