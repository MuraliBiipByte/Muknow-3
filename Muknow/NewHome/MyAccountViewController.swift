//
//  MyAccountViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.


import UIKit

class MyAccountViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var PrifileNamesArr = [String]()
    var ProfileImgArr = [UIImage]()
    var userId : String?
    var username : String = ""
    var userEmail : String = ""

    
    @IBOutlet var ProfileTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        self.PrifileNamesArr = ["My Profile","Transaction History","Referral History","Settings","Support","Log Out"];

        self.ProfileImgArr = [UIImage(named:"User")!,UIImage(named:"TransationHistory")!,UIImage(named:"Referral")!,UIImage(named:"Settings")!,UIImage(named:"Help-hand")!,UIImage(named:"Logout")!]
        
        self.ProfileTable.dataSource = self
        self.ProfileTable.delegate = self
        self.ProfileTable.separatorColor = .clear
        
        
          userId = UserDefaults.standard.string(forKey: "user_id")
//        print(userId!)
          if userId == nil {
            self.PrifileNamesArr[5] = "Login"
//
//              signOutBtn.setTitle("SignIn", for: .normal)
//              self.showAlert(message: "Please login to Continue")
          }
          else{
//
              username = UserDefaults.standard.object(forKey: "user_name") as! String
              userEmail = UserDefaults.standard.object(forKey: "user_email") as! String
//              signOutBtn.setTitle("Sign Out", for: .normal)
//              self.getUserData()
//
          }
        
    }
    
    
    

       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            return PrifileNamesArr.count
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell")as! ProfileTableViewCell
            
           
            
        cell.prifileNameLbl.text = PrifileNamesArr[indexPath.row]
        cell.profileImg.image = self.ProfileImgArr[indexPath.row]
           
        cell.selectionStyle = .none
        
            return cell
        }
  

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if userId == nil {
//
            if  indexPath.row == 5 {

                removeObjects()
                let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(initialVc, animated: true, completion: nil)
            }else{
                //self.showAlert(message: "Please login to Continue")
                self.showAlertWithAction(message: "Please login to Continue")
                
            }
        }
        else{
            
            if indexPath.row == 0 {
                
                let userVC = self.storyboard?.instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
                userVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(userVC, animated: true)
                
                
            }else if indexPath.row == 1 {
                
                let transactionVC = self.storyboard?.instantiateViewController(withIdentifier: "TransactionHistoryViewController") as! TransactionHistoryViewController
                transactionVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(transactionVC, animated: true)
                
                
            }
            else if indexPath.row == 2 {
                let referralVC = self.storyboard?.instantiateViewController(withIdentifier: "ReferralHistoryViewController") as! ReferralHistoryViewController
                referralVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(referralVC, animated: true)

                
            }
            else if indexPath.row == 3 {
                
                let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
                settingVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(settingVC, animated: true)
                
                
            }else if indexPath.row == 4 {
                
                
                let supportVC = self.storyboard?.instantiateViewController(withIdentifier: "SupportViewController") as! SupportViewController
                supportVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(supportVC, animated: true)
                
                
                
            }

           if  indexPath.row == 5 {
               
               removeObjects()
               let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
               //self.present(initialVc, animated: true, completion: nil)
            self.navigationController?.present(initialVc, animated: true, completion: nil)
           }
        }
    }
    
    
    
    func removeObjects() {
        UserDefaults.standard.set(nil, forKey: "user_id")
        UserDefaults.standard.set(nil, forKey: "user_name")
        UserDefaults.standard.set(nil, forKey: "user_email")
        UserDefaults.standard.set(nil, forKey: "access_token")
        UserDefaults.standard.set(nil, forKey: "user_mobile")
        
        UserDefaults.standard.set(nil, forKey: "SearchKeywords")
        //UserDefaults.standard.set(nil, forKey: "user_image")
        UserDefaults.standard.set(nil, forKey: "profile_image_URL_From_Login")
        UserDefaults.standard.set(nil, forKey: "ProfileImgWritten")
        
        self.deleteModuleIcons()
    }
    
    func deleteModuleIcons() {
        let fileManager = FileManager.default
        let folderPath = self.getModuleIconFolderPath()
        do{
            try fileManager.removeItem(atPath: folderPath.path)
        }catch{
        }
    }
    
    //MARK:ModuleIconFolder Path
    func getModuleIconFolderPath()->URL
    {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[urls.count - 1] as URL
        let folderPath = documentsDirectory.appendingPathComponent("ModuleIcons")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: folderPath.path)
        {
            //NSLog("ModuleIcons Folder Exists")
            print("ModuleIcons Folder Exists")
        }
        else
        {
            do {
                try fileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                //print(error.localizedDescription);
            }
        }
        
        return folderPath
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func showAlert(message:String)
        {
            Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
        }
    func showAlertWithAction(message:String)
       {
  
         Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToLogin), Controller: self),Message.AlertActionWithSelector(Title: "Cancel", Selector:#selector(cancelTapped), Controller: self)], Controller: self)
       }
    
    @objc func cancelTapped()
       {
           print("Cancel tapped...")
       }
    
    @objc func goToLogin()
    {
        let changePwVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(changePwVc, animated: true, completion: nil)
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
         
         @IBAction func coursesBtnTapped(_ sender: UIButton) {
             //self.navigationController?.viewControllers.removeAll()
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let courseViewController = storyboard.instantiateViewController(withIdentifier: "CourseHistoryViewController")
             self.navigationController?.pushViewController(courseViewController, animated: false)
         }
         
         @IBAction func notificationBtnTapped(_ sender: UIButton) {
             //self.navigationController?.viewControllers.removeAll()
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let courseViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController")
             self.navigationController?.pushViewController(courseViewController, animated: false)
         }
         
         @IBAction func profileBtnTapped(_ sender: UIButton) {
            /*
             //self.navigationController?.viewControllers.removeAll()
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let courseViewController = storyboard.instantiateViewController(withIdentifier: "MyAccountViewController")
             self.navigationController?.pushViewController(courseViewController, animated: true) */
         }
         
         @IBOutlet weak var homeBtn: UIButton!
         @IBOutlet weak var categoriesBtn: UIButton!
         @IBOutlet weak var microLearningBtn: UIButton!
         @IBOutlet weak var coursesBtn: UIButton!
         @IBOutlet weak var notificationBtn: UIButton!
         @IBOutlet weak var profileBtn: UIButton!
    
}
