//
//  LGWSearchViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LGWSearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate {
   
    

      
    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTxt: UITextField!
    @IBOutlet var searchTable: UITableView!
      
    @IBOutlet var SearchCollectionView: UICollectionView!
    
    var search_List = [String]()
    
     var searchCollection_List = [AnyObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        lefticonButton.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
         navigationItem.leftBarButtonItem = leftbarButton
        
        
       
        search_List = UserDefaults.standard.object(forKey: "Search_List") as? [String] ?? []
        
        self.searchTable.dataSource = self
        self.searchTable.delegate = self
        
        self.searchTable.isHidden = false
        self.searchTable.tableFooterView = UIView.init(frame: CGRect.zero)
        self.searchView.isHidden = false
        searchTxt.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                     layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
              layout.itemSize = CGSize(width: self.view.frame.size.width/2 - 5, height: 200)
                     layout.minimumInteritemSpacing = 10
                     layout.minimumLineSpacing = 10
                     SearchCollectionView!.collectionViewLayout = layout
              
        
        self.SearchCollectionView.dataSource = self
        self.SearchCollectionView.delegate = self
        self.SearchCollectionView.isHidden = true
      
    }
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return search_List.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell")as! SearchTableViewCell
        cell.searchHistoryLbl.text = search_List[indexPath.row]
        return cell
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           
        search_List.append(searchTxt.text!)
        searchContent(searchStr: searchTxt.text!)
         UserDefaults.standard.set(search_List, forKey: "Search_List")
        
        
        searchTxt.resignFirstResponder()
         
           return true
       }
        
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let didsearchStr = self.search_List[indexPath.row]
//        let selectedCell = tableView.cellForRow(at: indexPath)
//        print(selectedCell?.textLabel?.text! ?? "")
        
        searchContent(searchStr: didsearchStr)
        
        self.searchTable.isHidden = true
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessonDetailsViewController") as! LessonDetailsViewController
//
//        vc.lessonId =  self.search_List[indexPath.row]["main_category_id"] as? Int
//        vc.hidesBottomBarWhenPushed = true
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    func searchContent(searchStr : String)
    {
        
        let params = ["key":self.searchTxt.text!] as [String:Any]
        print(params)
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
                    
                     self.searchCollection_List = (resultDictionary["data"] as? [AnyObject]) != nil  ?  (resultDictionary["data"] as! [AnyObject]) : []
                    
                    if self.searchCollection_List.count > 0 {
                        self.searchTable.isHidden = true
                        self.SearchCollectionView.reloadData()
                        self.SearchCollectionView.isHidden = false
                    }
                }
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
            return searchCollection_List.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
      {
          
          /*let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
              "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell */
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "NewHomeCollectionViewCell", for: indexPath) as! NewHomeCollectionViewCell
          
//          if collectionView == featuredCollectionView
//          {
//
              cell.contentView.layer.cornerRadius = 8
              cell.contentView.layer.masksToBounds = true
              
              let image =  "\(WebServices.BASE_URL)\(self.searchCollection_List[indexPath.row]["path"] as! String)"

              
              cell.LessionsImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))
              
              cell.LessionsTitleLbl.text = self.searchCollection_List[indexPath.row]["title"] as? String
              

        cell.LessonsPrice.text =  String(format: " $ %.2f", arguments: [Double("\(self.searchCollection_List[indexPath.row]["price"]! ?? "0")")!])

            

        if let isLearning = self.searchCollection_List[indexPath.row]["is_elearning"] as? Int {
            
            if isLearning == 0 {
                cell.searchElearning.isHidden = true
            }else{
                 cell.searchElearning.isHidden = false
            }
        }else{
             cell.searchElearning.isHidden = true
        }
        
        
        if let sfcBooking = self.searchCollection_List[indexPath.row]["sfc_booking_type"] as? Int {
            if sfcBooking == 0 {
                 cell.searchSFC.isHidden = true
            }
            else{
                  cell.searchSFC.isHidden = false
            }
        }else{
             cell.searchSFC.isHidden = true
        }
        
        
        if let wscBooking = self.searchCollection_List[indexPath.row]["is_wsq"] as? Int {
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
                  
                  vc.lessonId =  self.searchCollection_List[indexPath.row]["id"] as? Int
                          vc.hidesBottomBarWhenPushed = true

              self.navigationController?.pushViewController(vc, animated: true)

    }
//
//              if let isLearning = self.featuredCourses[indexPath.row]["is_elearning"] as? Int {
//
//                  if isLearning == 0 {
//                      cell.featuredIsLearning.isHidden = true
//                  }else{
//                       cell.featuredIsLearning.isHidden = false
//                  }
//              }else{
//                   cell.featuredIsLearning.isHidden = true
//              }
//
              
              
              
//              if let sfcBooking = self.featuredCourses[indexPath.row]["sfc_booking_type"] as? Int {
//                  if sfcBooking == 0 {
//                       cell.featuredSFC.isHidden = true
//                  }
//                  else{
//                        cell.featuredSFC.isHidden = false
//                  }
//              }else{
//                   cell.featuredSFC.isHidden = true
//              }
//
             
//
//              if let wscBooking = self.featuredCourses[indexPath.row]["is_wsq"] as? Int {
//                  if wscBooking == 0 {
//                      cell.featuredWSQ.isHidden = true
//                  }
//                  else {
//                      cell.featuredWSQ.isHidden = false
//                  }
//              }else
//              {
//                   cell.featuredWSQ.isHidden = true
//              }
//
               
             
              
              
//          }
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 47
    }
    
    @IBAction func searchTapped(_ sender: Any) {
        
        search_List.append(searchTxt.text!)
        searchContent(searchStr: searchTxt.text!)
         UserDefaults.standard.set(search_List, forKey: "Search_List")
        
        searchTxt.resignFirstResponder()
    }
    
  
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(search_List, forKey: "Search_List")
    }
    
    @objc func goBack() {
          
        self.navigationController?.popViewController(animated: true)
           
         }

}
