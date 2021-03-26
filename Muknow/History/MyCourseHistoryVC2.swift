
/////  MyCourseHistoryVC2.swift
//  Muknow
//
//  Created by Apple on 16/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyCourseHistoryVC2: UIViewController {

    @IBOutlet weak var courseTV: UITableView!
    @IBOutlet weak var noDataLbl: UILabel!
    
    var AccessToken : String = ""
    var Course_List = [AnyObject]()
    
    var newString = NSMutableAttributedString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        courseTV.delegate = self
        courseTV.dataSource = self
        
        self.courseTV.isHidden = true
        
        self.courseTV.tableFooterView = UIView.init(frame: CGRect.zero)
        self.courseTV.separatorColor = .black
        self.courseTV.rowHeight = UITableView.automaticDimension

        // Do any additional setup after loading the view.
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         
         let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
         lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
         //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
         
         let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        
        courseTV.register(UINib(nibName: "MyCourseCell", bundle: nil), forCellReuseIdentifier: "MyCourseCellID" )
        
        self.noDataLbl.isHidden = true
        self.CoursesHistoryApi()
    }
    
    @IBAction func back_vc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlert(message:String)
         {
             Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
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
                    self.courseTV.isHidden = false
                    self.courseTV.reloadData()
                }else{
                    self.courseTV.isHidden = true
                    self.noDataLbl.isHidden = false
                }
            }
            
        }
        
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
extension MyCourseHistoryVC2 : UITableViewDelegate ,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        return 180
    }
     
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Course_List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCourseCellID", for: indexPath) as! MyCourseCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        
            cell.courseNameLbl.text = String(format : "%@ ", "\(self.Course_List[indexPath.row]["title"] as! String)")

        if let bookingTime = self.Course_List[indexPath.row]["booking_time"] as? String {
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateFromString1 = dateFormatter.date(from: bookingTime)
            
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd MMM"
            
            let tmpStr = dateFormatter.string(from: dateFromString1!)
            print("tmpstr :",tmpStr)
            
            dateFormatter.dateFormat = "yyyy"
            let tmpStr2 = dateFormatter.string(from: dateFromString1!)
            print("tmpStr2 :",tmpStr2)
            
            print("Final result = ",(tmpStr + "," + tmpStr2))
            cell.bookedOnLbl.text = ("Booked On " + tmpStr + "," + tmpStr2)
            
        }else{
            print("No Booking Time....")
        }
//            cell.bookingId.text = String(format : "Booking Id : %@ ", "\(self.Course_List[indexPath.row]["booking_number"] as! Int)")

        var boldText = "Booking Id : "
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let bookingIDString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        var normalText = "\(self.Course_List[indexPath.row]["booking_number"] as! Int)"
        var normalString = NSMutableAttributedString(string:normalText)
        
        bookingIDString.append(normalString)
        cell.bookingId.attributedText = bookingIDString
        
        
        
        let session = "\((self.Course_List[indexPath.row]["can_book_without_session"]!)!)"//self.Course_List[indexPath.row]["can_book_without_session"] as? String
        if session == "1"{
            //Hide
            cell.bookingDate.text = ""
            cell.bookingTotalTopCons.constant = 0
        }else{
//            cell.bookingDate.text = String(format : "Session Date: %@", "\(self.Course_List[indexPath.row]["start_datetime"] as! String)")
            boldText = "Session Date : "
            let sessionDateStr = NSMutableAttributedString(string:boldText, attributes:attrs)
            
            normalText = "\(self.Course_List[indexPath.row]["start_datetime"] as! String)"
            normalString = NSMutableAttributedString(string: normalText)
            sessionDateStr.append(normalString)
            cell.bookingDate.attributedText = sessionDateStr
            cell.bookingTotalTopCons.constant = 5
        }
        
        
        
        
        
        
        //            cell.bookingTotal.text = String(format: "Booking Total : $%.2f", arguments: [Double("\(self.Course_List[indexPath.row]["total"] as! String)")!])
        boldText = "Booking Total : "
        let bookingTotalStr = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        normalText = String(format: "$%.2f", arguments: [Double("\(self.Course_List[indexPath.row]["total"] as! String)")!])
        normalString = NSMutableAttributedString(string: normalText)
        bookingTotalStr.append(normalString)
        cell.bookingTotal.attributedText = bookingTotalStr
        
        
//            cell.bookingStatus.text = String(format : "Status : %@ ", "\(self.Course_List[indexPath.row]["status"] as! String)")
        boldText = "Status : "
        let statusStr = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        normalText = "\(self.Course_List[indexPath.row]["status"] as! String)"
        normalString = NSMutableAttributedString(string: normalText)
        statusStr.append(normalString)
        cell.bookingStatus.attributedText = statusStr
        
        
        let image =  "\(WebServices.BASE_URL)\(self.Course_List[indexPath.row]["path"] as! String)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        //cell.courseImg.sd_setImage(with: URL(string: image!), placeholderImage: UIImage(named: "PlaceholderImg"))
        
        cell.loaderCourse.isHidden = false
        cell.loaderCourse.startAnimating()
        cell.courseImg.loadImageUsingCacheWithURLString(image!, placeHolder: UIImage(named: "PlaceholderImg"), loader: cell.loaderCourse)
        
       
//            "\(self.Course_List[indexPath.row]["booking_time"]!)"
//        let bookedOn = String(format : "Booked On %@", "\(self.Course_List[indexPath.row]["booking_time"] as! String)")
        
       
        
        return cell
    }
    
    
}
extension MyCourseHistoryVC2 : MyCourseCellDelegate {
    
}

