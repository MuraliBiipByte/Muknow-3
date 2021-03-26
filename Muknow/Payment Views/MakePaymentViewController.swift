//
//  MakePaymentViewController.swift
//  Muknow
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import ActionSheetPicker
import Stripe

class MakePaymentViewController: UIViewController,STPAddCardViewControllerDelegate {
  
    @IBOutlet var txtCardNumber: UITextField!
    @IBOutlet var txtExpiryMonth: UITextField!
    @IBOutlet var txtExpiryYear: UITextField!
    @IBOutlet var txtCVV: UITextField!
    
    @IBOutlet var TotalAmountPayLbl: UILabel!
    
    var monthNames = [String]()
    var years = [String]()
    var StripePayAmount = String()
    var strUserId = String()
    var transaction_id :String = ""
    var isLgw : Bool = false
    var paramsDict = [String:Any]()
    var AccessToken : String = ""
    var sessionId : String = ""
    var gstAmount : String = ""
    var gstAmountFinal : String = ""
    var subTot : String = ""
//    var ticketType : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let droppedStr = gstAmount.dropFirst(2)
//        gstAmountFinal = droppedStr
//        let tmp = String(droppedStr)
//        gstAmountFinal = String(format: "%.2f", tmp)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
     
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        strUserId = UserDefaults.standard.string(forKey: "user_id")!

        if isLgw {
            
            STPAPIClient.shared().publishableKey = STRIPE_LGW_PUBLISHABLE_KEY
            
                    self.TotalAmountPayLbl.text = String(format: " Amount : %@", arguments: [StripePayAmount])
            
            
//              STPPaymentConfiguration.shared().publishableKey = STRIPE_LGW_PUBLISHABLE_KEY
        }else
        {
            STPAPIClient.shared().publishableKey = STRIPE_SMILES_PUBLISHABLE_KEY
            
            self.TotalAmountPayLbl.text = String(format: " Amount : $ %@", arguments: [StripePayAmount])

//            STPPaymentConfiguration.shared().publishableKey = STRIPE_SMILES_PUBLISHABLE_KEY

        }
       
//        self.TotalAmountPayLbl.text = String(format: " Amount : %@", arguments: [StripePayAmount])
        
//        print(paramsDict)
        
        self.monthNames = ["1","2","3","4","5","6","7","8","9","10","11","12"];
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let result = formatter.string(from: date)
        let year:Int? = Int(result)
        self.years.append(String(format:"%d",year!))
        
