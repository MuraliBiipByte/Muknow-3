//
//  NewHomeViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class NewHomeViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet var featuredViewHeight: NSLayoutConstraint!
    @IBOutlet var featuredCollectionView: UICollectionView!
    @IBOutlet var popularCollectionView: UICollectionView!
    @IBOutlet var popularviewHeight: NSLayoutConstraint!
    @IBOutlet var latestCollectionView: UICollectionView!
    @IBOutlet var latestViewHeight: NSLayoutConstraint!
    @IBOutlet var favouritesViewHeight: NSLayoutConstraint!
    @IBOutlet var favouriteCollectionView: UICollectionView!
    @IBOutlet var favouritesView: UIView!
    
    var featuredCourses = [AnyObject]()
    var latestCourses = [AnyObject]()
    var popularCourses = [AnyObject]()
    var favouriteCourses = [AnyObject]()
    
    var favouritesArr = NSDictionary()
    
    var userId :String?
    var userEmail :String?
    var userPassword :String?
    
//    @IBOutlet weak var loaderFeatured: UIActivityIndicatorView!
//    @IBOutlet weak var loaderPopular: UIActivityIndicatorView!
//    @IBOutlet weak var loaderLatest: UIActivityIndicatorView!
//    @IBOutlet weak var loaderFavourite: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
        
        let rightbarButton = UIBarButtonItem(customView: righticonButton)
        
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = rightbarButton
        
        self.featuredViewHeight.constant = 0
        self.featuredCollectionView.isHidden = true
        
        self.popularviewHeight.constant = 0
        self.popularCollectionView.isHidden = true
        
        self.latestViewHeight.constant = 0
        self.latestCollectionView.isHidden = true
        
        self.favouritesViewHeight.constant = 0
        self.favouriteCollectionView.isHidden = true
        self.favouritesView.isHidden = true
    }
    
        override func viewWillAppear(_ animated: Bool) {
            
            userId = UserDefaults.standard.string(forKey: "user_id")
            if userId == nil || userId == "" {
                self.getAllCoursesDataWithoutLogin()
            }
            else{
                userEmail = UserDefaults.standard.object(forKey: "user_email") as? String
             //   print(userEmail!)
                userPassword = UserDefaults.standard.string(forKey: "user_password")
                self.getAccessToken()
            }
        }
    func getAccessToken () {
        
        let paramsDict = [
            "email":self.userEmail!,
            "password":self.userPassword!]

           print("\(paramsDict)")

        self.view.StartLoading()
        ApiManager().postRequestToGetAccessToken(service:WebServices.APP_ACCESS_TOKEN, params: paramsDict as [String : Any])
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
                     print("\(resultDictionary)")
                    
                    let access_token = resultDictionary["access_token"] as! String
                  
                    UserDefaults.standard.set(access_token, forKey: "access_token")
                  
                    self.GetCoursesDataWithLogin()

                  }

              }
    }
    
    @objc private func goToSearchPage() {
                //let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "LGWSearchViewController") as! LGWSearchViewController
        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "LGWSearchVCSBID") as! LGWSearchVC
    //        searchVc.hidesBottomBarWhenPushed = true
        
        
                self.navigationController?.pushViewController(searchVc, animated: true)
        
            }
    
    func GetCoursesDataWithLogin() {
        
        
        let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
        
        let params = ["token":accessToken] as [String:Any]
        self.view.StartLoading()
        print(params)
        
        ApiManager().postRequest(service: WebServices.HOME_LOGIN, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                
                return
                
            }
            else
            {
                let response = result as! [String : Any]
                print(response)
                
                self.featuredCourses = (response["data_feautred"] as? [AnyObject]) != nil  ?  (response["data_feautred"] as! [AnyObject]) : []
                
                
                if (self.featuredCourses.count > 0)
                {
                    self.featuredCollectionView.isHidden = false
                    self.featuredViewHeight.constant = 160
                    self.featuredCollectionView.reloadData()
                }
                
                
                self.latestCourses = (response["data_latest"] as? [AnyObject]) != nil  ?  (response["data_latest"] as! [AnyObject]) : []
                
                if (self.latestCourses.count > 0)
                {
                    self.latestCollectionView.isHidden = false
                    self.latestViewHeight.constant = 160
                    self.latestCollectionView.reloadData()
                }
                
                
                
                self.popularCourses = (response["data_popular"] as? [AnyObject]) != nil  ?  (response["data_popular"] as! [AnyObject]) : []
                
                if (self.popularCourses.count > 0)
                {
                    self.popularCollectionView.isHidden = false
                    self.popularviewHeight.constant = 160
                    self.popularCollectionView.reloadData()
                }
                
              //  var favCourses = [AnyObject]()
                   
                var favOriginalArr = NSDictionary()

                
                if response["data_favourite"] != nil {
                    
                    
                    self.favouritesArr = response["data_favourite"] as! NSDictionary
                    
                    
                    
                    
                    favOriginalArr = self.favouritesArr["original"] as! NSDictionary
                    
                    
                    self.favouriteCourses = (favOriginalArr["data"] as? [AnyObject]) != nil  ?  (favOriginalArr["data"] as! [AnyObject]) : []
                    //
                    print(self.favouriteCourses)
                    //
                    //
                    if (self.favouriteCourses.count > 0)
                    {
                        self.favouriteCollectionView.isHidden = false
                        self.favouritesView.isHidden = false
                        self.favouritesViewHeight.constant = 215
                        self.favouriteCollectionView.reloadData()
                    }
                    
                }
                
            }
            
        }
        
        
        
        
    }
    
    
    func getAllCoursesDataWithoutLogin()
    {
        ApiManager().getRequest(service:WebServices.HOME_COURSES)
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
                print(response)
                
                self.featuredCourses = (response["data_feautred"] as? [AnyObject]) != nil  ?  (response["data_feautred"] as! [AnyObject]) : []
                
                
                if (self.featuredCourses.count > 0)
                {
                    self.featuredCollectionView.isHidden = false
                    self.featuredViewHeight.constant = 160
                    self.featuredCollectionView.reloadData()
                }
                
                
                self.latestCourses = (response["data_latest"] as? [AnyObject]) != nil  ?  (response["data_latest"] as! [AnyObject]) : []
                
                if (self.latestCourses.count > 0)
                {
                    self.latestCollectionView.isHidden = false
                    self.latestViewHeight.constant = 160
                    self.latestCollectionView.reloadData()
                }
                
                self.popularCourses = (response["data_popular"] as? [AnyObject]) != nil  ?  (response["data_popular"] as! [AnyObject]) : []
                
                if (self.popularCourses.count > 0)
                {
                    self.popularCollectionView.isHidden = false
                    self.popularviewHeight.constant = 160
                    self.popularCollectionView.reloadData()
                }
                
                var favOriginalArr = NSDictionary()
                
                
                if response["data_favourite"] != nil {
                    
                    
                    self.favouritesArr = response["data_favourite"] as! NSDictionary
                    
                    
                    
                    
                    favOriginalArr = self.favouritesArr["original"] as! NSDictionary
                    
                    
                    self.favouriteCourses = (favOriginalArr["data"] as? [AnyObject]) != nil  ?  (favOriginalArr["data"] as! [AnyObject]) : []
                    //
                    print(self.favouriteCourses)
                    //
                    //
                    if (self.favouriteCourses.count > 0)
                    {
                        self.favouriteCollectionView.isHidden = false
                        self.favouritesView.isHidden = false
                        self.favouritesViewHeight.constant = 215
                        self.favouriteCollectionView.reloadData()
                    }
                    
                }
                             
                
                
                
                
             
                
            }
        }
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
       {
           
           if collectionView == featuredCollectionView
           {
               return featuredCourses.count
           }else if collectionView == popularCollectionView {
               return popularCourses.count
           }else if collectionView == latestCollectionView{
               return latestCourses.count
           }else {
               return favouriteCourses.count
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
       {
           
           let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
               "NewHomeCollectionViewCell", for: indexPath) as! NewHomeCollectionViewCell
           
           if collectionView == featuredCollectionView
           {
               
               cell.contentView.layer.cornerRadius = 8
               cell.contentView.layer.masksToBounds = true
               
            let imageURL =  "\(WebServices.BASE_URL)\(self.featuredCourses[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
               print(imageURL)
            if (imageURL!.hasSuffix(".pdf")){
                   cell.imgFeatured.contentMode = .scaleAspectFit
                   
               }else{
                   cell.imgFeatured.contentMode = .scaleAspectFill
               }
               
            cell.myLoader.isHidden = false
            cell.myLoader.startAnimating()
            cell.imgFeatured.loadImageUsingCacheWithURLString(imageURL!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
//            cell.imgFeatured.sd_setImage(with: URL(string: imageURL!), placeholderImage: UIImage(named: "PlaceholderImg"))
               
               cell.featuredTagName.text = self.featuredCourses[indexPath.row]["title"] as? String
               
               cell.featuredPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.featuredCourses[indexPath.row]["price"]! ?? "0")")!])
               
           
               if let isLearning = self.featuredCourses[indexPath.row]["is_elearning"] as? Int {
                   
                   if isLearning == 0 {
                       cell.featuredIsLearning.isHidden = true
                   }else{
                        cell.featuredIsLearning.isHidden = false
                   }
               }else{
                    cell.featuredIsLearning.isHidden = true
               }
               
               
               if let sfcBooking = self.featuredCourses[indexPath.row]["skills_future_credit_claimable"] as? Int {
                   if sfcBooking == 0 {
                        cell.featuredSFC.isHidden = true
                   }
                   else{
                         cell.featuredSFC.isHidden = false
                   }
               }else{
                    cell.featuredSFC.isHidden = true
               }
               
               
               if let wscBooking = self.featuredCourses[indexPath.row]["is_wsq"] as? Int {
                   if wscBooking == 0 {
                       cell.featuredWSQ.isHidden = true
                   }
                   else {
                       cell.featuredWSQ.isHidden = false
                   }
               }else
               {
                    cell.featuredWSQ.isHidden = true
               }
               
           }
           
           if collectionView == popularCollectionView
           {
               
               cell.contentView.layer.cornerRadius = 8
               cell.contentView.layer.masksToBounds = true
               
            let imageURL =  "\(WebServices.BASE_URL)\(self.popularCourses[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if (imageURL!.hasSuffix(".pdf")){
                   cell.imgPopular.contentMode = .scaleAspectFit
                   
               }else{
                   cell.imgPopular.contentMode = .scaleAspectFill
               }
               
//            cell.imgPopular.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "PlaceholderImg"))
            
            cell.myLoader.isHidden = false
            cell.myLoader.startAnimating()
            cell.imgPopular.loadImageUsingCacheWithURLString(imageURL!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
               
            cell.popularTagName.text = self.popularCourses[indexPath.row]["title"] as? String
               
             
            cell.popularPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.popularCourses[indexPath.row]["price"]! ?? "0")")!])
                   
               if let isLearning = self.popularCourses[indexPath.row]["is_elearning"] as? Int {
                   
                   if isLearning == 0 {
                       cell.popularElearning.isHidden = true
                   }else{
                       cell.popularElearning.isHidden = false
                   }
               }else{
                   cell.popularElearning.isHidden = true
               }
               
               
                         
                         if let sfcBooking = self.popularCourses[indexPath.row]["skills_future_credit_claimable"] as? Int {
                             if sfcBooking == 0 {
                                  cell.popularSFC.isHidden = true
                             }
                             else{
                                   cell.popularSFC.isHidden = false
                             }
                         }else{
                              cell.popularSFC.isHidden = true
                         }
                         
                  
                         if let wscBooking = self.popularCourses[indexPath.row]["is_wsq"] as? Int {
                             if wscBooking == 0 {
                                 cell.popularWSQ.isHidden = true
                             }
                             else {
                                 cell.popularWSQ.isHidden = false
                             }
                         }else
                         {
                              cell.popularWSQ.isHidden = true
                         }
                     
               
           }
           
           if collectionView == latestCollectionView
           {
               
               cell.contentView.layer.cornerRadius = 8
               cell.contentView.layer.masksToBounds = true
               
            let imageURL =  "\(WebServices.BASE_URL)\(self.latestCourses[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if (imageURL!.hasSuffix(".pdf")){
                   cell.imglatestCourses.contentMode = .scaleAspectFit
                   
               }else{
                   cell.imglatestCourses.contentMode = .scaleAspectFill
               }
               
//            cell.imglatestCourses.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "PlaceholderImg"))
            cell.myLoader.isHidden = false
            cell.myLoader.startAnimating()
            cell.imglatestCourses.loadImageUsingCacheWithURLString(imageURL!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
               cell.latestCourseTagName.text = self.latestCourses[indexPath.row]["title"] as? String
               
               
                         
                  
               cell.latestPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.latestCourses[indexPath.row]["price"]! ?? "0")")!])

               
               
                 if let isLearning = self.latestCourses[indexPath.row]["is_elearning"] as? Int {
                     
                     if isLearning == 0 {
                         cell.latestElearning.isHidden = true
                     }else{
                         cell.latestElearning.isHidden = false
                     }
                 }else{
                     cell.latestElearning.isHidden = true
                 }
                
               
               
               if let sfcBooking = self.latestCourses[indexPath.row]["skills_future_credit_claimable"] as? Int {
                   if sfcBooking == 0 {
                       cell.latestSFC.isHidden = true
                   }
                   else{
                       cell.latestSFC.isHidden = false
                   }
               }else{
                   cell.latestSFC.isHidden = true
               }
               
               
               
               if let wscBooking = self.latestCourses[indexPath.row]["is_wsq"] as? Int {
                   if wscBooking == 0 {
                       cell.latestWSQ.isHidden = true
                   }
                   else {
                       cell.latestWSQ.isHidden = false
                   }
               }else
               {
                   cell.latestWSQ.isHidden = true
               }
               
        
               
           }
           
           if collectionView == favouriteCollectionView
           {
               
               cell.contentView.layer.cornerRadius = 8
               cell.contentView.layer.masksToBounds = true
               
            let imageURL =  "\(WebServices.BASE_URL)\(self.favouriteCourses[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            if (imageURL!.hasSuffix(".pdf")){
                   cell.favouritesImg.contentMode = .scaleAspectFit
                   
               }else{
                   cell.favouritesImg.contentMode = .scaleAspectFill
               }
               
