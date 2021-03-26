//
//  FavouriteArticlesViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FavouriteArticlesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    

    @IBOutlet var alertView: UIView!
    
    @IBOutlet var ArticleTableView: UITableView!
    var isSubscribed : Bool = false

    
    var userId : String = ""
    var FavouriteArticles = [AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "Favourite Articles"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
              let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
              lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        
//              lefticonButton.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
              
              let leftbarButton = UIBarButtonItem(customView: lefticonButton)
              navigationItem.leftBarButtonItem = leftbarButton
              
        
        ArticleTableView.dataSource = self
        ArticleTableView.delegate = self
        self.ArticleTableView.isHidden = true
        self.ArticleTableView.tableFooterView = UIView()

        alertView.isHidden = true

        
        userId = UserDefaults.standard.string(forKey: "user_id")!
        print(userId)
        
        self.getUserData()

        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
             
        self.getFavouriteArticlesList()

    }
    
    func getUserData() {
        
        let paramsDict = [
            "lgw_user_id":self.userId]
        
        print(paramsDict)
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
    
    
    
    func getFavouriteArticlesList() {
        
        
        self.view.StartLoading()
        
        ApiManager().getRequestWithParameters(service: WebServices.FAVOURITE_ARTICLES + "/" + "\(userId)", params: [:], completion:
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
                    print("\(resultDictionary)")
                    
                    if let code : Int = resultDictionary["code"] as? Int {
                        print(code)
                        if code == 404 {
                            
                        }else{
                            
                        }
                    }else{
                        let response = result as! [String : Any]
                        let data = response ["data"] as! [String:Any]
                        print(data)
                        let categoryresponse = data ["response"] as! [String:Any]
                        let categorydata = categoryresponse ["data"] as! [String:Any]
                        
                        self.FavouriteArticles = (categorydata["articles_details"] as? [AnyObject]) != nil  ?  (categorydata["articles_details"] as! [AnyObject]) : []

                        // load table view data
                        if (self.FavouriteArticles.count > 0)
                        {
                            self.ArticleTableView.reloadData()
                            self.ArticleTableView.isHidden = false
                            
                        }
                        else{
                            self.ArticleTableView.isHidden = true
                            self.showAlert(message: "No Favourite List" )
                        }
                    }
                }
                
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.FavouriteArticles.count
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavArticlesTableViewCell") as! FavArticlesTableViewCell
        cell.ArticleTitleLbl.text = FavouriteArticles[indexPath.row]["title"] as? String
            cell.articleDescLbl.text = FavouriteArticles[indexPath.row]["short_description"] as? String
        cell.selectionStyle = .none
        
        return cell
        
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if isSubscribed {
            alertView.isHidden = true
            
           // let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
            
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesDetailsVC2SBID") as! ArticlesDetailsVC2
            
            //controller.articleId = FavouriteArticles[indexPath.row]["id"] as? Int
            controller.articleId = FavouriteArticles[indexPath.row]["article_id"] as? Int
            
            
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
             
             alertView.isHidden = false
            
        }
        
        
       
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 74
    }
    
    @IBAction func back_vc(_ sender: Any) {
          self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ok_Tapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubscriptionListViewController") as! SubscriptionListViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func cancel_Tapped(_ sender: Any) {
        
            alertView.isHidden = true
    }
    
    
    
    
    
//    @objc func goBack() {
//
//          self.navigationController?.popViewController(animated: true)
//
//      }
    
   func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
   

}
