//
//  StripeRegistrationViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class StripeRegistrationViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet var firstNameTxt: UITextField!
    @IBOutlet var lastNameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    
    @IBOutlet var accountNoTxt: UITextField!
    @IBOutlet var routingNoTxt: UITextField!
    
    var userId :String = ""
    var FirstName :String = ""
    var LastName :String = ""
    var Email :String = ""
    var account_id :String = ""
    var amountStr = String()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
         lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
         //   btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
         
         let leftbarButton = UIBarButtonItem(customView: lefticonButton)
         
         navigationItem.leftBarButtonItem = leftbarButton
        
        
        
        let alert = UIAlertController(title: "Terms of Service & Privacy Policy", message: "Please accept Terms & Conditions", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertAction.Style.default, handler: { action in
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListViewController") as! SubscriptionListViewController
            self.navigationController?.pushViewController(vc, animated: true)

            
//            self.dismiss(animated: true, completion: nil)
        }))
       
        alert.addAction(UIAlertAction(title: "I AGREE", style: UIAlertAction.Style.default, handler: { action in
            
            // dismiss
        }))

        self.present(alert, animated: true, completion: nil)
        
        
        
        userId = UserDefaults.standard.string(forKey: "user_id")!
        FirstName = UserDefaults.standard.string(forKey: "user_name")!
//        LastName = UserDefaults.standard.string(forKey: "user_name")!
        Email = UserDefaults.standard.string(forKey: "user_email")!

        self.firstNameTxt.text = FirstName
//        self.lastNameTxt.text = LastName
        self.emailTxt.text = Email
         
        self.firstNameTxt.delegate = self
        self.lastNameTxt.delegate = self
        self.accountNoTxt.delegate = self
        self.routingNoTxt.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.firstNameTxt.resignFirstResponder()
        self.lastNameTxt.resignFirstResponder()
        self.accountNoTxt.resignFirstResponder()
        self.routingNoTxt.resignFirstResponder()
        return true
        
    }
    
    @IBAction func register_Tapped(_ sender: Any) {
            
            if self.firstNameTxt.text == "" {
                self.showAlert(message: "Enter First Name")
            }
            else if self.lastNameTxt.text == "" {
                       self.showAlert(message: "Enter Last Name")
                   }
            else if self.emailTxt.text == "" {
                self.showAlert(message: "Enter Email")
            }
            else if self.accountNoTxt.text == "" {
                self.showAlert(message: "Enter Account Number")
            }
            else if self.routingNoTxt.text == "" {
                self.showAlert(message: "Enter Routing Number")
            }
            else{
           
           let paramsDict = [
            
                "email":self.emailTxt.text!,
                "first_name":self.firstNameTxt.text!,
                "last_name":self.lastNameTxt.text!,
                "lgw_user_id":self.userId
                
            ]
       
            print("\(paramsDict)")
            
            self.view.StartLoading()
            
            
            ApiManager().postRequest(service: WebServices.STRITPE_REGISTER_USER, params: paramsDict) { (result, success) in
                self.view.StopLoading()
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                    
                }
                else
                {
                    let resultDictionary = result as! [String : Any]
                    
                    print(resultDictionary)
                 
                    let data = resultDictionary ["data"] as! [String:Any]
                    let screatedResp = data ["response"] as! [String:Any]
                   
                    self.account_id = screatedResp["account_id"] as! String
                    
                    //self.updateStripeUser()
                    self.showAlertWithAction(message: (screatedResp["message"] as! String) )
                }
                
            }
        }

        }
    
    func updateStripeUser() {
        
        let paramsDict = [
         
             "account_number":self.accountNoTxt.text!,
             "routing_number":self.routingNoTxt.text!,
             "strip_account_id":self.account_id
             
         ]
    
//        print("\(paramsDict)")
         
         self.view.StartLoading()
         
         
         ApiManager().postRequest(service: WebServices.STRITPE_UPDATE_USER, params: paramsDict) { (result, success) in
             self.view.StopLoading()
             if success == false
             {
                 self.showAlert(message: result as! String)
                 return
                 
             }
             else
             {
                 let resultDictionary = result as! [String : Any]
                 print(resultDictionary)
                 
                let data = resultDictionary ["data"] as! [String:Any]
                let screatedResp = data ["response"] as! [String:Any]
                
                let status = screatedResp["status"] as! Int
                if status == 1{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
                                   vc.StripePayAmount = self.amountStr
                                   //vc.isRegisteredStripeUser = true
                                   self.view.StopLoading()
                                   self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let mess = screatedResp["message"] as! String
                    print(mess)
                    self.showAlert(message: mess)
                }
                 
             }
             
         }
     }
    
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    func showAlertWithAction(message:String)
              {
                  Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(callStripeUpdateUserAPI), Controller: self)], Controller: self)
              }
    
    @objc func callStripeUpdateUserAPI()
            {
               self.updateStripeUser()
            }


   @IBAction func back_vc(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
     }
     

}
