//
//  SmilesSearchViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SmilesSearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    
    @IBOutlet var searchTxt: UITextField!
    
    @IBOutlet var keywordTV: UITableView!
    var keywordArr = [String]()
     var userId :String?

     
    
    @IBOutlet var SearchResultsTV: UITableView!
    var SearchResults_Arr = [AnyObject]()

    var isSubscribed : Bool = false
    @IBOutlet var alertView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        lefticonButton.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        userId = UserDefaults.standard.string(forKey: "user_id")
//        userId = UserDefaults.standard.string(forKey: "user_id")
        
         keywordArr = UserDefaults.standard.object(forKey: "Article_SearchKeywords") as? [String] ?? []
        
        
        self.keywordTV.dataSource = self
        self.keywordTV.delegate = self
        self.keywordTV.separatorColor = .clear
        self.keywordTV.isHidden = false
        self.keywordTV.tableFooterView = UIView.init(frame: CGRect.zero)
        self.keywordTV.reloadData()
        
        searchTxt.delegate = self
        
        self.SearchResultsTV.dataSource = self
        self.SearchResultsTV.delegate = self
        self.SearchResultsTV.isHidden = true
        
        self.SearchResultsTV.tableFooterView = UIView()
        
        getUserData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        alertView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(keywordArr, forKey: "Article_SearchKeywords")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == keywordTV {
             return keywordArr.count
        }else{
            return SearchResults_Arr.count
        }
      
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == keywordTV {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell")as! SearchTableViewCell
            cell.searchHistoryLbl.text = keywordArr[indexPath.row]
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
            
            cell!.searchTitleLbl.text = SearchResults_Arr[indexPath.row]["title"] as? String ?? ""
            cell!.searchDescLbl.text = SearchResults_Arr[indexPath.row]["short_description"] as? String ?? ""
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == keywordTV {
            let selectedStr = self.keywordArr[indexPath.row]
            callFilterService(searchStr: selectedStr)
            self.keywordTV.isHidden = true
        }
        else{
            
            /*
              let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticleDetailsViewController") as! ArticleDetailsViewController
             controller.hidesBottomBarWhenPushed = true
            controller.articleId = SearchResults_Arr[indexPath.row]["id"] as? Int

              self.navigationController?.pushViewController(controller, animated: true) */
            alertView.isHidden = true
            if isSubscribed {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ArticlesDetailsVC2SBID") as! ArticlesDetailsVC2
                controller.hidesBottomBarWhenPushed = true
                controller.articleId = SearchResults_Arr[indexPath.row]["id"] as? Int
                self.navigationController?.pushViewController(controller, animated: true)
            }else{
                print("user Not subscribed....")
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == keywordTV {
           return 47
        }else{
              return 87
        }
       }
       
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        keywordTV.isHidden = true
        if !keywordArr.contains(searchTxt.text!) {
            keywordArr.append(searchTxt.text!)
        }
        searchTxt.resignFirstResponder()
        callFilterService(searchStr: searchTxt.text!)
        return true
        
    }

    @IBAction func search_Tapped(_ sender: Any) {
        keywordTV.isHidden = true
        if !keywordArr.contains(searchTxt.text!) {
            keywordArr.append(searchTxt.text!)
        }
        searchTxt.resignFirstResponder()
        callFilterService(searchStr: searchTxt.text!)
    }
    
    func callFilterService(searchStr : String)
    {
        
        let params = ["keyword":searchStr,"lgw_user_id":userId!] as [String:Any]
        print(params)
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.SMILES_SEARCH, params: params) { (result, success) in
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
                
                
                if let code : Int = resultDictionary["code"] as? Int {
                    print(code)
                    if code == 404 {
                        self.showAlert(message: resultDictionary["error"] as! String)
                    }else{
                        
                    }
                }
                else{
                    print(resultDictionary) 
                    
                    let response = resultDictionary
                    let data = response ["data"] as! [String:Any]
                    let articlesresponse = data ["response"] as! [String:Any]
                    let categorydata = articlesresponse ["data"] as! [String:Any]
                    
                    self.SearchResults_Arr = (categorydata["articles_details"] as? [AnyObject]) != nil  ?  (categorydata["articles_details"] as! [AnyObject]) : []
                    
                    if self.SearchResults_Arr.count > 0 {
                        self.SearchResultsTV.isHidden = false
                    }else{
                        self.SearchResultsTV.isHidden = true
                        self.showAlert(message: "No Data")
                    }
                    
                    self.SearchResultsTV.reloadData()
                }
            }
        }
    }
    
    
      func showAlert(message:String)
      {
          Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
      }
      
    
    
    @objc func goBack() {
        
        self.navigationController?.popViewController(animated: true)
        
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
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        
        //self.navigationController?.viewControllers.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewController(withIdentifier: "NewHomeViewControllerSBID")
        self.navigationController?.pushViewController(courseViewController, animated: true)
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func categoriesBtnTapped(_ sender: UIButton) {
        //self.navigationController?.viewControllers.removeAll()
        //self.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesVCSBID")
        self.navigationController?.pushViewController(courseViewController, animated: false)
    }
    
    
    @IBAction func microLearningBtnTapped(_ sender: UIButton) { //SmilesCategoriesViewController
        //self.navigationController?.viewControllers.removeAll()
        //self.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewController(withIdentifier: "SmilesCategoriesViewController")
        self.navigationController?.pushViewController(courseViewController, animated: false)
    }
    
    @IBAction func coursesBtnTapped(_ sender: UIButton) {
        //self.navigationController?.viewControllers.removeAll()
        //self.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewController(withIdentifier: "CourseHistoryViewController")
        self.navigationController?.pushViewController(courseViewController, animated: false)
    }
    
    @IBAction func notificationBtnTapped(_ sender: UIButton) {
        //self.navigationController?.viewControllers.removeAll()
        //self.navigationController?.popToRootViewController(animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController")
        self.navigationController?.pushViewController(courseViewController, animated: false)
    }
    
    @IBAction func profileBtnTapped(_ sender: UIButton) {
        //self.navigationController?.viewControllers.removeAll()
        //self.navigationController?.popToRootViewController(animated: true)
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
