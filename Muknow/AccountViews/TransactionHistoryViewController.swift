//
//  TransactionHistoryViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TransactionHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet var FilterView: UIView!
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBAction func filterBtnTapped(_ sender: UIButton) {
        if self.FilterView.isHidden {
            self.FilterView.isHidden = false
        }else{
            self.FilterView.isHidden = true
        }
    }
    
    var datePicker : UIDatePicker!
    var toolBar = UIToolbar()
    
    var selectedDate : String = ""
    
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
        
         toolBar.sizeToFit()
         self.view.addSubview(toolBar)

        self.FilterView.isHidden = true
        
    }
    
    @objc func dateChanged(_ sender: UIDatePicker?) {

    }

    @objc func onDoneButtonClick() {
        
        
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            //formatter.dateFormat = "dd-MM-yyyy"
            selectedDate = formatter.string(from: datePicker.date)
        print("Selected DAte = ",selectedDate)
            self.view.endEditing(true)
        
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()
        
        self.getTransactionHistoryData()
        
        
    }

    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.removeFromSuperview()
        datePicker.removeFromSuperview()

    }
    
    @IBOutlet var TransactionTable: UITableView!
    var userId : String?
    var Transaction_Details = [AnyObject]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.FilterView.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        
        self.TransactionTable.isHidden = true

        TransactionTable.dataSource = self
        TransactionTable.delegate = self
        TransactionTable.tableHeaderView = UIView.init(frame: CGRect.zero)
        
        self.TransactionTable.separatorColor = .clear
        
        userId = UserDefaults.standard.string(forKey: "user_id")

        getTransactionHistoryData()
    }
    

    func getTransactionHistoryData() {
        //        http://devservices.mu-know.com:8080/smiles_stripe_payment_customer_transaction_history?lgw_user_id=27279
        
        
        let params = ["lgw_user_id":userId!,"date":selectedDate] as [String:Any]
        
        print("Parameters:",params)
        
        
        self.view.StartLoading()
        ApiManager().postRequest(service: WebServices.TRANSACTION_HISTORY, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                 self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                
                let response = result as! [String : Any]
                print("Response = ",response)
                let data = response ["data"] as! [String:Any]
                let subscriptionresponse = data ["response"] as! [String:Any]
                let subscriptiondata = subscriptionresponse ["data"] as! [String:Any]
                
                self.Transaction_Details = (subscriptiondata["transaction_details"] as? [AnyObject]) != nil  ?  (subscriptiondata["transaction_details"] as! [AnyObject]) : []
                
                if (self.Transaction_Details.count > 0)
                {
                    self.TransactionTable.isHidden = false
                    self.TransactionTable.reloadData()
                    self.TransactionTable.contentOffset = .zero
                    
                }else{
                    self.TransactionTable.reloadData()
                    self.TransactionTable.isHidden = true
                    self.showAlert(message: "No Data")
                }
                
            }
            
        }
        
    }
      
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
         return self.Transaction_Details.count
         
     }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
              let cell = tableView.dequeueReusableCell(withIdentifier: "TransationHistoryTableViewCell") as? TransationHistoryTableViewCell
        
        cell!.transactionId.text =  String(format: "Id: %@",self.Transaction_Details[indexPath.row]["transaction_id"] as! String)
        
        cell!.transaction_amount.text =  String(format: "$ %@",self.Transaction_Details[indexPath.row]["amount"] as! String)

        cell!.transaction_status.text =  String(format: "%@",self.Transaction_Details[indexPath.row]["transaction_status"] as! String)

        cell!.transaction_date.text =  String(format: "%@",self.Transaction_Details[indexPath.row]["created_on"] as! String)

        cell!.selectionStyle = .none

        
        return cell!
        
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 130
     }
    
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
    
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
