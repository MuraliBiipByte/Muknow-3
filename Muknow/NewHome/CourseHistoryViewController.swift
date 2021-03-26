//
//  CourseHistoryViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class CourseHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var SectionArr1 = [String]()
    var SectionArr2 = [String]()
    var userId :String?

    @IBOutlet var historyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
       
        
        historyTable.dataSource = self
        historyTable.delegate = self
        self.historyTable.tableFooterView = UIView.init(frame: CGRect.zero)
        SectionArr1 = ["My Favourite Courses","My Booking History","My Coupons"]
        SectionArr2 = ["My Favourite Articles"]
        userId = UserDefaults.standard.string(forKey: "user_id")

    }
    
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return SectionArr1.count
        } else {
            return SectionArr2.count
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "My Courses"
//        } else {
//            return "Micro-Learning"
//        }
//    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30))
        view.backgroundColor = .lightGray
        let label = UILabel(frame: CGRect(x: 5, y: 0, width: view.frame.size.width - 5, height: 30))
        label.backgroundColor = .clear
        
          if section == 0 {
            label.text = "My Courses"
          }else{
            label.text = "Micro-Learning"
        }
        
            
        label.textColor = UIColor.white

        view.addSubview(label)
            self.view.addSubview(view)

            return view
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
      
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell") as! HistoryTableViewCell
        
         if indexPath.section == 0 {
            cell.coursesLbl.text = SectionArr1[indexPath.row]
         }else{
             cell.coursesLbl.text = SectionArr2[indexPath.row]
        }
        
        cell.selectionStyle = .none
            return cell
      

    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if userId == nil || userId == "" {
            self.showAlertWithAction(message:"Please Login to Continue")
            //self.showAlert(message: "Please Login to Continue")
        }else{
            
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteCoursesViewController") as! FavouriteCoursesViewController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                if indexPath.row == 1 {
                    
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyCourseHistoryVC") as! MyCourseHistoryVC
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyCourseHistoryVC2SBID") as! MyCourseHistoryVC2
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else if indexPath.row == 2 {
                    // my coupons Navigation
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyCouponsViewController") as! MyCouponsViewController
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)

                    
                }
                
            }else{
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "FavouriteArticlesViewController") as! FavouriteArticlesViewController
                
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
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
         
        /*
        //self.navigationController?.viewControllers.removeAll()
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let courseViewController = storyboard.instantiateViewController(withIdentifier: "CourseHistoryViewController")
         self.navigationController?.pushViewController(courseViewController, animated: false) */
     }
     
     @IBAction func notificationBtnTapped(_ sender: UIButton) {
         //self.navigationController?.viewControllers.removeAll()
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let courseViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController")
         self.navigationController?.pushViewController(courseViewController, animated: false)
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
     @IBOutlet weak var coursesBtn: UIButton!
     @IBOutlet weak var notificationBtn: UIButton!
     @IBOutlet weak var profileBtn: UIButton!
    
}
