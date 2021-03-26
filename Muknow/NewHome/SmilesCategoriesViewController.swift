//
//  SmilesCategoriesViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SmilesCategoriesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet var ContentTable: UITableView!
    var categoriesList = [AnyObject]()
    var dictObjects:[[String:Any]] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
               lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
               //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
               //
               let leftbarButton = UIBarButtonItem(customView: lefticonButton)
               //
               //
               let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
               righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
               righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
               //
               let rightbarButton = UIBarButtonItem(customView: righticonButton)
               //
               navigationItem.leftBarButtonItem = leftbarButton
               navigationItem.rightBarButtonItem = rightbarButton
               
        
        
        
        
        self.ContentTable.dataSource = self
        self.ContentTable.delegate = self
        self.ContentTable.tableFooterView = UIView()
        getAllSmilesCategoriesList()
        
    }
    var userId :String?

  
    @objc private func goToSearchPage() {
       
        
                 userId = UserDefaults.standard.string(forKey: "user_id")
            if userId != nil {//|| userId != "" {
                   let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "SmilesSearchViewController") as! SmilesSearchViewController
//                searchVc.hidesBottomBarWhenPushed = true

                   self.navigationController?.pushViewController(searchVc, animated: true)
               }
               else{
                   
                   self.showAlertWithAction(message: "Please login to continue")
                   
               }
        
        
        
//        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "LGWSearchViewController") as! LGWSearchViewController
//        self.navigationController?.pushViewController(searchVc, animated: true)
        
    }
    
//    func showAlertWithAction(message:String)
//    {
//        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToLogin), Controller: self)], Controller: self)
//    }
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
          let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
         self.navigationController?.pushViewController(LoginController, animated: true)
      }
    
    
    func getAllSmilesCategoriesList()
    {
        
//        self.view.StartLoading()
//        ApiManager().getRequest(service:WebServices.SMILES_CATEGORIES)
//        { (result, success) in
        
        self.view.StartLoading()
        
        ApiManager().getRequestWithParameters(service: WebServices.SMILES_CATEGORIES, params: [:], completion:
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
                let data = response ["data"] as! [String:Any]
                print(data)
                let categoryresponse = data ["response"] as! [String:Any]
                let categorydata = categoryresponse ["data"] as! [String:Any]

                self.categoriesList = (categorydata["categories"] as? [AnyObject]) != nil  ?  (categorydata["categories"] as! [AnyObject]) : []

                var dict:[String:Any] = [:]

                for i in self.categoriesList {
                    dict["Smiles_Categories"] = i
                    dict["isSelected"] = 0

                    self.dictObjects.append(dict)
                }

               // print(self.categoriesList)
                if (self.categoriesList.count > 0)
                {

                    self.ContentTable.reloadData()

                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           let dictObj = dictObjects[indexPath.section]
           let isSelected = dictObj["isSelected"] as? Int
           if isSelected == 0 {
               return 60
               
           }else{
               if indexPath.row == 0 {
                   return 60
               }else{
                   return 45
               }
           }
           
       }
       
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dictObj = dictObjects[section]
        print(dictObj)
     
        let List = dictObj["Smiles_Categories"] as! NSDictionary
        
        let Subcategories = List["subcategories"] as! NSArray
        
        
        let isSelected:Int = dictObj["isSelected"] as! Int
        if isSelected == 1 {
           
                 return Subcategories.count + 1
           
        } else {
            return 1
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictObjects.count
    }
    

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
                let dictObj = dictObjects[indexPath.section]
                let isSelected = dictObj["isSelected"] as? Int
                if isSelected == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
                      let List = dictObj["Smiles_Categories"] as! NSDictionary
                    
                    cell!.contentTitleLbl.text = List["name"] as? String ?? ""
                    
                    let image =  "\(WebServices.ARTICLE_BASE_URL)\(List["photo_cat_thumb"] as! String)"
                    
                    cell!.categoriesImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))

                    cell!.selectionStyle = .none

                    return cell!
                } else {
                 
                    if indexPath.row == 0 {
        //                cell!.customCellLbl.text = dictObj["name"] as? String ?? ""
                        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
                        let List = dictObj["Smiles_Categories"] as! NSDictionary
                        
                        cell!.contentTitleLbl.text = List["name"] as? String ?? ""
                        
                        let image =  "\(WebServices.ARTICLE_BASE_URL)\(List["photo_cat_thumb"] as! String)"

                        cell!.categoriesImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))
                        

                    return cell!
                        
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
                        
                        let List = dictObj["Smiles_Categories"] as! NSDictionary
                        let Subcategories = List["subcategories"] as! NSArray
                        print(Subcategories)
                        
//                        cell!.contentSubCategoryLbl.text = List["name"] as? String
                        
                        let dict = Subcategories[indexPath.row - 1] as! NSDictionary
                        cell!.contentSubCategoryLbl.text = dict["name"] as? String

                        cell!.selectionStyle = .none

                        return cell!
                    }
                }
            }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
        
        var dictObj = dictObjects[indexPath.section]
        let isSelected = dictObj["isSelected"] as? Int
        if isSelected == 0 {
            
            //                cell!.rightArrImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            
            dictObj["isSelected"] = 1
            dictObjects[indexPath.section] = dictObj
            ContentTable.reloadData()
            
        } else {
            
            if indexPath.row == 0 {
                dictObj["isSelected"] = 0
                dictObjects[indexPath.section] = dictObj
                ContentTable.reloadData()
                //                    cell!.rightArrImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3)
            }else{
                
                var dictObj = dictObjects[indexPath.section]
                
                dictObj["isSelected"] = 1
                let List = dictObj["Smiles_Categories"] as! NSDictionary
                let Subcategories = List["subcategories"] as! NSArray
                
                let dict = Subcategories[indexPath.row - 1] as! NSDictionary
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesListViewController") as! ArticlesListViewController
                controller.hidesBottomBarWhenPushed = true
                controller.articleTitle = dict["name"] as? String
                controller.articleId = dict["id"] as? Int
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    @IBAction func back_vc(_ sender: Any) {
        
        /*
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController
        
        nextViewController.selectedIndex = 0

        self.present(nextViewController, animated: true, completion: nil) */
       
    }
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }

    
    @IBAction func homeBtnTapped(_ sender: UIButton) {
           
           //self.navigationController?.viewControllers.removeAll()
     //self.navigationController?.popToRootViewController(animated: true)
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
         /*
         //SmilesCategoriesViewController
           //self.navigationController?.viewControllers.removeAll()
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let courseViewController = storyboard.instantiateViewController(withIdentifier: "SmilesCategoriesViewController")
           self.navigationController?.pushViewController(courseViewController, animated: false) */
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
