//
//  MyProfileViewController.swift
//  Muknow
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class MyProfileViewController: UIViewController {

 let AccountInfoTitles = ["My Profile","Settings","Support"]
    
    @IBOutlet var view1Height: NSLayoutConstraint!
    @IBOutlet var view2Height: NSLayoutConstraint!
    @IBOutlet var view3Height: NSLayoutConstraint!
    
    var tag1 : Int = 0
    var tag2 : Int = 0
    var tag3 : Int = 0
    var Access_Token : String = ""
    var username : String = ""
    var userEmail : String = ""
    var userId : String?

    @IBOutlet var subView1: UIView!
    @IBOutlet var subView2: UIView!
    @IBOutlet var subView3: UIView!
    
    
    
    
    @IBOutlet var signOutBtn: UIButton!
    
    
    @IBOutlet var userNameLbl: UILabel!
    @IBOutlet var userEmailLbl: UILabel!
    @IBOutlet var userTypeLbl: UILabel!
    @IBOutlet var userReferalsLbl: UILabel!
// @IBOutlet var userRewardPtsLbl: UILabel!
    
    
//    @IBOutlet var userNameTxt: UITextField!
//    @IBOutlet var emailTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        view1Height.constant = 50
        subView1.isHidden = true
        
        view2Height.constant = 50
        subView2.isHidden = true
        
        view3Height.constant = 60
        subView3.isHidden = true

        userId = UserDefaults.standard.string(forKey: "user_id")
      
        if userId == nil {
          
            signOutBtn.setTitle("SignIn", for: .normal)
            self.showAlert(message: "Please login to Continue")
        }
        else{

            username = UserDefaults.standard.object(forKey: "user_name") as! String
            userEmail = UserDefaults.standard.object(forKey: "user_email") as! String
            signOutBtn.setTitle("Sign Out", for: .normal)
            self.getUserData()

        }
        

        
        
        self.userNameLbl.text = username
        self.userEmailLbl.text = userEmail
        
       
        
    }
   
    
    func getUserData() {
        
        let paramsDict = [
            "lgw_user_id":self.userId]

        self.view.StartLoading()
        ApiManager().postRequest(service:WebServices.PROFILE_DETAILS, params: paramsDict as [String : Any])
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
               
                    let data = resultDictionary ["data"] as! [String:Any]
                    let UserData = data ["response"] as! [String:Any]
                    
                    let status = UserData["status"] as! String
                    
                    if status == "0" {
                        self.userTypeLbl.text = "Non_Subscriber"
                        self.userReferalsLbl.text = ""
                    }else{
                        self.userTypeLbl.text = "Subscriber"
                        self.userReferalsLbl.text = UserData["refferalcode"] as? String
                    }

                  }

              }
        
    }
    
    
    func signOut()
    {
        // web service integration for Sign out
        
        Access_Token = UserDefaults.standard.object(forKey: "access_token") as! String
        
                let paramsDict = [
                    "token":Access_Token
                ]
              
                self.view.StartLoading()
                
        ApiManager().getRequestWithParameters(service: WebServices.LOGOUT, params: paramsDict, completion:
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
                     
                        self.removeObjects()
                        
                        let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        self.present(initialVc, animated: true, completion: nil)
                        
                        
                    }
                    
                })
    }
    
    func removeObjects() {
        UserDefaults.standard.set(nil, forKey: "user_id")
        UserDefaults.standard.set(nil, forKey: "user_name")
        UserDefaults.standard.set(nil, forKey: "user_email")
    }
    
  //  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
   // {
   //     return AccountInfoTitles.count
   // }
   // func tableView(_ tableView: UITableView, cellForRowAt indexPath: //IndexPath) -> UITableViewCell
//{
        //let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell")as! ProfileTableViewCell
        
//        cell.accessoryType = .detailDisclosureButton
        //cell.lblProfileListName.text = AccountInfoTitles[indexPath.row]
        
        //cell.layoutView.layer.shadowColor = UIColor.lightGray.cgColor
       // cell.layoutView.layer.shadowOffset =  CGSize(width: 1, height: 1)
        //cell.layoutView.layer.shadowOpacity = 1;
    //   cell.layoutView.layer.shadowRadius = 1.0;
     //   cell.layoutView.layer.masksToBounds = false;
        
        
//        tblHight.constant = tableView.contentSize.height
        
        
      //  cell.view1Height.constant = 0
       // cell.view1.isHidden = true
        
      //  return cell
    //}
   // func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {//
    //    return 70
    //}
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //  let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell")as! ProfileTableViewCell
    // }
    
    
    @IBOutlet var profileArrow: UIImageView!
    @IBAction func myProfileBtn_Tapped(_ sender: Any) {
        
        if userId == nil {
                   self.showAlert(message: "Please login to Continue")
               }
               else{

        if tag1 == 0 {
             profileArrow.image = UIImage(named: "down_arrow")
            view1Height.constant = 240
            subView1.isHidden = false
            tag1 = 1
        }
        else if tag1 == 1 {
             profileArrow.image = UIImage(named: "right_arrow")
            view1Height.constant = 50
            subView1.isHidden = true
            tag1 = 0
        }
        
        view2Height.constant = 50
        subView2.isHidden = true
        
        view3Height.constant = 50
        subView3.isHidden = true
        }
    }
    
    
    @IBOutlet var settingsArrow: UIImageView!
    @IBAction func settingsBtn_Tapped(_ sender: Any) {
        if userId == nil {
                   self.showAlert(message: "Please login to Continue")
               }
               else{

        if tag2 == 0 {
            
              settingsArrow.image = UIImage(named: "down_arrow")
            view2Height.constant = 190
            subView2.isHidden = false
            tag2 = 1
        }
        else if tag2 == 1 {
             settingsArrow.image = UIImage(named: "right_arrow")
            view2Height.constant = 50
            subView2.isHidden = true
            tag2 = 0
        }
        
        view1Height.constant = 50
        subView1.isHidden = true
        
        view3Height.constant = 50
        subView3.isHidden = true
        }
    }
    
    
    @IBOutlet var supportArrow: UIImageView!
    @IBAction func supportBtn_Tapped(_ sender: Any) {
        if userId == nil {
                   self.showAlert(message: "Please login to Continue")
               }
               else{

        if tag3 == 0 {
            supportArrow.image = UIImage(named: "down_arrow")
            view3Height.constant = 192
            subView3.isHidden = false
            tag3 = 1
        }
        else if tag3 == 1 {
             supportArrow.image = UIImage(named: "right_arrow")
            view3Height.constant = 60
            subView3.isHidden = true
            tag3 = 0
        }
        
        view1Height.constant = 50
        subView1.isHidden = true
        
        view2Height.constant = 50
        subView2.isHidden = true
        }
    }
    
    
    @IBAction func signOut_Tapped(_ sender: Any) {
        if userId == nil {
            //                signOutBtn.setTitle("SignIn", for: .normal)
            let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(initialVc, animated: true, completion: nil)
            
        }
        else{
            
            self.signOut()
            
        }
        //        self.signOut()
    }
    
    
    @IBAction func share_Tapped(_ sender: Any) {
        
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
        
    }
    
    
    
    func showAlert(message:String)
        {
            Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
        }
    
    
    
}
