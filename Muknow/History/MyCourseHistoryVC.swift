//
//  MyCourseHistoryVC.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyCourseHistoryVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
 
    

    var AccessToken : String = ""
    var Course_List = [AnyObject]()

    @IBOutlet weak var noDataLbl: UILabel!
    
    @IBOutlet var HistoryTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         
         let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
         lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
         //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
         
         let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        self.noDataLbl.isHidden = true
        self.CoursesHistoryApi()
        
        //self.HistoryTable.estimatedRowHeight = 160
        
    }

    override func viewWillAppear(_ animated: Bool) {
       
        self.HistoryTable.isHidden = true
        self.HistoryTable.dataSource = self
        self.HistoryTable.delegate = self
        self.HistoryTable.tableFooterView = UIView.init(frame: CGRect.zero)
        self.HistoryTable.separatorColor = .black
        self.HistoryTable.rowHeight = 157
        self.HistoryTable.estimatedRowHeight = 157
        self.HistoryTable.rowHeight = UITableView.automaticDimension

    }

    
    func CoursesHistoryApi() {
        let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
        
        let params = ["token":accessToken] as [String:Any]
        
        
        print(params)
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.COURSES_HISTORY, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                //self.showAlert(message: result as! String)
                print("response is : " + (result as! String))
                self.noDataLbl.isHidden = false
                return
                
            }
            else
            {
                
                
                let resultDictionary = result as! [String : Any]
                
                print(resultDictionary)
                
                
                self.Course_List = (resultDictionary["data"] as? [AnyObject]) != nil  ?  (resultDictionary["data"] as! [AnyObject]) : []

                if self.Course_List.count > 0 {
                    self.HistoryTable.isHidden = false
                    self.HistoryTable.reloadData()
                }else{
                    self.HistoryTable.isHidden = true
                    self.noDataLbl.isHidden = false
                }
                
                
            }
            
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//           return UITableView.automaticDimension
//       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.Course_List.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as? HistoryCell
        

        cell!.courseNameLbl.text = String(format : "%@ ", "\(self.Course_List[indexPath.row]["title"] as! String)")

        cell!.bookingId.text = String(format : "Booking Id : %@ ", "\(self.Course_List[indexPath.row]["booking_number"] as! Int)")

        cell!.bookingDate.text = String(format : "Session Date: %@", "\(self.Course_List[indexPath.row]["start_datetime"] as! String)")

        cell!.bookingTotal.text =  String(format: "Booking Total : $%.2f", arguments: [Double("\(self.Course_List[indexPath.row]["total"] as! String)")!])
        
        cell!.bookingStatus.text = String(format : "Status : %@ ", "\(self.Course_List[indexPath.row]["status"] as! String)")

        let image =  "\(WebServices.BASE_URL)\(self.Course_List[indexPath.row]["path"] as! String)"

        cell!.courseImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))

        return cell!

     }
    
    
    
    
    
    @IBAction func back_vc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showAlert(message:String)
         {
             Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
         }
    

}
