//
//  SessionBookingViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SessionBookingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    

    @IBOutlet var lblTxt: UILabel!
    var Id :Int?
    var bookingList : NSMutableArray!
    var arrproductsData = [AnyObject]()
    
    var startTime :String?
    var endTime :String?
    var className = String()
    var GST = Int()
    var canbookwithsession = Int()
    var DetailsDict = [String:Any]()
    var tmpStr : String? = nil
    
    @IBOutlet var BookingTV: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
          
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
          //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
          
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        self.BookingTV.isHidden = true
        self.BookingTV.separatorColor = .clear
    //  BookingTV.estimatedRowHeight = 100
        BookingTV.rowHeight = UITableView.automaticDimension
        BookingTV.tableFooterView = UIView()
        self.getAllCourseDetails()
   
        
    }
    

    func getAllCourseDetails()
    {
        
        let totalStr = WebServices.SESSIONS + "/" + "\(Id!)"
        
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
                self.arrproductsData = response["data"] as! [AnyObject]
                
                if  self.arrproductsData.count > 0 {
                    self.BookingTV.reloadData()
                    self.BookingTV.isHidden = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrproductsData.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseBookingTableViewCell")as! CourseBookingTableViewCell
        
        cell.bookBtn.isHidden = true
        cell.soldoutLbl.isHidden = true
        
        cell.ticketNameLbl.text = "\((self.arrproductsData[indexPath.row]["name"]!)!)"
        cell.ticketNameLbl.textAlignment = .center
        let dateFormatter = DateFormatter()
        
//        cell.addressLbl.text = self.arrproductsData[indexPath.row]["display_address"] as? String
        
        cell.priceLbl.text =  String(format: " $ %.2f", arguments: [Double("\(self.arrproductsData[indexPath.row]["price"]! ?? "0")")!])
        
        if let startdateStr = self.arrproductsData[indexPath.row]["start_datetime"] as? String {
            // Our date format needs to match our input string format
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFromString1 = dateFormatter.date(from: startdateStr)
         
            dateFormatter.timeStyle = .medium
            dateFormatter.dateFormat = "hh:mm a"
            startTime = dateFormatter.string(from: dateFromString1!)
            let myCalendar = Calendar(identifier: .gregorian)

            let weekDay = myCalendar.component(.weekday, from: dateFromString1!)
            
                      
           // weekDay += 1
            
            if weekDay == 1 {
                 WeekDay = "Sunday"
                
            }else if weekDay == 2 {
                WeekDay = "Monday"
               
            }else if weekDay == 3 {
                 WeekDay = "Tuesday"
              
            }else if weekDay == 4 {
                  WeekDay = "Wednesday"
              
            }else if weekDay == 5 {
                  WeekDay = "Thursday"
               
            }else if weekDay == 6 {
                 WeekDay = "Friday"
               
            }else if weekDay == 7 {
                WeekDay = "Saturday"
            }
          
        }else{
            startTime = ""
        }
        
        
        if let enddateStr = self.arrproductsData[indexPath.row]["end_datetime"] as? String {
            // Our date format needs to match our input string format
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFromString1 = dateFormatter.date(from: enddateStr)
            
            dateFormatter.timeStyle = .medium
            dateFormatter.dateFormat = "hh:mm a"
            print("EndDate Str = ",dateFormatter.string(from: dateFromString1!))
            endTime = dateFormatter.string(from: dateFromString1!)
        }else{
            endTime = ""
        }
       
        if let startdateStr = self.arrproductsData[indexPath.row]["end_datetime"] as? String {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFromString1 = dateFormatter.date(from: startdateStr)
            
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd MMM"
            
            tmpStr = dateFormatter.string(from: dateFromString1!)
            cell.bookingDateLbl.text = tmpStr //dateFormatter.string(from: dateFromString1!)
           
            
        }
        else{
            cell.bookingDateLbl.text = ""
        }
        
//        registration close date need to do it
        
        cell.bookingPeriodLbl.text = String(format: " %@, %@ to %@",WeekDay,startTime!,endTime!)
        
        cell.bookBtn.addTarget(self, action: #selector(self.Book_Session_Tapped), for: .touchUpInside)
        cell.bookBtn.tag = indexPath.row
        
        
        
        let soldOut = "\(self.arrproductsData[indexPath.row]["is_sold_out"]! ?? "0")"
        if soldOut == "1"{
            cell.bookBtn.isHidden = true
            cell.soldoutLbl.isHidden = false
            cell.soldoutLbl.text = "SOLD OUT"
        }else{
//            let lastBookingDate = "\(self.arrproductsData[indexPath.row]["last_booking_datetime"]! ?? "0")"
            if let lastBookingDate = self.arrproductsData[indexPath.row]["last_booking_datetime"] as? String {
//                let currentDateTime = COMMONFUNCTION.getCurrentDateTime()
//                print("Current DateTime : ",currentDateTime)
                
                let currentDate = COMMONFUNCTION.getCurrentDate()
                
                
                let endDT = COMMONFUNCTION.getDateFrom(string: lastBookingDate, format: "yyyy-MM-dd HH:mm:ss")
                print("endDT :",endDT)
                if endDT < currentDate {
                    print("endDT is < currentDT")
                    cell.bookBtn.isHidden = true
                    cell.soldoutLbl.isHidden = false
                    cell.soldoutLbl.text = "Registration Closed"
                }else{
                    print("endDT is > currentDT")
                    cell.bookBtn.isHidden = false
                    cell.soldoutLbl.isHidden = true
                }
                
                /* if indexPath.row == 2 {
                    let tmpDT = COMMONFUNCTION.getDateFrom(string: "2021-01-28 12:38:00" , format: "yyyy-MM-dd HH:mm:ss")
                    print("Current Date :",currentDate)
                    print("tmpDT : ",tmpDT)
                    if tmpDT > currentDate {
                        print("tmpDT > currentDate...")
                    }else{
                        print("tmpDT < currentDate...")
                    }
                    cell.bookBtn.isHidden = true
                    cell.soldoutLbl.isHidden = false
                    cell.soldoutLbl.text = "Registration Closed"
                }*/
                
            }else{
                print("No lastBookingDate...")
            }
            
            
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
    
    var WeekDay : String = ""
    
    @objc func Book_Session_Tapped(sender : UIButton?) {
        
        let indexPath = IndexPath(row: sender!.tag, section: 0)
        let cell = BookingTV.cellForRow(at: indexPath) as! CourseBookingTableViewCell
        
        
        let dateFormatter = DateFormatter()
        
        let dictObj = self.arrproductsData[(sender?.tag)!]
        print(dictObj)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LGWCheckoutViewController") as! LGWCheckoutViewController
        
        vc.isSessions = false
        //            vc.classname = (dictObj["title"] as? String)!
        vc.quantity = (dictObj["slots"] as? Int)!
        vc.isSessions = true
        vc.subTotal = (dictObj["price"] as? String)!
        vc.sessionId = (dictObj["session_id"] as? Int)!
        vc.classname = className
        vc.gstTotal = GST
//        vc.tickType = (dictObj["name"] as? String)!
        self.DetailsDict["name"] = (dictObj["name"] as? String)!
        self.DetailsDict["ticket_type_id"] = "\(dictObj["ticket_type_id"] as! Int)"//(dictObj["ticket_type_id"] as? String)!
        vc.DetailsDict = self.DetailsDict

//        is_gst
        
        if let startdateStr = dictObj["end_datetime"] as? String {
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let dateFromString1 = dateFormatter.date(from: startdateStr)
            
            dateFormatter.dateStyle = .medium
            dateFormatter.dateFormat = "dd MMM"
            
            let weekAndDate = dateFormatter.string(from: dateFromString1!)
            print(weekAndDate)
            
            let myCalendar = Calendar(identifier: .gregorian)
            
            let weekDay = myCalendar.component(.weekday, from: dateFromString1!)
           // print(weekDay)
            
            
            if weekDay == 0 {
                WeekDay = "Monday"
            }else if weekDay == 1 {
                WeekDay = "Tuesday"
            }else if weekDay == 2 {
                WeekDay = "Wednesday"
            }else if weekDay == 3 {
                WeekDay = "Thursday"
            }else if weekDay == 4 {
                WeekDay = "Friday"
            }else if weekDay == 5 {
                WeekDay = "Saturday"
            }else if weekDay == 6 {
                WeekDay = "Sunday"
            }
            
            
            
            if let startdateStr = dictObj["start_datetime"] as? String {
                // Our date format needs to match our input string format
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFromString1 = dateFormatter.date(from: startdateStr)
                
                dateFormatter.timeStyle = .medium
                dateFormatter.dateFormat = "hh:mm a"
                startTime = dateFormatter.string(from: dateFromString1!)
            }else{
                startTime = ""
            }
            
            
            if let enddateStr = dictObj["end_datetime"] as? String {
                // Our date format needs to match our input string format
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dateFromString1 = dateFormatter.date(from: enddateStr)
                
                dateFormatter.timeStyle = .medium
                dateFormatter.dateFormat = "hh:mm a"
                print(dateFormatter.string(from: dateFromString1!))
                endTime = dateFormatter.string(from: dateFromString1!)
            }else{
                endTime = ""
            }
            
//            vc.sessionsStr = String(format: " %@, %@ to %@",weekAndDate,WeekDay,startTime!,endTime!)
//            vc.sessionsStr = String(format: " %@,%@, %@ to %@",tmpStr as! CVarArg,WeekDay,startTime!,endTime!)//tmpStr ?? "" + String(format: " %@, %@ to %@",WeekDay,startTime!,endTime!)
            vc.sessionsStr = cell.bookingDateLbl.text! + cell.bookingPeriodLbl.text!
            
//            cell.bookingDateLbl.text + String(format: " %@, %@ to %@",WeekDay,startTime!,endTime!)
//            cell.bookingPeriodLbl.text = String(format: " %@, %@ to %@",WeekDay,startTime!,endTime!)
            
        }
        else{
            //            cell.bookingDateLbl.text = ""
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    @IBAction func back_vc(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
