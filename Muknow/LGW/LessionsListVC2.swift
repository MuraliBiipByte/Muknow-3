//
//  LessionsListVC2.swift
//  Muknow
//
//  Created by Apple on 20/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LessionsListVC2: UIViewController {

    @IBOutlet var lessionsCV: UICollectionView!
    
    var lessionId : Int?
    var ArrLessionsList = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        self.lessionsCV.isHidden = true
        self.lessionsCV.delegate = self
        self.lessionsCV.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
               layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.itemSize = CGSize(width: self.view.frame.size.width/2 - 16, height: 170)
               layout.minimumInteritemSpacing = 10
               layout.minimumLineSpacing = 10
               lessionsCV!.collectionViewLayout = layout
    }
    
    var isfilter : Bool  = false
    override func viewWillAppear(_ animated: Bool) {
        if isfilter == false{
            self.getSessionsList()
        }else{
            if  self.ArrLessionsList.count > 0 {
                self.lessionsCV.reloadData()
                self.lessionsCV.isHidden = false
            }
        }
    }
    
    
    func getSessionsList()
    {
        
        let totalStr = WebServices.CATEGORIES + "/" + "\(lessionId!)"
        
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
//
//                print(response)
//

                if let code : Int = response["code"] as? Int {
//                    print(code)
                    if code == 404 {
                        self.showAlert(message: response["error"] as! String)
                    }else{
                        self.ArrLessionsList = response["data"] as! [AnyObject]
                        
                        if  self.ArrLessionsList.count > 0 {
                            self.lessionsCV.reloadData()
                            self.lessionsCV.isHidden = false
                            
                            
                        }
                    }
                }
                else{
                    self.ArrLessionsList = response["data"] as! [AnyObject]
                    
                    if  self.ArrLessionsList.count > 0 {
                        self.lessionsCV.reloadData()
                        self.lessionsCV.isHidden = false
                    }
                }
            }
        }
    }
    
    func showAlert(message:String)
        {
            Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
        }
    @IBAction func back_vc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func filterBtn_Tapped(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
          vc.hidesBottomBarWhenPushed = true
        vc.category_id = self.lessionId
        vc.LLVC = self
//        self.navigationController?.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension LessionsListVC2 : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ArrLessionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier:
                                                        "NewHomeCollectionViewCellID", for: indexPath) as! NewHomeCollectionViewCell
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.masksToBounds = true
        
        
        let imageURLStr =  "\(WebServices.BASE_URL)\(self.ArrLessionsList[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        cell.myLoader.isHidden = false
        cell.myLoader.startAnimating()
        cell.lessionImg.loadImageUsingCacheWithURLString(imageURLStr!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.myLoader)
        cell.lessionImg.contentMode = .scaleAspectFill
        cell.lessionTitle.text = self.ArrLessionsList[indexPath.row]["title"] as? String
        cell.lessonsPriceLbl.text =  String(format: " $ %.2f", arguments: [Double("\(self.ArrLessionsList[indexPath.row]["price"]! ?? "0")")!])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LessonDetailsViewController") as! LessonDetailsViewController
        vc.lessonId =  self.ArrLessionsList[indexPath.row]["id"] as? Int
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
