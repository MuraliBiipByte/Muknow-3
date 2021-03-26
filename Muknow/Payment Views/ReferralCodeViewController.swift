//
//  ReferralCodeViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReferralCodeViewController: UIViewController,UITextFieldDelegate {

    
    
    @IBOutlet var referTxt: UITextField!
    var userId :String = ""
    var Price : String = ""
    var subcriptionstatus : String?
    var stripeUserAlreadyExist : Bool?

    
    override func viewDidLoad() {
        super.viewDidLoad()

                       
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
         lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
         //   btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
         
         let leftbarButton = UIBarButtonItem(customView: lefticonButton)
         
         navigationItem.leftBarButtonItem = leftbarButton
        userId = UserDefaults.standard.string(forKey: "user_id")!
        referTxt.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        referTxt.resignFirstResponder()
        return true
    }
    
    @IBAction func skip_Tapped(_ sender: Any) {
            UserDefaults.standard.set("", forKey: "Refer_Code")
             
            if subcriptionstatus == "1" {
                if stripeUserAlreadyExist!{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
                    vc.StripePayAmount = self.Price
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeRegistrationViewController") as! StripeRegistrationViewController
                        vc.amountStr = self.Price
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                
            }else{
                if stripeUserAlreadyExist!{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
                    vc.StripePayAmount = self.Price
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeRegistrationViewController") as! StripeRegistrationViewController
                    vc.amountStr = self.Price
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    
    
    @IBAction func back_vc(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

        
    }
    
    @IBAction func ok_Tapped(_ sender: Any) {
                    
        if (referTxt.text!.isEmpty){
            self.showAlert(message: "Please Enter Referral Code")
        }else{
            let params = ["lgw_user_id":userId,"refferal_code":self.referTxt.text!] as [String:Any]
                    
                    self.view.StartLoading()
                      ApiManager().postRequest(service: WebServices.CHECK_REFERRAL_CODE, params: params) { (result, success) in
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
                          
                            let tmpArr:[Any] = [resultDictionary["data"]!]
                            let response_data = tmpArr[0] as! [String: AnyObject]
                            let response_object = response_data["response"] as! [String: AnyObject]
                            let status_object = "\(response_object["status"]!)"
                            let message_object = "\(response_object["message"]!)"
                            
                            
                            if status_object == "0" { //|| status_object == "1" {
                                self.showAlert(message: "Invalid Referral Code")
                                return
                            }else if status_object == "3" || status_object == "1"{
                                self.showAlert(message: message_object)
                                return
                            }
                            else{
                                UserDefaults.standard.set(self.referTxt.text!, forKey: "Refer_Code")

                                if self.stripeUserAlreadyExist!{
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
                                    vc.StripePayAmount = self.Price
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }else{
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeRegistrationViewController") as! StripeRegistrationViewController
                                    //        cell!.SubscriptionName.text = Subscription_List[sender?.tag]["price"] as? String ?? ""
                                    vc.amountStr = self.Price
                                    
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }

                                
                                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeRegistrationViewController") as! StripeRegistrationViewController
                                //        cell!.SubscriptionName.text = Subscription_List[sender?.tag]["price"] as? String ?? ""
                                vc.amountStr = self.Price
                                
                                self.navigationController?.pushViewController(vc, animated: true)*/
                            }
                            
                          
                            
                        }
                          
                      }
        }

                
            
            
        }
//    @IBAction func ok_Tapped(_ sender: Any) {
//
//
//    //            http://devservices.mu-know.com:8080/smiles_stripe_payment_subscribed_user_referralcode
//    ////        ?lgw_user_id=27279&refferal_code=Mu_272791M83K385
//    //
//
//            let params = ["lgw_user_id":userId,"refferal_code":self.referTxt.text!] as [String:Any]
//
//            //        print(params)
//
//                    self.view.StartLoading()
//                      ApiManager().postRequest(service: WebServices.CHECK_REFERRAL_CODE, params: params) { (result, success) in
//                          self.view.StopLoading()
//                          if success == false
//                          {
//                              self.showAlert(message: result as! String)
//                              return
//
//                          }
//                          else
//                          {
//
//
//                            let resultDictionary = result as! [String : Any]
//                            print(resultDictionary)
//
//                            UserDefaults.standard.set(self.referTxt.text!, forKey: "Refer_Code")
//
//
//                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeRegistrationViewController") as! StripeRegistrationViewController
//                            //        cell!.SubscriptionName.text = Subscription_List[sender?.tag]["price"] as? String ?? ""
//                            vc.amountStr = self.Price
//
//                            self.navigationController?.pushViewController(vc, animated: true)
//
//
//                        }
//
//                      }
//
//
//
//        }
    
    func showAlert(message:String)
        {
            Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
        }

}
