//
//  LessonDetailsViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.


import UIKit
import WebKit

class LessonDetailsViewController: UIViewController,FloatRatingViewDelegate {

    
    @IBOutlet weak var longDescActivityView: UIActivityIndicatorView!
    @IBOutlet weak var longDescHeightCons: NSLayoutConstraint!
    @IBOutlet weak var longDescriptionWebview: WKWebView!
    @IBOutlet weak var whatUwillTitleTopCons: NSLayoutConstraint!
    @IBOutlet weak var whatLearnTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var feeIncludesTitleTopCons: NSLayoutConstraint!
    @IBOutlet weak var feeIncludesTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var DescTitleTopCons: NSLayoutConstraint!
    @IBOutlet weak var DescTopCons: NSLayoutConstraint!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var myScrollView: UIScrollView!
    var lessonImgArr = [String]()
    
    var lessonId : Int?
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var classLevelLbl: UILabel!
    @IBOutlet var ageReqLbl: UILabel!
    @IBOutlet var feeIncludesLbl: UILabel!
    // @IBOutlet var summaryLbl: UILabel!
    @IBOutlet var lessonsImg: UIImageView!
  @IBOutlet var whatLearnLbl: UILabel!
    @IBOutlet var classSize: UILabel!
    
    var resultDict = NSDictionary()
//    @IBOutlet var aboutClassLbl: UILabel!
    @IBOutlet var ratingView: FloatRatingView!
    var userEmail :String?

    @IBOutlet var alertView: UIView!
    
    var userId :String?
    var sessionsId :Int?

    var isLearning : Int = 0
    var isSFC : String = "0"
    var isWSQ : Int = 0
    var canBookWithoutSession : Int = 0
    var wishStr :String = ""
    var userPassword :String?

    var BookNowBtn : UIButton!
    var NotifyBtn : UIButton!
    
    var AccessToken : String = ""

    
    @IBOutlet var whatUwillTitle: UILabel!
    @IBOutlet var feeIncludesTitle: UILabel!
    @IBOutlet var LGWTitle: UILabel!
    @IBOutlet var priceLbl: UILabel!
    @IBOutlet var bottomButtonsView: UIView!
    
    @IBOutlet weak var descTitleLbl: UILabel!
    @IBOutlet weak var descTextLbl: UILabel!
    
    
    
//    @IBOutlet var ButtonsView: UIView!
//    @IBOutlet var bookBtnWidth: NSLayoutConstraint!
//
//    @IBOutlet var notifyBtnWidth: NSLayoutConstraint!
//
    
    
    
    
    
    @IBOutlet var scrollView: UIScrollView!
    
    var NotifyText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        

//        self.lessionDetailsData()
//
       self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
      
        let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
        //
        let rightbarButton = UIBarButtonItem(customView: righticonButton)
        //
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = rightbarButton
        
        userEmail = UserDefaults.standard.object(forKey: "user_email") as? String
        userPassword = UserDefaults.standard.string(forKey: "user_password")

//         self.ButtonsView.isHidden = false
        alertView.isHidden = true

         userId = UserDefaults.standard.string(forKey: "user_id")
        
        
         if userId == nil || userId == "" {
             //Get method
             lessionDetailsDataWithoutLogin()
                  
                }
                else{
                   
             // post method
                     lessionDetailsDataWithLogin()
                }
        
        
        
        
     //   if userId != nil || userId != "" {
//            post method
       //     lessionDetailsDataWithLogin()
      //  }
        //else{
            //Get method
          //  lessionDetailsDataWithoutLogin()
       // }
   
