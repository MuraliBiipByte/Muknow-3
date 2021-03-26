//
//  ReferralHistoryViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ReferralHistoryViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var ReferralTable: UITableView!
    
    
    @IBOutlet weak var priceTableBgView: UIView!
    @IBOutlet var PriceTable: UITableView!
    
    var userId : String?
    var Referral_Details = [AnyObject]()
    var Filtered_Referral_Details = [AnyObject]()
    var priceArr = [String]()
    var priceArrUnique = [String]()
    var priceArrStatic = ["1","3"]
    var FilterArr = [String]()
    var datePicker : UIDatePicker!

    var selectedDate : String = ""
    var selectedPrice : String = ""
    
    @IBOutlet var FilterView: UIView!
    @IBOutlet weak var selectPriceLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.priceTableBgView.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        self.FilterView.isHidden = true
//        self.FilterArr = ["Date","Price"]
        
        self.ReferralTable.isHidden = true

        ReferralTable.dataSource = self
        ReferralTable.delegate = self
        ReferralTable.separatorColor = .clear
        ReferralTable.tableFooterView = UIView.init(frame: CGRect.zero)
        
        PriceTable.dataSource = self
        PriceTable.delegate = self
        PriceTable.separatorColor = .clear
        PriceTable.tableFooterView = UIView.init(frame: CGRect.zero)

        self.PriceTable.isHidden = true
        self.selectPriceLbl.isHidden = true
        self.PriceTable.isScrollEnabled = false
        
        
        userId = UserDefaults.standard.string(forKey: "user_id")
       
        self.getReferralHistoryData()

    }
    
    
    
    
    func getReferralHistoryData() {
    
        //        http://devservices.mu-know.com:8080/smiles_stripe_payment_customer_transaction_history?lgw_user_id=27279
        
        
        let params = ["lgw_user_id":userId!,"date":selectedDate,"price":selectedPrice] as [String:Any]
        
        print(params)
        
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.REFERRAL_HISTORY, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                
                self.ReferralTable.isHidden = true
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                print(data)
                let subscriptionresponse = data ["response"] as! [String:Any]
                let subscriptiondata = subscriptionresponse ["data"] as! [String:Any]
                                
                self.Referral_Details = (subscriptiondata["transaction_details"] as? [AnyObject]) != nil  ?  (subscriptiondata["transaction_details"] as! [AnyObject]) : []
                
                 print(self.Referral_Details)
                if (self.Referral_Details.count > 0)
                {
                    self.ReferralTable.reloadData()
                    self.ReferralTable.isHidden = false
                    
                    
                   /*
                    self.priceArrUnique.removeAll()
                    self.priceArr.removeAll()
                    for a in self.Referral_Details {
                        let dict = a as! NSDictionary
                        let amount  = "\(dict.value(forKey: "amount")!)"
                        self.priceArr.append(amount)
                    }
                    self.priceArrUnique = Array(Set(self.priceArr))
                    self.priceArrUnique.sort() */
                    self.PriceTable.reloadData()
                    
                }
                else{
                    self.ReferralTable.isHidden = true
                    self.showAlert(message:"No Referral History")
                    
                    self.FilterView.isHidden = true
                }
            }
        }
    }
    
    func getReferralHistoryDataForFilter() {
    
        //        http://devservices.mu-know.com:8080/smiles_stripe_payment_customer_transaction_history?lgw_user_id=27279
        
        
        let params = ["lgw_user_id":userId!,"date":selectedDate,"price":selectedPrice] as [String:Any]
        
        print(params)
        
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.REFERRAL_HISTORY, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                
                self.ReferralTable.isHidden = true
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                
                let subscriptionresponse = data ["response"] as! [String:Any]
                let subscriptiondata = subscriptionresponse ["data"] as! [String:Any]
                     
                self.Referral_Details.removeAll()
                self.Referral_Details = (subscriptiondata["transaction_details"] as? [AnyObject]) != nil  ?  (subscriptiondata["transaction_details"] as! [AnyObject]) : []
                
                 print(self.Referral_Details)
                if (self.Referral_Details.count > 0)
                {
                    self.ReferralTable.reloadData()
                    self.ReferralTable.isHidden = false 
                }
                else{
                    self.ReferralTable.reloadData()
                    self.ReferralTable.isHidden = true
                    self.showAlert(message:"No Referral History")
                    
                }
                
            }
            
        }
        
    }
    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if tableView == ReferralTable {
                return self.Referral_Details.count
            }
            else{
                //return self.priceArrUnique.count
                return self.priceArrStatic.count
            }
        }
        
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
              
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransationHistoryTableViewCell") as? TransationHistoryTableViewCell
           
        if tableView == ReferralTable{
        
        cell!.referral_amount.text =  String(format: "Referral Amount : $ %@",self.Referral_Details[indexPath.row]["amount"] as! String)

        
          cell!.referral_id.text =  String(format: "%@",self.Referral_Details[indexPath.row]["transaction_id"] as! String)
          
            cell!.referral_date.text =  String(format: "%@",self.Referral_Details[indexPath.row]["transaction_date"] as! String)
        }
        else{
//            cell!.filterPriceLbl.text = "$" + self.priceArrUnique[indexPath.row]
            cell?.filterPriceLbl.text = "$" + self.priceArrStatic[indexPath.row]
        }
        
        
        cell!.selectionStyle = .none
           return cell!
           
       }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == ReferralTable {
        return 101
        }else{
            return 65
//            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == PriceTable {
//            self.selectedPrice = self.priceArrUnique[indexPath.row]
            self.selectedPrice = self.priceArrStatic[indexPath.row]
            
            self.PriceTable.isHidden = true
            self.selectPriceLbl.isHidden = true
            self.priceTableBgView.isHidden = true
            
            //self.getReferralHistoryData()
            self.selectedDate = ""
            self.getReferralHistoryDataForFilter()
            
        }
         
    }
    
    @IBAction func filter_Tapped(_ sender: Any) {
      /*
        if self.Referral_Details.count > 0 {
            self.FilterView.isHidden = false
        } */
        if self.FilterView.isHidden {
            self.FilterView.isHidden = false
        }else{
            self.FilterView.isHidden = true
        }
        
        
        
    }
    
    var toolBar = UIToolbar()
    var picker  = UIDatePicker()
    
    
    @IBAction func filterbyDate(_ sender: Any) {
        
        datePicker = UIDatePicker.init()
         datePicker.backgroundColor = UIColor.white

         datePicker.autoresizingMask = .flexibleWidth
         datePicker.datePickerMode = .date

         datePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
         datePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
         self.view.addSubview(datePicker)

        toolBar.barStyle = .default

         toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDoneButtonClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)

        
        
        
