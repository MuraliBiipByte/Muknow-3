//
//  ArticlesListViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ArticlesListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    var articleId : Int?
    var articleTitle : String?
    var userId :String?
    var ArrTotalArticlesList = [AnyObject]()
    var Articles_List = [AnyObject]()
//    var List : NSArray!
    
    var dictionaries = [[String: Any]]()
    
    @IBOutlet var titleStr: UILabel!
    @IBOutlet var ArticlesTV: UITableView!
    @IBOutlet var alertView: UIView!
    var isSubscribed : Bool = false
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
         lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
         //   btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
         
         
         let leftbarButton = UIBarButtonItem(customView: lefticonButton)
         
         let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
         righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
         //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
         
         let rightbarButton = UIBarButtonItem(customView: righticonButton)
         
         navigationItem.leftBarButtonItem = leftbarButton
         navigationItem.rightBarButtonItem = rightbarButton
        
        
       
        userId = UserDefaults.standard.string(forKey: "user_id")

        self.titleStr.text = articleTitle
        
        self.getUserData()
    }
    
    @objc private func goToSearchPage() {
        
        userId = UserDefaults.standard.string(forKey: "user_id")
        if userId != nil { // || userId != "" { if userId != nil {//|| userId != "" {
            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "SmilesSearchViewController") as! SmilesSearchViewController
            self.navigationController?.pushViewController(searchVc, animated: true)
        }
        else{
            self.showAlertWithAction(message: "Please login to continue")
        }
        
    }
    
    func getUserData() {
        
        
        userId = UserDefaults.standard.string(forKey: "user_id")
        
        var paramsDict = [String:String]()
        if userId == nil || userId == "" {
            paramsDict = ["lgw_user_id":""]
            print(paramsDict)
        }else{
            paramsDict = ["lgw_user_id":self.userId!]
            print(paramsDict)
        }
        
        
        /*
        let paramsDict = [
            "lgw_user_id":self.userId!]
        
        print(paramsDict) */
        
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
                
                print(resultDictionary)
                let data = resultDictionary ["data"] as! [String:Any]
                let UserData = data ["response"] as! [String:Any]
                
                let status = UserData["status"] as! String
                
                if status == "1" {
                    
                 //   UserDefaults.standard.set(status, forKey: "SubscriptionStatus")
                    self.isSubscribed = true
                    
                }else{
                  //   UserDefaults.standard.set(status, forKey: "SubscriptionStatus")
                    self.isSubscribed = false
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.ArticlesTV.dataSource = self
        self.ArticlesTV.delegate = self
        self.ArticlesTV.tableFooterView = UIView()
        self.ArticlesTV.isHidden = true
        self.ArticlesTV.rowHeight = UITableView.automaticDimension
//        self.ArticlesTV.separatorColor = UIColor.black
        
        alertView.isHidden = true

        
        self.getAllArticlesList()
    }
    
    func getAllArticlesList()
    {
        
        let totalStr = WebServices.SMILES_ARTICLES + "/" +
        "\(articleId!)"
 
        self.view.StartLoading()
        ApiManager().getRequest(service:totalStr)
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
                        
                    }else{
                        
                    }
                }else{
                  
                    let data = response ["data"] as! [String:Any]
                    let categoryresponse = data ["response"] as! [String:Any]
                    let categorydata = categoryresponse ["data"] as! [String:Any]
                    
                    self.ArrTotalArticlesList = (categorydata["articles_list"] as? [AnyObject]) != nil  ?  (categorydata["articles_list"] as! [AnyObject]) : []
                    
                    if (self.ArrTotalArticlesList.count > 0)
                    {
                        self.ArticlesTV.reloadData()
                        self.ArticlesTV.isHidden = false
                        
                    }
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
     //  print(ArrArticlesList)
        if ArrTotalArticlesList.isEmpty {
            return ArrTotalArticlesList.count
        }else{
            self.Articles_List = ArrTotalArticlesList[0] as! [AnyObject]
            
            return self.Articles_List.count
        }
        
           
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
     
        cell!.selectionStyle = .none
        self.Articles_List = ArrTotalArticlesList[0] as! [AnyObject]
        cell!.articleTitleLbl.text = Articles_List[indexPath.row]["title"] as? String ?? ""
        cell!.articleDescLbl.text = Articles_List[indexPath.row]["short_description"] as? String ?? ""
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if userId == "" || userId == nil {
           
            //self.showAlert(message: "Please login to Continue")
            self.showAlertWithAction(message: "Please login to Continue")
            
        }else{
            if isSubscribed {
                alertView.isHidden = true
                
//                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
                
//                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesDetailsVCSBID") as! ArticlesDetailsVC
                
//                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesDetailsVCTest1SBID") as! ArticlesDetailsVCTest1
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesDetailsVC2SBID") as! ArticlesDetailsVC2
                self.Articles_List = ArrTotalArticlesList[0] as! [AnyObject]
                controller.articleId = Articles_List[indexPath.row]["id"] as? Int
                
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                alertView.isHidden = false
            }
        }
    }
    
    @IBAction func ok_Tapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListViewController") as! SubscriptionListViewController
        vc.subcriptionstatus = isSubscribed ? "1" : "0"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancel_Tapped(_ sender: Any) {
            alertView.isHidden = true
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
            if let viewControllers = self.navigationController?.viewControllers {
                        for viewController in viewControllers {
                            if viewController.isKind(of: NewHomeViewController.self) {
                                print("Your controller exist")
                            }
                   }
            }
            
             let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
           self.navigationController?.present(LoginController, animated: true, completion: nil)
         }

    @IBAction func backVC(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    
}