        self.scrollView.isHidden = true
    }
    
    func setupImages(imageURLs: [String]){
        for i in 0..<imageURLs.count {
            let imageView = UIImageView()
            
//            imageView.sd_setImage(with: URL(string: imageURLs[i]), placeholderImage: UIImage(named: "PlaceholderImg"))
            
            
            imageView.loadImageUsingCacheWithURLString(imageURLs[i], placeHolder: UIImage(named: "PlaceholderImg"),loader: nil)
//            imageView.image = images[i]
            
            
            
            

            let xPosition = containerView.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            imageView.contentMode = .scaleAspectFill
            myScrollView.contentSize.width = myScrollView.frame.width * CGFloat(i + 1)
            myScrollView.addSubview(imageView)
        }
    }
    
     func lessionDetailsDataWithLogin() {
        
          let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
          
        let params = ["token":accessToken,"lesson_id":lessonId!] as [String:Any]
         
      //  print(params)
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.LESSIONS_LOGIN, params: params) { [self] (result, success) in
              self.view.StopLoading()
              if success == false
                
              {
                //print(result)
                self.authorizationAlert(message:"Authorization required")
//                  self.showAlert(message: result as! String)
                  return
                  
              }
              else
              {
                
                self.scrollView.isHidden = false
                let resultDictionary = result as! [String : Any]
              
                let  dataArr = (resultDictionary["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                self.resultDict =  dataArr[0] as! NSDictionary
             
               // print(self.resultDict)
                self.titleLbl.text = self.resultDict["title"] as? String
                
                self.priceLbl.text =  String(format: "Price : $ %.2f", arguments: [Double("\(self.resultDict["price"]! )")!])

                
//                let avgRate = self.resultDict["avg_rate"] as? Double ?? 0.0
////
////                print(avgRate)
//
//                self.ratingView.editable = false
//                self.ratingView.rating = avgRate
//                self.ratingView.type = .wholeRatings
//                self.ratingView.delegate = self
//                self.ratingView.backgroundColor = UIColor.clear
                
                
     
                let summaryStr =  self.resultDict["summary"] as? String
                if summaryStr == nil  {
                         self.whatUwillTitle.text  = ""
                         self.whatLearnLbl.text = ""
                    
                         self.whatUwillTitleTopCons.constant = 0
                         self.whatLearnTopCons.constant = 0
                         print("null ")
                     }
                    else if summaryStr != "" {
                        self.whatUwillTitleTopCons.constant = 10
                        self.whatLearnTopCons.constant = 8
                        
                    self.whatUwillTitle.text = "What You'll Learn"

                   // let Summarytext = summaryStr!.replacingOccurrences(of: "\n", with: "<br>")
//                        let tmpAttStr = (summaryStr?.htmlToAttributedString)?.trimmedAttributedString(set:CharacterSet.whitespacesAndNewlines)
                    
                        self.whatLearnLbl.attributedText = (summaryStr?.htmlToAttributedString)?.trimmedAttributedString(set:CharacterSet.whitespacesAndNewlines)
//                    self.whatLearnLbl.attributedText = summaryStr?.htmlToAttributedString
                        

                }else{
                      self.whatUwillTitle.text = ""
                     self.whatLearnLbl.text = ""
                    
                    self.whatUwillTitleTopCons.constant = 0
                    self.whatLearnTopCons.constant = 0
                }
                   
                // fee Includes
                    let feeStr =  self.resultDict["fee_includes"] as? String
                  // print(feeStr!)
                if feeStr == nil{
                    self.feeIncludesTitle.text  = ""
                    self.feeIncludesLbl.text = ""
                    print("null")
                    
                    self.feeIncludesTitleTopCons.constant = 0
                    self.feeIncludesTopCons.constant = 0
                }
               else if feeStr != "" {
                self.feeIncludesTitleTopCons.constant = 10
                self.feeIncludesTopCons.constant = 8
                    self.feeIncludesTitle.text = "Fee Includes"
                
                       // let feeIncludetext = feeStr!.replacingOccurrences(of: "\n", with: "<br>")
                    //self.feeIncludesLbl.attributedText = feeStr?.htmlToAttributedString
                self.feeIncludesLbl.attributedText = (feeStr?.htmlToAttributedString)?.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
                    
                }else{
                    self.feeIncludesTitleTopCons.constant = 0
                    self.feeIncludesTopCons.constant = 0
                    
                     self.feeIncludesTitle.text  = ""
                    self.feeIncludesLbl.text = ""
                }
                
                //Desc
                let ldStr =  self.resultDict["long_description"] as? String
              
            if ldStr == nil{
                self.descTitleLbl.text  = ""
                self.descTextLbl.text = ""
                print("null")
                
                self.DescTitleTopCons.constant = 0
                self.DescTopCons.constant = 0
            }
           else if ldStr != "" {
            self.DescTitleTopCons.constant = 10
            self.DescTopCons.constant = 8
            
            self.descTitleLbl.text = "Description"
            
            var finalStr : String? = nil
            let tmpArr1 = ldStr!.components(separatedBy: "<iframe")
            finalStr = tmpArr1[0]

            if tmpArr1.count > 1{
                if tmpArr1[1].contains("</iframe"){
                    let tmpArr2 = tmpArr1[1].components(separatedBy: "</iframe>")
                    let realStr2 = tmpArr2[1]
                    finalStr = finalStr! + realStr2
                }
            }
            
            
            print("FinalStr = ",finalStr!)
            self.descTextLbl.attributedText = (finalStr?.htmlToAttributedString)?.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
            
//            self.descTextLbl.attributedText = (ldStr?.htmlToAttributedString)?.trimmedAttributedString(set: CharacterSet.whitespacesAndNewlines)
            }else{
                self.DescTitleTopCons.constant = 0
                self.DescTopCons.constant = 0
                
                self.descTitleLbl.text  = ""
                self.descTextLbl.text = ""
            }
                
                
                
                /*
                if ldStr == nil{
                    self.DescTitleTopCons.constant = 0
                    self.longDescHeightCons.constant = 0
                }else if ldStr != "" {
                    longDescriptionWebview.navigationDelegate = self
                    let htmlStr = "<html>" + ldStr! + "</html>"
//                    self.longDescActivityView.startAnimating()
//                    self.longDescActivityView.isHidden = false
                    self.longDescriptionWebview.loadHTMLString(htmlStr, baseURL: nil)
                }else{
                    self.DescTitleTopCons.constant = 0
                    self.longDescHeightCons.constant = 0
                }*/
                

                
                
                
                
                
                
                let  classlevel = self.resultDict["class_level"] as? Int
                if classlevel == 0 {
                    self.classLevelLbl.text = "Class Level : All Levels"
                }else if classlevel == 1 {
                    self.classLevelLbl.text = "Class Level : Beginner"
                }else if classlevel == 2 {
                    self.classLevelLbl.text = "Class Level : Intermediate"
                }else{
                    self.classLevelLbl.text = "Class Level : Advanced"
                }
               
                let min_Age = "\(self.resultDict["min_age"]!)"
                let max_Age = "\(self.resultDict["max_age"]!)"
                /*if max_Age == "<null>" {
                    max_Age = "older"
                }
                var min_Age = "\(self.resultDict["min_age"]!)"
                if min_Age == "<null>" {
                    min_Age =
                }*/
                
                if (min_Age != "<null>" && max_Age != "<null>"){
                    self.ageReqLbl.text = String(format : "Age Requirement : %@ to %@ years", min_Age,max_Age)
                }else if(min_Age == "<null>" && max_Age == "<null>"){
                    self.ageReqLbl.text = ""
                }else if(min_Age != "<null>" && max_Age == "<null>"){
                    self.ageReqLbl.text = String(format : "Age Requirement : %@ and older", "\(self.resultDict["min_age"]!)")
                }else{
                    self.ageReqLbl.text = String(format : "Age Requirement : 0 to %@ ", "\(self.resultDict["max_age"]!)")
                }
                
//                self.ageReqLbl.text = String(format : "Age Requirement : %@ to %@ years", "\(self.resultDict["min_age"]!)","\(self.resultDict["max_age"]!)")
                
             
                
                if self.resultDict["typical_class_size"] == nil || "\(self.resultDict["typical_class_size"]!)" == "<null>"{
                   
                    self.classSize.text = ""

                   
                }else{
                    self.classSize.text = String(format : "Average Class Size :  %@ ", "\(self.resultDict["typical_class_size"]!)")
                }
                
                
//                if self.resultDict["typical_class_size"] != nil {
//
//                self.classSize.text = String(format : "Average Class Size :  %@ ", "\(self.resultDict["typical_class_size"]!)")
//
//                }
//                else{
//                    self.classSize.text = ""
//                }
                
//                let image =  "\(WebServices.BASE_URL)\(self.resultDict["path_1"] as! String)"
////                self.lessonsImg.contentMode = .scaleAspectFill
//                self.lessonsImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))
                
                self.containerView.isHidden = false
                self.lessonImgArr.removeAll()
                let imageURL1 = "\(self.resultDict["path_1"]!)"
                let imageURL2 = "\(self.resultDict["path_2"]!)"
                let imageURL3 = "\(self.resultDict["path_3"]!)"
                let imageURL4 = "\(self.resultDict["path_4"]!)"
                let imageURL5 = "\(self.resultDict["path_5"]!)"
                if imageURL1 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_1"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                
                if imageURL2 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_2"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                
                if imageURL3 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_3"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                if imageURL4 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_4"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                if imageURL5 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_5"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                self.setupImages(imageURLs: self.lessonImgArr)
                
                
                
                self.sessionsId = self.resultDict["id"] as? Int
              
                  self.canBookWithoutSession = self.resultDict["can_book_without_session"] as! Int
                                
                
                
                let bookNow = self.resultDict["book_now"] as? String
//                let bookNow = ""
                self.NotifyText = (self.resultDict["wish_list"] as? String)!

                
                self.wishStr = (self.resultDict["wishlisted"] as? String)!
               
                
                if bookNow != ""  && NotifyText != ""  {
                    
                    self.BookNowBtn = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width/2) - 2, height: 60))
                    self.BookNowBtn.backgroundColor = APPEARENCE_COLOR
                    self.BookNowBtn.setTitleColor(UIColor.white, for: .normal)
                    self.BookNowBtn.setTitle(bookNow, for: .normal)
                    self.BookNowBtn.addTarget(self, action: #selector(self.booknow_tapped), for: .touchUpInside)
                    self.BookNowBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                     
                    
                    self.NotifyBtn = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) + 2, y: 0, width: (self.view.frame.size.width/2) - 2, height: 60))