//         toolBar.barStyle = .blackTranslucent
//         toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        
//        toolBar.backgroundColor = .white
        
//        toolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))]

//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))

        
         toolBar.sizeToFit()
         self.view.addSubview(toolBar)
        
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "de_DE") as Locale
//        dateFormatter.dateStyle = DateFormatter.Style.long
//              dateFormatter.dateFormat = "dd. MMMM yyyy"
//              let currentDateTime = NSDate()
//        self.selectedDate = dateFormatter.string(from: currentDateTime as Date)
//        self.selectedDate=strDob
        self.FilterView.isHidden = true
        
    }
    
//    var filterDate = String()
    
    
    @objc func dateChanged(_ sender: UIDatePicker?) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        selectedDate = dateFormatter.string(from: datePicker.date)
//
//
//        if let date = sender?.date {
//            selectedDate = dateFormatter.string(from: date)
//            print("Picked the date \(dateFormatter.string(from: date))")
//        }
    }

    @objc func onDoneButtonClick() {
        
        
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            selectedDate = formatter.string(from: datePicker.date)
        print(selectedDate)
            self.view.endEditing(true)
        
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        
        self.selectedPrice = ""
        self.getReferralHistoryDataForFilter()
        
        
    }
    
    
    
    @IBAction func filterbyPrice(_ sender: Any) {
        
        self.FilterView.isHidden = true
        self.PriceTable.isHidden = false
        self.selectPriceLbl.isHidden = false
        self.priceTableBgView.isHidden = false
    }
    
    
       
    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
    }
       
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
        
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
  

}
