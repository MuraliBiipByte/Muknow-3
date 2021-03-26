//
//  LGWSearchVC.swift
//  Muknow
//
//  Created by Apple on 09/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LGWSearchVC: UIViewController {

    @IBOutlet weak var searchCV: UICollectionView!
    
    
    var keywordArr = [String]()
    
    var dataArr = [AnyObject]()
    
    
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTxt: UITextField!
    
    @IBOutlet weak var searchTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        lefticonButton.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        self.searchCV.dataSource = self
        self.searchCV.delegate = self
        self.searchCV.isHidden = true
        
        searchTxt.delegate = self
        
        searchTV.dataSource = self
        searchTV.delegate = self
        
        self.searchTV.isHidden = false
        self.searchTV.tableFooterView = UIView.init(frame: CGRect.zero)
        keywordArr = UserDefaults.standard.object(forKey: "SearchKeywords") as? [String] ?? []
        self.searchTV.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(keywordArr, forKey: "SearchKeywords")
    }
    

    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        searchTV.isHidden = true
        
        if !keywordArr.contains(searchTxt.text!) {
            keywordArr.append(searchTxt.text!)
        }
        
        searchTxt.resignFirstResponder()
        callFilterService(searchStr: searchTxt.text!)
    }
    
    func callFilterService(searchStr : String)
    {
        
        //let params = ["key":self.searchTxt.text!] as [String:Any]
        let params = ["key":searchStr] as [String:Any]
        print("Param :",params)
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.LGW_SEARCH, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                let resultDictionary = result as! [String : Any]
                print("resultDictionary : ",resultDictionary)
                
                if let code : Int = resultDictionary["code"] as? Int {
                    if code == 404 {
                        self.searchCV.isHidden = true
                        self.showAlert(message: resultDictionary["error"] as! String)
                    }else{
                        
                    }
                }
                else{
                    
                     self.dataArr = (resultDictionary["data"] as? [AnyObject]) != nil  ?  (resultDictionary["data"] as! [AnyObject]) : []
                    
//                    if self.dataArr.count > 0 {
//                        //self.searchTable.isHidden = true
//
//                    }
                    self.searchCV.isHidden = false
                    self.searchCV.reloadData()
                }
            }
            
        }
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
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


extension LGWSearchVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        "NewHomeCollectionViewCell", for: indexPath) as! NewHomeCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        
        let image =  "\(WebServices.BASE_URL)\(self.dataArr[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
//        cell.LessionsImg.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "PlaceholderImg"))
        
        cell.myLoader.isHidden = false
        cell.myLoader.startAnimating()
        cell.LessionsImg.loadImageUsingCacheWithURLString(image!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
        
        cell.LessionsTitleLbl.text = self.dataArr[indexPath.row]["title"] as? String
        cell.LessonsPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.dataArr[indexPath.row]["price"]! ?? "0")")!])
        
        
        if let isLearning = self.dataArr[indexPath.row]["is_elearning"] as? Int {
            if isLearning == 0 {
                cell.searchElearning.isHidden = true
            }else{
                 cell.searchElearning.isHidden = false
            }
        }else{
             cell.searchElearning.isHidden = true
        }
        
        
        if let sfcBooking = self.dataArr[indexPath.row]["sfc_booking_type"] as? Int {
            if sfcBooking == 0 {
                 cell.searchSFC.isHidden = true
            }
            else{
                  cell.searchSFC.isHidden = false
            }
        }else{
             cell.searchSFC.isHidden = true
        }
        
        
        if let wscBooking = self.dataArr[indexPath.row]["is_wsq"] as? Int {
            if wscBooking == 0 {
                cell.searchWSQ.isHidden = true
            }
            else {
                cell.searchWSQ.isHidden = false
            }
        }else
        {
             cell.searchWSQ.isHidden = true
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessonDetailsViewController") as! LessonDetailsViewController
//        vc.lessonId =  self.dataArr[indexPath.row]["main_category_id"] as? Int
        vc.lessonId =  self.dataArr[indexPath.row]["id"] as? Int
      self.navigationController?.pushViewController(vc, animated: true)
      
  }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //return CGSize(width: self.view.frame.size.width/2 - 5, height: 200)
        return CGSize(width: (self.searchCV.frame.size.width/2)-5, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
extension LGWSearchVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchTV.isHidden = true
        if !keywordArr.contains(searchTxt.text!) {
            keywordArr.append(searchTxt.text!)
        }
        searchTxt.resignFirstResponder()
        callFilterService(searchStr: searchTxt.text!)
           return true
       }
}
extension LGWSearchVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keywordArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCellID")as! SearchTableViewCell
        cell.searchHistoryLbl.text = keywordArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedStr = self.keywordArr[indexPath.row]
        callFilterService(searchStr: selectedStr)
        self.searchTV.isHidden = true
    }
    
}