//                    self.NotifyBtn.backgroundColor = UIColor.red
//                    self.NotifyBtn.setTitle(NotifyText, for: .normal)
                    self.NotifyBtn.addTarget(self, action: #selector(self.notify_Tapped), for: .touchUpInside)
                    self.NotifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    
                    if self.wishStr == "Yes"  {
                        NotifyText = "Saved to Wishlist"
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.isUserInteractionEnabled = false
                        self.NotifyBtn.backgroundColor = UIColor.lightGray
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal)

                    }else{
                        
                        self.NotifyBtn.isUserInteractionEnabled = true
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.backgroundColor = APPEARENCE_COLOR
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal
                        )

                    }
                                   
                    
                    
                    self.bottomButtonsView.addSubview(self.BookNowBtn)
                    self.bottomButtonsView.addSubview(self.NotifyBtn)
                    
                }
                    
                else if bookNow  == "" {
                    
                  self.NotifyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
                  self.NotifyBtn.addTarget(self, action: #selector(self.notify_Tapped), for: .touchUpInside)
                  self.NotifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                  
                    
                    if  self.wishStr == "Yes"  {
                        NotifyText = "Saved to Wishlist"
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.isUserInteractionEnabled = false
                        self.NotifyBtn.backgroundColor = UIColor.lightGray
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal)

                    }else{
                        
                        self.NotifyBtn.isUserInteractionEnabled = true
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.backgroundColor = APPEARENCE_COLOR
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal
                        )

                    }
                    
                    
                    self.bottomButtonsView.addSubview(self.NotifyBtn)

                }
                else if NotifyText == "" {

                    self.BookNowBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
                    self.BookNowBtn.backgroundColor = APPEARENCE_COLOR
                    self.BookNowBtn.setTitleColor(UIColor.white, for: .normal)
                    self.BookNowBtn.setTitle(bookNow, for: .normal)
                    self.BookNowBtn.addTarget(self, action: #selector(self.booknow_tapped), for: .touchUpInside)
                    self.BookNowBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    self.bottomButtonsView.addSubview(self.BookNowBtn)

                    
                }
           
            }
              
          }
        
    }
    
    @objc func booknow_tapped(sender : UIButton!) {
        
        
        if userId == nil {
            alertView.isHidden = false
            
        }
        else{
             alertView.isHidden = true
//          canBookWithoutSession = 0
            if canBookWithoutSession == 0 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SessionBookingViewController") as! SessionBookingViewController
                vc.Id = self.sessionsId
                
                vc.className = (self.resultDict["title"] as? String)!

                if self.resultDict["is_gst"] as? Int == 0 {
                                 vc.GST = 0
                             }else{
                                 vc.GST = (self.resultDict["gst"] as? Int)!
                             }
                
                vc.DetailsDict = self.resultDict as! [String : Any]

                
//                vc.canbookwithsession = self.canBookWithoutSession
                
//                self.canBookWithoutSession
                
//                vc.quantity = (dictObj["slots"] as? Int)!
//                      vc.isSessions = true
//                      vc.subTotal = (dictObj["price"] as? String)!
//                      vc.sessionId = (dictObj["session_id"] as? Int)!
//
                
                
                
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "LGWCheckoutViewController") as! LGWCheckoutViewController
                    
                 //   print(self.resultDict)
                    vc.isSessions = false
                    vc.classname = (self.resultDict["title"] as? String)!
                    vc.quantity = 1
                    vc.subTotal = (self.resultDict["price"] as? String)!
//                 vc.sessionId = "(dictObj["session_id"] as? Int)!"
                vc.DetailsDict = self.resultDict as! [String : Any]
                
                // vc.gstTotal = (self.resultDict["gst"] as? Int)!
                
                if self.resultDict["is_gst"] as? Int == 0 {
                    vc.gstTotal = 0
                }else{
                    vc.gstTotal = (self.resultDict["gst"] as? Int)!
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
        
        
        
        
        
        
        
        
            
            
            
    //
    //        if userId == nil {
    //            alertView.isHidden = false
    //
    //        }else{
    //
    //            alertView.isHidden = true
    //            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SessionBookingViewController") as! SessionBookingViewController
    //            vc.Id = self.sessionsId
    //            self.navigationController?.pushViewController(vc, animated: true)
    //            print("navigate")
    //
    //        }
            
    //        if userId != nil || userId != "" {
    //
    //            print(userId!)
    //            print("navigate")
    //
    //        }else{
    //
    //        }
            
            
            
            
    //
    //        let alert = UIAlertController(title: APP_NAME, message: "Please login to continue", preferredStyle: UIAlertController.Style.alert)
    //
    //               // The order in which we add the buttons matters.
    //               // Add the Cancel button first to match the iOS 7 default style,
    //               // where the cancel button is at index 0.
    //        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
    //                 //  self.handelCancel()
    //               }))
    //
    //        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
    //                   //self.handelConfirm()
    //               }))
    //
    //        present(alert, animated: true, completion: nil)
    //
            
        }
    
    
    
    @objc func notify_Tapped(sender : UIButton) {
        
        
        if userId == nil {
            alertView.isHidden = false
            
        }
        else{
//            http://stgservices.mu-know.com/auth/roi/notify
            print("Btn Text = ",self.NotifyText)
            var tmpWebService = ""
            if self.NotifyText == "Interested" {
                tmpWebService = WebServices.INTEREST
            }else if self.NotifyText == "Notify Me of New Dates"{
                tmpWebService = WebServices.NOTIFY_WISHLIST_LOGIN
            }else if self.NotifyText == "Save to Wishlist"{
                tmpWebService = WebServices.ADD_WISHLIST_LOGIN
            }

            alertView.isHidden = true
            
            AccessToken = UserDefaults.standard.object(forKey: "access_token") as! String
            
            let params = ["token":AccessToken,"lesson_id":lessonId!] as [String:Any]
            self.view.StartLoading()
            
            ApiManager().postRequest(service: tmpWebService, params: params) { (result, success) in
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
                    self.showAlert(message: "Added to My Wish List")
                    
                    self.lessionDetailsDataWithLogin()
                    
                }
            }
        }
        
    }
    
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
    }
    func lessionDetailsDataWithoutLogin() {
        
                let totalStr = WebServices.LESSIONS + "/" +
            "\(lessonId!)"

        self.view.StartLoading()
        
        ApiManager().getRequest(service:totalStr)
        { [self] (result, success) in
            self.view.StopLoading()
            
            if success == false
            {
                 self.scrollView.isHidden = true
//                self.showAlert(message: result as! String)
                //self.authorizationAlert(message:"Authorization required")
                return
            }
                
            else
            {
                
                self.scrollView.isHidden = false
                let resultDictionary = result as! [String : Any]
               // print(resultDictionary)
                
                let  dataArr = (resultDictionary["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                self.resultDict =  dataArr[0] as! NSDictionary
                
                self.titleLbl.text = self.resultDict["title"] as? String
               
                self.priceLbl.text =  String(format: "Price : $ %.2f", arguments: [Double("\(self.resultDict["price"]! )")!])

//
//                let avgRate = self.resultDict["rating"] as? Double
//
//                    self.ratingView.editable = false
//                self.ratingView.rating = avgRate!
//                    self.ratingView.type = .wholeRatings
//                    self.ratingView.delegate = self
//                    self.ratingView.backgroundColor = UIColor.clear
                    
                
                
                let summaryStr =  self.resultDict["summary"] as? String
                if summaryStr == nil  {
                    self.whatUwillTitle.text  = ""
                    self.whatLearnLbl.text = ""
                    print("null ")
                }
                else if summaryStr != "" {
                    self.whatUwillTitle.text = "What You'll Learn"
                    
                   // let Summarytext = summaryStr!.replacingOccurrences(of: "\n", with: "<br>")
                    
                self.whatLearnLbl.attributedText = summaryStr?.htmlToAttributedString

                    
                }else{
                    self.whatUwillTitle.text = ""
                    self.whatLearnLbl.text = ""
                }
                
                // fee Includes
                let feeStr =  self.resultDict["fee_includes"] as? String
                // print(feeStr!)
                if feeStr == nil {
                    self.feeIncludesTitle.text  = ""
                    self.feeIncludesLbl.text = ""
                    print("null")
                }
                else if feeStr != "" {
                    self.feeIncludesTitle.text = "Fee Includes"
                    
                  //  let feeIncludetext = feeStr!.replacingOccurrences(of: "\n", with: "<br>")
                   
                    self.feeIncludesLbl.attributedText = feeStr?.htmlToAttributedString

                }else{
                    self.feeIncludesTitle.text  = ""
                    self.feeIncludesLbl.text = ""
                }
                
          
                            let  classlevel = self.resultDict["class_level"] as? Int
                            if classlevel == 0 {
                                self.classLevelLbl.text = "Class Level : All Levels"
                            }else if classlevel == 1 {
                                self.classLevelLbl.text = "Class Level : Beginner"
                            }else if classlevel == 2 {
                                self.classLevelLbl.text = "Class Level : Intermediate"
                            }else{
                                self.classLevelLbl.text = "Class Level : Advanced"
                            }
                           
                let min_Age = "\(self.resultDict["min_age"]!)"
                let max_Age = "\(self.resultDict["max_age"]!)"
                /*if max_Age == "<null>" {
                    max_Age = "older"
                }
                var min_Age = "\(self.resultDict["min_age"]!)"
                if min_Age == "<null>" {
                    min_Age =
                }*/
                
                if (min_Age != "<null>" && max_Age != "<null>"){
                    self.ageReqLbl.text = String(format : "Age Requirement : %@ to %@ years", min_Age,max_Age)
                }else if(min_Age == "<null>" && max_Age == "<null>"){
                    self.ageReqLbl.text = ""
                }else if(min_Age != "<null>" && max_Age == "<null>"){
                    self.ageReqLbl.text = String(format : "Age Requirement : %@ and older", "\(self.resultDict["min_age"]!)")
                }else{
                    self.ageReqLbl.text = String(format : "Age Requirement : 0 to %@ ", "\(self.resultDict["max_age"]!)")
                }
                
//                            self.ageReqLbl.text = String(format : "Age Requirement : %@ to %@ years", "\(self.resultDict["min_age"]!)","\(self.resultDict["max_age"]!)")
                      
                
                             
                if self.resultDict["typical_class_size"] == nil || "\(self.resultDict["typical_class_size"]!)" == "<null>"{
                   
                    self.classSize.text = ""

                   
                }else{
                    self.classSize.text = String(format : "Average Class Size :  %@ ", "\(self.resultDict["typical_class_size"]!)")
                }
                
                
//
//                if let classSize = self.resultDict["typical_class_size"] {
//
//                    self.classSize.text = ""
//
//
//                }else{
//
//                    self.classSize.text = String(format : "Average Class Size :  %@ ", "\(self.resultDict["typical_class_size"]!)")
//
//                }
                
//                            self.classSize.text = String(format : "Average Class Size :  %@ ", "\(self.resultDict["typical_class_size"]!)")

                             
                
                /* let image =  "\(WebServices.BASE_URL)\(self.resultDict["path_1"] as! String)"
                //                self.lessonsImg.contentMode = .scaleAspectFill
//                self.lessonsImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))
                
                self.lessonsImg.sd_setImage(with: URL(string: image ), placeholderImage: UIImage(named: "PlaceholderImg"), options: .highPriority) { (img, err, cacheType, imageUrl) in
                    print("Image Downloaded by SD_WEB")
//                    self.myLoader.isHidden = true
//                    self.myLoader.stopAnimating()
//                    self.profileImgView.contentMode = .scaleToFill
                } */
                
                self.containerView.isHidden = false
                self.lessonImgArr.removeAll()
                let imageURL1 = "\(self.resultDict["path_1"]!)"
                let imageURL2 = "\(self.resultDict["path_2"]!)"
                let imageURL3 = "\(self.resultDict["path_3"]!)"
                let imageURL4 = "\(self.resultDict["path_4"]!)"
                let imageURL5 = "\(self.resultDict["path_5"]!)"
                if imageURL1 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_1"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                
                if imageURL2 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_2"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                
                if imageURL3 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_3"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                if imageURL4 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_4"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                if imageURL5 != "<null>" {
                    self.lessonImgArr.append("\(WebServices.BASE_URL)\(self.resultDict["path_5"]!)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")
                }
                self.setupImages(imageURLs: self.lessonImgArr)
                
                
                self.sessionsId = self.resultDict["id"] as? Int
                
                self.canBookWithoutSession = self.resultDict["can_book_without_session"] as! Int
                
                
                
                let bookNow = self.resultDict["book_now"] as? String
                //                let bookNow = ""
                self.NotifyText = (self.resultDict["wish_list"] as? String)!
                
                
                if bookNow != ""  && NotifyText != ""  {
                    
                    self.BookNowBtn = UIButton(frame: CGRect(x: 0, y: 0, width: (self.view.frame.size.width/2) - 2, height: 60))
                    self.BookNowBtn.backgroundColor = APPEARENCE_COLOR
                    self.BookNowBtn.setTitleColor(UIColor.white, for: .normal)
                    self.BookNowBtn.setTitle(bookNow, for: .normal)
                    self.BookNowBtn.addTarget(self, action: #selector(self.booknow_tapped), for: .touchUpInside)
                    self.BookNowBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    
                    self.NotifyBtn = UIButton(frame: CGRect(x: (self.view.frame.size.width/2) + 2, y: 0, width: (self.view.frame.size.width/2) - 2, height: 60))
                    self.NotifyBtn.addTarget(self, action: #selector(self.notify_Tapped), for: .touchUpInside)
                    self.NotifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    
                    if self.wishStr == "Yes"  {
                        NotifyText = "Saved to Wishlist"
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.isUserInteractionEnabled = false
                        self.NotifyBtn.backgroundColor = UIColor.lightGray
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal)
                        
                    }else{
                        
                        self.NotifyBtn.isUserInteractionEnabled = true
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.backgroundColor = APPEARENCE_COLOR
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal
                        )
                        
                    }
                    
                    
                    
                    self.bottomButtonsView.addSubview(self.BookNowBtn)
                    self.bottomButtonsView.addSubview(self.NotifyBtn)
                    
                }
                    
                else if bookNow  == "" {
                    
                    self.NotifyBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
                    self.NotifyBtn.addTarget(self, action: #selector(self.notify_Tapped), for: .touchUpInside)
                    self.NotifyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    
                    if  self.wishStr == "Yes"  {
                        NotifyText = "Saved to Wishlist"
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.isUserInteractionEnabled = false
                        self.NotifyBtn.backgroundColor = UIColor.lightGray
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal)
                        
                    }else{
                        
                        self.NotifyBtn.isUserInteractionEnabled = true
                        self.NotifyBtn.setTitle(NotifyText, for: .normal)
                        self.NotifyBtn.backgroundColor = APPEARENCE_COLOR
                        self.NotifyBtn.setTitleColor(UIColor.white, for: .normal
                        )
                        
                    }
                    
                    
                    self.bottomButtonsView.addSubview(self.NotifyBtn)
                    
                }
                else if NotifyText == "" {
                    
                    self.BookNowBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60))
                    self.BookNowBtn.backgroundColor = APPEARENCE_COLOR
                    self.BookNowBtn.setTitleColor(UIColor.white, for: .normal)
                    self.BookNowBtn.setTitle(bookNow, for: .normal)
                    self.BookNowBtn.addTarget(self, action: #selector(self.booknow_tapped), for: .touchUpInside)
                    self.BookNowBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                    
                    self.bottomButtonsView.addSubview(self.BookNowBtn)
                    
                }
            }
        }
    }
    
//    @IBOutlet var favBtn: UIButton!
//
//    var favTag : Int = 0
//    @IBAction func add_To_Favourites(_ sender: Any) {
//        if favTag == 0 {
//            self.addToWishList()
//
//        }else{
//            self.removeFromWishList()
//        }
//
//    }
    
    
    func addToWishList() {

          
                
                  let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
                  
                let params = ["token":accessToken,"lesson_id":lessonId!] as [String:Any]
                  self.view.StartLoading()

                  ApiManager().postRequest(service: WebServices.ADD_WISHLIST_LOGIN, params: params) { (result, success) in
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
//                            self.favBtn.setImage(UIImage(named: "favouriteIcon"), for: UIControl.State.normal)
//                            self.favTag = 1
                        }
                     
                    }
                      
                  }
                
           
    }
    
    
    
    func removeFromWishList() {

                
                  let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
                  
                let params = ["token":accessToken,"lesson_id":lessonId!] as [String:Any]
        
                  self.view.StartLoading()

                  ApiManager().postRequest(service: WebServices.REMOVE_WISHLIST_LOGIN, params: params) { (result, success) in
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
                            
//                       self.favBtn.setImage(UIImage(named: "unfavouriteIcon"), for: UIControl.State.normal)
//                        self.favTag = 0
                        }
                    }
                      
                  }
                
           
    }

    @objc private func goToSearchPage() {
        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "LGWSearchVCSBID") as! LGWSearchVC
        searchVc.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(searchVc, animated: true)
        
    }
    
    
    @IBAction func ok_tapped(_ sender: Any) {
        
        let initialVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(initialVc, animated: true, completion: nil)
        
    }
    
    
    
    
    
    @IBAction func cancel_Tapped(_ sender: Any) {
        self.alertView.isHidden = true
    }
    
    
    @IBAction func backVc_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func authorizationAlert(message:String) {
        
        let alert = UIAlertController(title: APP_NAME, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
            
            let loginVc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginVc, animated: true, completion: nil)
            
            
            
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
//    func getAccessToken () {
//
//        let paramsDict = [
//            "email":self.userEmail!,
//            "password":self.userPassword!]
//
//           print("\(paramsDict)")
//
//        self.view.StartLoading()
//        ApiManager().postRequestToGetAccessToken(service:WebServices.APP_ACCESS_TOKEN, params: paramsDict as [String : Any])
//              { (result, success) in
//                  self.view.StopLoading()
//
//                  if success == false
//                  {
//                    self.showAlert(message: result as! String )
//                      return
//                  }
//                  else
//                  {
//                    let resultDictionary = result as! [String : Any]
//                     print("\(resultDictionary)")
//
//                    let access_token = resultDictionary["access_token"] as! String
//
//                    UserDefaults.standard.set(access_token, forKey: "access_token")
//
////                    self.GetCoursesDataWithLogin()
//
//                  }
//
//              }
//    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    

}

extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            
            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSMakeRange(0, attributedString.length))
            attributedString.addAttribute(.foregroundColor, value: UIColor.darkGray, range: NSMakeRange(0, attributedString.length))
            
            return attributedString
      } catch {
           return NSMutableAttributedString() //NSAttributedString()
        }
    }
    var htmlToString: String {
       return htmlToAttributedString?.string ?? ""
   }
}
extension NSMutableAttributedString {

    func trimmedAttributedString(set: CharacterSet) -> NSMutableAttributedString {

        let invertedSet = set.inverted

        var range = (string as NSString).rangeOfCharacter(from: invertedSet)
        let loc = range.length > 0 ? range.location : 0

        range = (string as NSString).rangeOfCharacter(
                            from: invertedSet, options: .backwards)
        let len = (range.length > 0 ? NSMaxRange(range) : string.count) - loc

        let r = self.attributedSubstring(from: NSMakeRange(loc, len))
        return NSMutableAttributedString(attributedString: r)
    }
}


//extension LessonDetailsViewController{
//    func loadHtmlResponse(html: String) {
//
//        let text = html.replacingOccurrences(of: "\n", with: "<br>")
////        loadHtml_Lbl.numberOfLines = 10
//        guard let data = text.data(using: String.Encoding.utf8) else {
//            return
//        }
//        do {
//            let attributedString = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//            attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15), range: NSMakeRange(0, attributedString.length))
//            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributedString.length))
//
////            textView.attributedText = attributedString
//
//            self.sampleTxt.attributedText = attributedString
//        } catch let error {
//            print(error.localizedDescription)
//        }
//
//    }
//}

/* extension LessonDetailsViewController : WKNavigationDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, error) in

        if complete != nil {
          let height = webView.scrollView.contentSize
          print("height of webView is: \(height)")
        }
      })
    }
} */
extension LessonDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation
       navigation: WKNavigation!) {
        self.longDescActivityView.startAnimating()
        self.longDescActivityView.isHidden = false
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            print("Content Height : ",webView.scrollView.contentSize.height)
            self.longDescHeightCons.constant = webView.scrollView.contentSize.height
//            self.longDescriptionWebview.StopLoading()
            self.longDescActivityView.stopAnimating()
            self.longDescActivityView.isHidden = true
        }
    }
    func webView(_ webView: WKWebView, didFail navigation:
    WKNavigation!, withError error: Error) {
        self.longDescActivityView.stopAnimating()
        self.longDescActivityView.isHidden = true
 }
}
