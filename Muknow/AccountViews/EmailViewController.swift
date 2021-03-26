//
//  EmailViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    
    @IBOutlet weak var txtName:UITextField!
    @IBOutlet weak var txtEmail:UITextField!
    @IBOutlet weak var txtPhone:UITextField!
    @IBOutlet weak var txtViewMessage:UITextView!
    
    var username : String = ""
    var userEmailStr : String = ""
    var usernumber : String = ""
    var userId : String?


    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        
          username = UserDefaults.standard.object(forKey: "user_name") as! String
          userEmailStr = UserDefaults.standard.object(forKey: "user_email") as! String
        usernumber = UserDefaults.standard.object(forKey: "user_mobile") as! String

       userId = UserDefaults.standard.string(forKey: "user_id")

        self.txtName.text = username
        self.txtEmail.text = userEmailStr
        self.txtPhone.text = usernumber
        
        
    }
    
    
    @IBAction func submit_Tapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if (txtName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter name")
            self.txtName.resignFirstResponder()
            return
        }
        else if (txtEmail.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter email")
            self.txtEmail .resignFirstResponder()
            return
        }
       else if (txtPhone.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter Phone Number")
            self.txtPhone .resignFirstResponder()
            return
        }
        else if (txtViewMessage.text?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            self.showAlert(message:"Please enter message")
            self.txtViewMessage .resignFirstResponder()
            return
        }
        else{
//            EMAUL_US
            


                    
            let paramsDict : [String: String] = [
                        "name":self.txtName.text!,
                        "email":self.txtEmail.text!,
                        "message":self.txtViewMessage.text!,
                        "mobile_num": self.txtPhone.text!,
                "lgw_user_id":self.userId!]

            print(paramsDict)
                    self.view.StartLoading()
                    ApiManager().postRequest(service:WebServices.EMAUL_US, params: paramsDict as [String : Any])
                          { (result, success) in
                              self.view.StopLoading()

                              if success == false
                              {
                            
                                self.showAlert(message: result as! String )
                                  return
                              }
                              else
                              {
                                
                               
                                let resultDictionary = result as! [String : Any]
                           
                                print(resultDictionary)
//                                self.showAlert(message: "Email Inserted successfully")
                                self.showAlertWithAction(message: "Email Inserted successfully")
                                    
                              

                          }
                    
                
            }
            
            
//
//       let paramsDIc = ["api_key_data":WebServices.API_KEY,"name":txtName.text!,"email":txtEmail.text!,"mobile":txtPhone.text!,"message":txtViewMessage.text!]
//        self.view.StartLoading()
//        ApiManager().postRequest(service: WebServices.CONTACT_US, params: paramsDIc) { (result, success) in
//         self.view.StopLoading()
//            if success == false
//            {
//                self.showAlertWithAction(message: result as! String,selector:#selector(self.backVc))
//                return
//            }
//            else
//            {
//                let resultDictionary = result as! [String : Any]
//                let message = resultDictionary["message"] as? String
//                self.showAlertWithAction(message: message! ,selector:#selector(self.backVc))
//            }
//        }
//
        }
        
    }
    
    
    
    @IBAction func back_vc(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    func showAlert(message:String)
        {
            Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
        }

    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(refreshPage), Controller: self)], Controller: self)
    }
    @objc func refreshPage()
     {
//         let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//
//        self.navigationController?.pushViewController(LoginController, animated: true)
        self.navigationController?.popViewController(animated: true)
     }

}
