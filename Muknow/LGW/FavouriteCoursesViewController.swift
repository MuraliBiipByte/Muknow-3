//
//  FavouriteCoursesViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FavouriteCoursesViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var Access_Token : String = ""
    
    var FavouriteCourses = [AnyObject]()
    
    @IBOutlet var FavouriteCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        lefticonButton.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        Access_Token = UserDefaults.standard.object(forKey: "access_token") as! String

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.view.frame.size.width/2 - 5, height: 200)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        FavouriteCollectionView!.collectionViewLayout = layout
        
        
        self.FavouriteCollectionView.isHidden = true
        self.getFavouriteCoursesList()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return FavouriteCourses.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
//        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:"HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "NewHomeCollectionViewCell", for: indexPath) as! NewHomeCollectionViewCell
        
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        
        let image =  "\(WebServices.BASE_URL)\(self.FavouriteCourses[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
       
//        cell.wishListImg.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "PlaceholderImg"))
        
        cell.myLoader.isHidden = false
        cell.myLoader.startAnimating()
        cell.wishListImg.loadImageUsingCacheWithURLString(image!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
        cell.wishListImg.contentMode = .scaleAspectFill
        
        cell.wishedItemName.text = self.FavouriteCourses[indexPath.row]["title"] as? String
        
        cell.wishedPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.FavouriteCourses[indexPath.row]["price"]! ?? "0")")!])
        
        
        if let isLearning = self.FavouriteCourses[indexPath.row]["is_elearning"] as? Int {
            
            if isLearning == 0 {
                cell.wishLearning.isHidden = true
            }else{
                cell.wishLearning.isHidden = false
            }
        }else{
            cell.wishLearning.isHidden = true
        }
        
        
        if let sfcBooking = self.FavouriteCourses[indexPath.row]["skills_future_credit_claimable"] as? Int {
            if sfcBooking == 0 {
                cell.wishSfc.isHidden = true
            }
            else{
                cell.wishSfc.isHidden = false
            }
        }else{
            cell.wishSfc.isHidden = true
        }
        
        if let wscBooking = self.FavouriteCourses[indexPath.row]["is_wsq"] as? Int {
            if wscBooking == 0 {
                cell.wishWSQ.isHidden = true
            }
            else {
                cell.wishWSQ.isHidden = false
            }
        }else
        {
            cell.wishWSQ.isHidden = true
        }
        
        
        
        cell.deleteFavBtn.addTarget(self, action: #selector(self.deleteFavItem), for: .touchUpInside)
        cell.deleteFavBtn.tag = indexPath.row

        return cell
    }
    
    
    var index = Int()
    
    @objc func deleteFavItem(sender : UIButton?) {
        index = sender!.tag
        self.showAlertWithAction(message: "Do you want to remove?")
    }
    
    func showAlertWithAction(message:String)
         {
             Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(confirmDelete), Controller: self),Message.AlertActionWithSelector(Title: "Cancel", Selector:#selector(cancelDelete), Controller: self)], Controller: self)
         }
        
    @objc func confirmDelete()
        {
            let dictObj = self.FavouriteCourses[(index)]
             print(dictObj)
              
            let lessonId = dictObj["id"]  as? Int
              self.deleteItemFromList(lesson_id: "\(lessonId!)")
        }
    @objc func cancelDelete()
    {
        print("cancel tapped..")
    }
    
     func deleteItemFromList(lesson_id: String) {
    
           
         // params - token, lesson_id
             
        let paramsDic = ["token":self.Access_Token,
                        "lesson_id":lesson_id] as [String:Any]
           
             print(paramsDic)
             
         self.view.StartLoading()
         ApiManager().postRequest(service: WebServices.REMOVE_WISHLIST_LOGIN, params: paramsDic)
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
                     self.FavouriteCourses.remove(at: self.index)
                     self.FavouriteCollectionView.reloadData()

                   
                     
                     
                 }
             }
         }
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessonDetailsViewController") as! LessonDetailsViewController
        
        vc.lessonId =  self.FavouriteCourses[indexPath.row]["id"] as? Int
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    
    func getFavouriteCoursesList() {
        
        
        let paramsDict = [
            "token":Access_Token
        ]
        
        
        self.view.StartLoading()
        
        ApiManager().getRequestWithParameters(service: WebServices.WISHLIST_LOGIN, params: paramsDict, completion:
            { (result, success) in
                
                
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
                    
                    self.FavouriteCourses = (resultDictionary["data"] as? [AnyObject]) != nil  ?  (resultDictionary["data"] as! [AnyObject]) : []
                    
                    
                    if (self.FavouriteCourses.count > 0)
                    {
                        self.FavouriteCollectionView.isHidden = false
                        self.FavouriteCollectionView.reloadData()
                    }
                   
                }
        })
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    
    @objc func goBack() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