        for i in 1 ... 15
        {
            let year1 = year! + i
            self.years.append(String(format: "%d", year1))
            
        }
        
    }
    
    
    @IBAction func monthBtn_Tapped(_ sender: Any) {

        self.view.endEditing(true)

        if (txtCardNumber.text?.count)! < 16
        {
            self.showAlert(message: "Card details are invalid. Enter valid data")
        }
        else
        {
            ActionSheetStringPicker.show(withTitle: "Select Month", rows: monthNames, initialSelection: 0, doneBlock:
                {
                picker, value, index in

                print("value = \(value)")

                self.txtExpiryMonth.text = self.monthNames[value]

                return
            }, cancel: { ActionStringCancelBlock in return }, origin: sender)
        }

       
    }
    
    @IBAction func yearBtn_Tapped(_ sender: Any) {
        self.view.endEditing(true)
        ActionSheetStringPicker.show(withTitle: "Select Year", rows: years, initialSelection: 0, doneBlock:
            {
            picker, value, index in
            
            print("value = \(value)")
            
            self.txtExpiryYear.text = self.years[value]
    
            return
        }, cancel: { ActionStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func makePayment_Tapped(_ sender: Any) {
        self.view.endEditing(true)
        
        if (txtCardNumber.text?.isEmpty)!
        {
            self.showAlert(message:"Card Number can't be empty!")
            self.txtCardNumber.resignFirstResponder()
            return
        }
        //if (txtExpiryMonth.text?.isEmpty)!
        if (txtExpiryMonth.text == "   Month")
        {
            self.showAlert(message:"Month Can't be empty")
            self.txtExpiryMonth.resignFirstResponder()
            return
        }
        //if (txtExpiryYear.text?.isEmpty)!
        if (txtExpiryYear.text == "   Year")
        {
            self.showAlert(message:"Year Can't be empty")
            self.txtExpiryYear .resignFirstResponder()
            return
        }
        if (txtCVV.text?.isEmpty)!
        {
            self.showAlert(message:"CVV Number Can't be empty")
            self.txtCVV .resignFirstResponder()
            return
        }
        //   let addCardViewController = STPAddCardViewController()
        
        let cardParams = STPCardParams()
        print(self.txtCardNumber.text ?? "",self.txtExpiryMonth.text ?? "",self.txtExpiryYear.text ?? "",self.txtCVV.text ?? "")
        let monthstr = "\(self.txtExpiryMonth.text!)"
        let month  = Int(monthstr)!
        let yearstr = "\(self.txtExpiryYear.text!)"
        let year:Int = Int(yearstr)!
        let cvvNumber = "\(self.txtCVV.text!)"
        cardParams.number = self.txtCardNumber.text
        cardParams.expMonth = UInt(month)
        cardParams.expYear = UInt(year)
        cardParams.cvc = cvvNumber
        // cardParams.currency = "SGD"
        
        print(self.txtCardNumber.text ?? "",self.txtExpiryMonth.text ?? "",self.txtExpiryYear.text ?? "",self.txtCVV.text ?? "")
        self.view.StartLoading()
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else
            {
                self.showAlert(message: (error?.localizedDescription)!)
                self.view.StopLoading()
                return
            }
            print(token.tokenId)
            let tkn = "\(token.tokenId)"
            
            if self.isLgw {
                // lgw payment
                
                self.AccessToken = UserDefaults.standard.object(forKey: "access_token") as! String
                /* var gstAmount = 0.00
                if self.paramsDict["is_gst"] as? Int == 0 {
                    gstAmount = 0.00
                }else{
                    //gstAmount = (self.paramsDict["gst"] as? Int)!
                    let tmpGst : Double = Double("\(self.paramsDict["gst"]!)")!
                    gstAmount = (tmpGst * 100).rounded() / 100
                } */
                
//                let roundedValue1 = (0.6844 * 1000).rounded() / 1000
//                let roundedValue2 = (0.6849 * 1000).rounded() / 1000
                let tmp1 : Double = self.paramsDict["grosse_total"]! as! Double
                let roundedGrossTotal = (tmp1 * 100).rounded() / 100
//                let roundedGrossTotal = ((Float(self.paramsDict["grosse_total"]!)) * 100) .rounded() / 100
                
                
                
                let tmp11 : Double = Double("\(self.paramsDict["price"]!)")!
                let roundedPrice = (tmp11 * 100).rounded() / 100
                
                
                let disCountTmp : Double = Double("\(self.paramsDict["discount_amount"]!)")!
                let roundedDiscount = (disCountTmp * 100).rounded() / 100
                
            print(self.AccessToken)
                let paramsDic = ["token":self.AccessToken,
                                 "can_book_without_session":self.paramsDict["can_book_without_session"]!,
                                 "session_id" : self.paramsDict["session_id"]!,
                                 "lesson_id":self.paramsDict["lesson_id"]!,
                                 "gross_total": self.subTot,
                                 //String(format: "%.2f", roundedGrossTotal),//String(format: "%.2f", roundedPrice), //roundedPrice, //self.paramsDict["price"]!,
                                 "tax": self.gstAmount.dropFirst(2),//self.gstAmountFinal,//self.gstAmount,//String(format: "%.2f", gstAmount), //gstAmount, //0,
                                 "discounts": String(format: "%.2f", roundedDiscount),//self.paramsDict["discount_amount"]!,
                                 "total": String(format: "%.2f", roundedGrossTotal), //roundedGrossTotal,//self.paramsDict["grosse_total"]!,
                                 "points_applied":0,
                                 "coupon_code":self.paramsDict["coupon_code"]!,
                                 "lesson_name":self.paramsDict["title"]!,
                                 "description":self.paramsDict["name"]!,
                                 "unit_price":self.paramsDict["price"]!,
                                 "quantity" : 1,
                                 "is_wsq" : self.paramsDict["is_wsq"]!,
                                 "is_sfc" : self.paramsDict["skills_future_credit_claimable"]!,
                                 "stripe_token" : tkn,
                                 "ticket_type_id" : self.paramsDict["ticket_type_id"]!
                    
                ]
                
                print("Stripe Payment PArams :",paramsDic)
                
                
                ApiManager().postRequest(service:WebServices.LGW_STRITPE_PAYMENT, params: paramsDic )
                { (result, success) in
                    self.view.StopLoading()
                    
                    if success == false
                    {
                        self.showAlert(message: result as! String)
                        return
                    }
                    else
                    {
                        
                        let response = result as! [String:Any]
                        print(response)
                        
                        if let code : Int = response["code"] as? Int {
                            print(code)
                            if code == 404 {
                                self.showAlert(message: response["error"] as! String)
                            }else if code == 422 {
                                self.showAlert(message: response["error"] as! String)

                            }else{
                                self.showAlert(message: "Booking failed")
                            }
                        }
                        else{
                            
                              self.showAlertWithAction(message: "Payment Successful", selector:#selector(self.goToHome))
                        }
                    }
                }
            }
            else {
                
                let SubId = UserDefaults.standard.object(forKey: "Sub_id") as! String
               
                let referCode = UserDefaults.standard.object(forKey: "Refer_Code") as! String

                
                
                let paramsDic = ["amount":self.StripePayAmount,"lgw_user_id":self.strUserId,"stripetoken":tkn,"sub_id":SubId,"refferal_code":referCode]
                print(paramsDic)
                
                
                ApiManager().postRequest(service:WebServices.STRITPE_PAYMENT, params: paramsDic )
                { (result, success) in
                    self.view.StopLoading()
                    
                    if success == false
                    {
                        self.showAlert(message: result as! String)
                        return
                    }
                    else
                    {
                        
                        let response = result as! [String:Any]
                        let data = response ["data"] as! [String:Any]
                        let Resp = data ["response"] as! [String:Any]
                        
                        self.transaction_id = Resp["transaction_id"] as! String
                        
                        //                    let message = response["message"] as! String
                        self.showAlertWithAction(message:"Payment Successfully Completed.Your transaction id is : \(self.transaction_id)", selector:#selector(self.goToHome))
                        
                    }
                }
            }
        }
    }
    
    
    func showAlertWithAction(message:String,selector:Selector)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
    }
    
    
    @objc func goToHome()
    {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewControllers = self.navigationController?.viewControllers {
                    for viewController in viewControllers {
                        if viewController.isKind(of: NewHomeViewController.self) {
                            print("Your controller exist")
                        }
               }
        }
        let dashboardVC = navigationController!.viewControllers.filter { $0 is NewHomeViewController }.first!
        navigationController!.popToViewController(dashboardVC, animated: true)
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
          dismiss(animated: true, completion: nil)
      }
      

    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock)
     {
        
         
     }
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
    
    
    @IBAction func back_vc(_ sender: Any) {
        
        let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2]
        
        if (vc?.isKind(of: StripeRegistrationViewController.self))!{
            if let viewControllers = self.navigationController?.viewControllers {
                for viewController in viewControllers {
                    if viewController.isKind(of: SubscriptionListViewController.self) {
                        self.navigationController?.popToViewController(viewController, animated: true)
                    }
                }
            }
        }else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
}
//struct GameResult {
//    @Rounded(rule: NSDecimalNumber.RoundingMode.up,scale: 4)
//    var score: Decimal
//}
