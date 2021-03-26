//
//  ChangeNewPWViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ChangeNewPWViewController: UIViewController {

    
    @IBOutlet var newPwTxt: UITextField!
    @IBOutlet var confirmNewPwTxt: UITextField!
    var EmailId : String?
    var otpId : String?
    var otpStr : String?
    var idFromFirstResponse : String?
    var paramsDict : [String:Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func submit_Newpassword(_ sender: Any) {
        
        if self.newPwTxt.text == "" {
                   self.showAlert(message: "Enter New Password")
               }
        
        else if self.confirmNewPwTxt.text == "" {
                   self.showAlert(message: "Re-Enter New Password")
               }
        else if self.newPwTxt.text != self.confirmNewPwTxt.text  {
                         self.showAlert(message: "New Password & Re-Enter Password Should match.")
        }else if self.newPwTxt.text!.count < 6{
            self.showAlert(message: "Password should be minimum 6 characters.")
        }else{

            let paramsDict = [
                /*"email":self.EmailId,
                "email_otp":self.otpStr!,
                "otp_id":self.otpId,
                "new_password":self.newPwTxt.text!,
                 "id":self.idFromFirstResponse! */
                
                "email":self.EmailId!,
                "email_otp":self.otpStr!,
                "otp_id":self.otpId!,
                "new_password":self.newPwTxt.text!,
                "id":self.idFromFirstResponse!
            ]
            print("\(paramsDict)")
             ApiManager().postRequestToGetAccessToken(service:WebServices.CHANGE_PWD, params: paramsDict as [String : Any])
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
                    self.showAlertWithAction(message:"Password reset successful")
                    
//                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//                    self.present(loginVC, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    

    @IBAction func back_vc(_ sender: Any) {
        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
             self.present(forgotVc, animated: true, completion: nil)
    }
    
    
      func showAlert(message:String)
          {
              Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
          }
    
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToLogin), Controller: self)], Controller: self)
    }
    @objc func goToLogin()
    {
        let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
      
       //self.navigationController?.pushViewController(LoginController, animated: true)
        self.present(LoginController, animated: true, completion: nil)
    }
    
}
