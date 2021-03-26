//
//  SubscriptionListViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SubscriptionListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {


    var Subscription_List = [AnyObject]()
    @IBOutlet var SubscriptionTable: UITableView!
    
    var userId :String = ""
    var amountStr = String()
    var subcriptionstatus = String()
    var stripeUserAlreadyExist : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

               self.navigationController?.setNavigationBarHidden(false, animated: true)
         let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
          lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
          //   btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
          
          let leftbarButton = UIBarButtonItem(customView: lefticonButton)
          
          navigationItem.leftBarButtonItem = leftbarButton
          
        userId = UserDefaults.standard.string(forKey: "user_id")!
        
        self.getSubscriptionList()
         
        self.SubscriptionTable.isHidden = true
        self.SubscriptionTable.dataSource = self
        self.SubscriptionTable.delegate = self
        self.SubscriptionTable.tableFooterView = UIView.init(frame: CGRect.zero)
        self.SubscriptionTable.separatorColor = .clear
        
        
    }
 
    func getSubscriptionList() {
        
        self.view.StartLoading()
        
        ApiManager().getRequestWithParameters(service: WebServices.SUBSCRIPTION_LIST, params: [:], completion:
            { (result, success) in
                
                
                self.view.StopLoading()
                
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                }
                    
                else
                {
                    let response = result as! [String : Any]
                    
                    if let code : Int = response["code"] as? Int {
                        print(code)
                        if code == 404 {
                            self.showAlert(message: response["error"] as! String)
                        }else{
                            self.showAlert(message: "No data found")
                        }
                    }
                    else{
                       
                        
                        let data = response ["data"] as! [String:Any]
                        let subscriptionresponse = data ["response"] as! [String:Any]
                        let subscriptiondata = subscriptionresponse ["data"] as! [String:Any]
                        
                        self.Subscription_List = (subscriptiondata["subscription_plan_details"] as? [AnyObject]) != nil  ?  (subscriptiondata["subscription_plan_details"] as! [AnyObject]) : []
                        
                        print(self.Subscription_List)
                        if (self.Subscription_List.count > 0)
                        {
                            self.SubscriptionTable.reloadData()
                            self.SubscriptionTable.isHidden = false
                        }
                    }
                    
                }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.Subscription_List.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
           let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionTableViewCell") as? SubscriptionTableViewCell
        
           cell!.SubscriptionName.text = Subscription_List[indexPath.row]["description"] as? String ?? ""
           cell!.subscriptionValidityMonth.text = Subscription_List[indexPath.row]["validity"] as? String ?? ""
        
           cell!.SubscriptionAmount.text =  String(format: " $ %.2f", arguments: [Double("\(self.Subscription_List[indexPath.row]["price"]! ?? "0")")!])
        
        cell!.payBtn.addTarget(self, action: #selector(self.PaySubscriptionAmount), for: .touchUpInside)
        cell!.payBtn.tag = indexPath.row
        
        cell!.selectionStyle = .none
           return cell!
       }
    
    var priceStr : String = ""
    @objc func PaySubscriptionAmount(sender : UIButton?) {
        
        print("pay amount")
        
        let dictObj = self.Subscription_List[sender!.tag]
        print(dictObj)
        
        let referalFlag  = dictObj["referral_code_flag"] as! Int
        self.priceStr = dictObj["price"] as? String ?? ""
                           
        UserDefaults.standard.set("\(dictObj["id"] as! Int)", forKey: "Sub_id")
        
        if referalFlag == 0 {
            UserDefaults.standard.set("", forKey: "Refer_Code")
        }
        
        checkUserAlreadyRegistered(lgw_user_id: userId,buttonTag:sender!.tag,referralCode: referalFlag)
                    
    }
    func checkUserAlreadyRegistered(lgw_user_id:String,buttonTag : Int,referralCode:Int){
        self.view.StartLoading()
        
        let paramsDict = ["lgw_user_id":self.userId]
        
        print("\(paramsDict)")
        
        ApiManager().postRequest(service: WebServices.STRITPE_CHECK_USER, params: paramsDict) { (result, success) in
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
                let subscriptionresponse = data ["response"] as! [String:Any]
                let status = subscriptionresponse ["status"] as! String
               
                if status == "0"{
                    self.stripeUserAlreadyExist = false
                }else{
                    self.stripeUserAlreadyExist = true
                }
                
                
                if self.stripeUserAlreadyExist {
                    
                    if buttonTag == 0 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReferralCodeViewController") as! ReferralCodeViewController
                            vc.Price = self.priceStr
                        vc.subcriptionstatus = self.subcriptionstatus
                        vc.stripeUserAlreadyExist = self.stripeUserAlreadyExist
                            self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
                        vc.StripePayAmount = self.priceStr
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }else{
                    if buttonTag == 0 {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReferralCodeViewController") as! ReferralCodeViewController
                            vc.Price = self.priceStr
                        vc.subcriptionstatus = self.subcriptionstatus
                        vc.stripeUserAlreadyExist = self.stripeUserAlreadyExist
                            self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StripeRegistrationViewController") as! StripeRegistrationViewController
                        //        cell!.SubscriptionName.text = Subscription_List[sender?.tag]["price"] as? String ?? ""
                        vc.amountStr = self.priceStr
                        
                        
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func back_vc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }


}
