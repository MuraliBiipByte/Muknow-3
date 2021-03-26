//
//  NotificationsViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var userId : String?
    var Notifications_Details = [AnyObject]()

    @IBOutlet var NotificationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        //
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        
        navigationItem.leftBarButtonItem = leftbarButton
        
        
        self.NotificationTable.isHidden = true
        
        NotificationTable.dataSource = self
        NotificationTable.delegate = self
        
        self.NotificationTable.separatorColor = .clear
        
        
        userId = UserDefaults.standard.string(forKey: "user_id")
        
        //        if userId != nil {
        //            self.showAlertWithAction(message: "Please login to Continue")
        //        }else{
        //           getNotificationHistoryData()
        //        }
        
        if userId == nil {
            self.showAlertWithAction(message: "Please login to Continue")
            
        }
        else
        {
            getNotificationHistoryData()
        }
        
        
    }
    

    @IBAction func back_tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return self.Notifications_Details.count
         
     }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsTableViewCell") as? NotificationsTableViewCell
       
        cell!.notificationmessage.text =  String(format: "%@",self.Notifications_Details[indexPath.row]["notification_message"] as! String)
        
        cell!.selectionStyle = .none
        
        
        return cell!

          
    }
   func getNotificationHistoryData() {
       //        http://devservices.mu-know.com:8080/smiles_recieved_notification_messages?lgw_user_id=27279
       
       
       let params = ["lgw_user_id":userId!] as [String:Any]
       
//       print(params)
       
       
       self.view.StartLoading()
       ApiManager().postRequest(service: WebServices.NOTIFICATION_HISTORY, params: params) { (result, success) in
           self.view.StopLoading()
           if success == false
           {
               self.showAlert(message: result as! String)
               return
               
           }
           else
           {
               
               
               let response = result as! [String : Any]
//               print(response)
               let data = response ["data"] as! [String:Any]
//               print(data)
               let subscriptionresponse = data ["response"] as! [String:Any]
               let subscriptiondata = subscriptionresponse ["data"] as! [String:Any]
               
               self.Notifications_Details = (subscriptiondata["notification_details"] as? [AnyObject]) != nil  ?  (subscriptiondata["notification_details"] as! [AnyObject]) : []
               
//               print(self.Notifications_Details)
               if (self.Notifications_Details.count > 0)
               {
                   self.NotificationTable.reloadData()
                   self.NotificationTable.isHidden = false
               }
               
           }
           
       }
       
   }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func myAccount()
    {
        let changePwVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(changePwVc, animated: true, completion: nil)
    }
    
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(myAccount), Controller: self)], Controller: self)
    }
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
              //self.navigationController?.viewControllers.removeAll()
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
              let courseViewController = storyboard.instantiateViewController(withIdentifier: "NewHomeViewControllerSBID")
              self.navigationController?.pushViewController(courseViewController, animated: false)
          }
       
       @IBAction func categoriesBtnTapped(_ sender: UIButton) {
           
           //self.navigationController?.viewControllers.removeAll()
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let courseViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesVCSBID")
           self.navigationController?.pushViewController(courseViewController, animated: false)
       }
       
       
       @IBAction func microLearningBtnTapped(_ sender: UIButton) {
           
           //SmilesCategoriesViewController
           //self.navigationController?.viewControllers.removeAll()
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let courseViewController = storyboard.instantiateViewController(withIdentifier: "SmilesCategoriesViewController")
           self.navigationController?.pushViewController(courseViewController, animated: false)
       }
       
       @IBAction func coursesHistoryBtnTapped(_ sender: UIButton) {
           //self.navigationController?.viewControllers.removeAll()
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let courseViewController = storyboard.instantiateViewController(withIdentifier: "CourseHistoryViewController")
           self.navigationController?.pushViewController(courseViewController, animated: false)
       }
       
       @IBAction func notificationBtnTapped(_ sender: UIButton) {
        /*
        //self.navigationController?.viewControllers.removeAll()
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let courseViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController")
           self.navigationController?.pushViewController(courseViewController, animated: false) */
       }
       
       @IBAction func profileBtnTapped(_ sender: UIButton) {
           //self.navigationController?.viewControllers.removeAll()
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let courseViewController = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController")
           self.navigationController?.pushViewController(courseViewController, animated: false)
       }
       
       @IBOutlet weak var homeBtn: UIButton!
       @IBOutlet weak var categoriesBtn: UIButton!
       @IBOutlet weak var microLearningBtn: UIButton!
       @IBOutlet weak var coursesHistoryBtn: UIButton!
       @IBOutlet weak var notificationBtn: UIButton!
       @IBOutlet weak var profileBtn: UIButton!
    
    
}