//            cell.favouritesImg.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "PlaceholderImg"))
            cell.myLoader.isHidden = false
            cell.myLoader.startAnimating()
            cell.favouritesImg.loadImageUsingCacheWithURLString(imageURL!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
            
               cell.favouriteTitle.text = self.favouriteCourses[indexPath.row]["title"] as? String

               cell.favouritesPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.favouriteCourses[indexPath.row]["price"]! ?? "0")")!])

            
           }
           
           return cell
           
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessonDetailsViewController") as! LessonDetailsViewController
           
           
           if collectionView == featuredCollectionView
           {
               
               vc.lessonId =  self.featuredCourses[indexPath.row]["id"] as? Int
               
           }
           
           if collectionView == popularCollectionView
           {
               vc.lessonId =  self.popularCourses[indexPath.row]["id"] as? Int
           }
           
           if collectionView == latestCollectionView
           {
               vc.lessonId =  self.latestCourses[indexPath.row]["id"] as? Int
               
           }
           
           if collectionView == favouriteCollectionView
           {
               vc.lessonId =  self.favouriteCourses[indexPath.row]["id"] as? Int
               
           }
           
           vc.hidesBottomBarWhenPushed = true
           self.navigationController?.pushViewController(vc, animated: true)
       }
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        /*
        //self.navigationController?.viewControllers.removeAll()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let courseViewController = storyboard.instantiateViewController(withIdentifier: "NewHomeViewController")
        self.navigationController?.pushViewController(courseViewController, animated: true) */
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
