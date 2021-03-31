//
//  SettingsViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    var termsAccept = false
    var emailTermsAccept = false
    var userId : String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton



        userId = UserDefaults.standard.string(forKey: "user_id")

        self.getUserData()
        
//        ["data": {
//            response =     {
//                message = "subscribed User";
//                "notification_status" = 1;
//                refferalcode = GU347;
//                status = 1;
//            };
//        }]
        
        
        
        
    }
    
    

            func getUserData() {
                
                let paramsDict = [
                    "lgw_user_id":self.userId!]

                print(paramsDict)
                self.view.StartLoading()
                ApiManager().postRequest(service:WebServices.PROFILE_DETAILS, params: paramsDict as [String : Any])
                      { (result, success) in
                          self.view.StopLoading()

                          if success == false
                          {
                            self.termsAccept = false
                            
                            self.btnNotificationUpdate.setImage(UIImage(named: "unCheck"), for: .normal);
                            
                            self.emailTermsAccept = false
                            self.btnEmailNotification.setImage(UIImage(named: "unCheck"), for: .normal)
    //                        self.UserDataView.isHidden = true
    //                         self.userNameLbl.text = ""
    //                        self.showAlert(message: result as! String )
                              return
                          }
                          else
                          {
                            
                          
                            let resultDictionary = result as! [String : Any]
                       
                            print(resultDictionary)
                            
                            let data = resultDictionary ["data"] as! [String:Any]
                            let UserData = data ["response"] as! [String:Any]
                            print(UserData)
                            //let status = UserData["notification_status"] as! String
                            let app_notification_status = "\(UserData["notification_status"]!)"
                            
                            if app_notification_status == "0" {
                                
                                self.termsAccept = false
                                
                                self.btnNotificationUpdate.setImage(UIImage(named: "unCheck"), for: .normal);
                                
                            }else
                            {
                                self.termsAccept = true
                                
                                self.btnNotificationUpdate.setImage(UIImage(named: "check"), for: .normal);
                                
                                //                    self.userMobileNoLbl.text =
                            }
                            
                            let emailNotificationStatus = "\(UserData["email_notification_status"]!)"
                            if emailNotificationStatus == "0" || emailNotificationStatus == "<null>"{
                                self.emailTermsAccept = false
                                self.btnEmailNotification.setImage(UIImage(named: "unCheck"), for: .normal)
                            }else{
                                self.emailTermsAccept = true
                                self.btnEmailNotification.setImage(UIImage(named: "check"), for: .normal)
                            }
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                      }
                
            }

    
    func updateNotificationStatus(status:Int){
//        lgw_user_id,status_type
        
        let params = ["lgw_user_id":userId!,"status_type" : status] as [String:Any]

        print(params)
        
               self.view.StartLoading()
               ApiManager().postRequest(service: WebServices.NOTIFICATION_UPDATE, params: params) { (result, success) in
                   self.view.StopLoading()
                   if success == false
                   {
                       //self.showAlert(message: result as! String)
                       return
                       
                   }
                   else
                   {
                       let response = result as! [String : Any]
                  
                    self.showAlert(message: "User Updated Successfully")
                    //self.showAlertWithAction(message:"User Updated Successfully")
                    
                    

        //               print(response)
                }
        }
        
        
    }
        func updateEmailNotificationStatus(status:Int){
    //        lgw_user_id,status_type
            
            let params = ["lgw_user_id":userId!,"email_status_type" : status] as [String:Any]

            print(params)
            
                   self.view.StartLoading()
                   ApiManager().postRequest(service: WebServices.EMAIL_NOTIFICATION_UPDATE, params: params) { (result, success) in
                       self.view.StopLoading()
                       if success == false
                       {
                           //self.showAlert(message: result as! String)
                           return
                           
                       }
                       else
                       {
                           let response = result as! [String : Any]
                      
                        self.showAlert(message: "User Updated Successfully")
                        //self.showAlertWithAction(message:"User Updated Successfully")
                        
                        

            //               print(response)
                    }
            }
            
            
        }
    
    
    @IBOutlet var btnNotificationUpdate : UIButton!

    @IBOutlet weak var btnEmailNotification: UIButton!
    
    @IBAction func updateEmailNotificationStatus(_ sender: UIButton) {
        if emailTermsAccept
        {
            emailTermsAccept = false
            btnEmailNotification.setImage(#imageLiteral(resourceName: "unCheck"), for:.normal)
            updateEmailNotificationStatus(status: 0)
        }
        else
        {
            emailTermsAccept = true
            btnEmailNotification.setImage(#imageLiteral(resourceName: "check"), for:.normal)
            updateEmailNotificationStatus(status: 1)

        }
    }
    @IBAction func updateAppNotificationStatus(_ sender: Any) {
        
        if termsAccept
        {
            termsAccept = false
            btnNotificationUpdate.setImage(#imageLiteral(resourceName: "unCheck"), for:.normal)
            updateNotificationStatus(status: 0)
        }
        else
        {
            termsAccept = true
            btnNotificationUpdate.setImage(#imageLiteral(resourceName: "check"), for:.normal)
            updateNotificationStatus(status: 1)

        }
    }
    
    

    @IBAction func back_tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
    /*
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToLogin), Controller: self)], Controller: self)
    }
    @objc func goToLogin()
    {
        let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
      
       self.navigationController?.pushViewController(LoginController, animated: true)
    } */
    
}
