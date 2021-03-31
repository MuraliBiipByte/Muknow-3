//
//  AllReviewsVC.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class AllReviewsVC: UIViewController,FloatRatingViewDelegate {

    @IBOutlet weak var allReviewsTV: UITableView!
    var articlesID : Int?
    var allReviewArr = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //   btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        // Do any additional setup after loading the view.
        allReviewsTV.register(UINib(nibName: "ReviewsCellTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewsCellID" )
        
        allReviewsTV.estimatedRowHeight = 44.0;
        allReviewsTV.rowHeight = UITableView.automaticDimension;
        
    }
    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getAllReviewsList()
    }
    
       func getAllReviewsList()
       {
           
           let totalStr = WebServices.ALL_REVIEWS + "/" +
           "\(articlesID!)"
    
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
                       let reviewResponse = data ["response"] as! [String:Any]
                       let reviewData = reviewResponse ["data"] as! [String:Any]
                    
                    self.allReviewArr = (reviewData["review_details"] as? [AnyObject]) != nil ? (reviewData["review_details"] as! [AnyObject]) : []
                    
                    if (self.allReviewArr.count > 0)
                    {
                        self.allReviewsTV.reloadData()
                        self.allReviewsTV.isHidden = false
                        
                    }else{
                        self.allReviewsTV.isHidden = true
                    }
                    
                    /*
                       self.ArrTotalArticlesList = (categorydata["articles_list"] as? [AnyObject]) != nil  ?  (categorydata["articles_list"] as! [AnyObject]) : []
                       
                       if (self.ArrTotalArticlesList.count > 0)
                       {
                           self.ArticlesTV.reloadData()
                           self.ArticlesTV.isHidden = false
                           
                       } */
                    
                    
                       
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

}
extension AllReviewsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allReviewArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsCellID", for: indexPath) as! ReviewsCellTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        
        let tmpDict = allReviewArr[indexPath.row] as! NSDictionary
        let tmpAny = tmpDict.value(forKey: "user_data") as! [AnyObject]
        if tmpAny.count > 0 {
            let tmpDict2 = tmpAny[0] as! NSDictionary
            cell.nameLbl.text = tmpDict2.value(forKey: "full_name") as? String
        }
        
        cell.reviewLbl.text =  tmpDict.value(forKey: "comment") as? String
        
        //let rateing = tmpDict["rate"] as! Double
        
        if let rating = (tmpDict["rate"] as? NSString)?.doubleValue {
          // totalfup is a Double here
            cell.floatRatingView.rating = rating
        }
        else {
          // dict["totalfup"] isn't a String
          // you can try to 'as? Double' here
            cell.floatRatingView.rating = tmpDict["rate"] as! Double
        }
        
        cell.floatRatingView.editable = false
        
        cell.floatRatingView.type = .wholeRatings
        cell.floatRatingView.delegate = self
        cell.floatRatingView.backgroundColor = UIColor.clear
        //cell.nameLbl.text = "\(userData[0]["full_name"]! ?? "default value")"
        return cell
    }
}
