//
//  LGWCheckoutViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class LGWCheckoutViewController: UIViewController,UITextFieldDelegate {

    
    @IBOutlet weak var couponAppliedAlert: UIView!
    var isSessions : Bool = false
    var classname = String()
    var sessionsStr = String()
    
    var quantity : Int = 0
    var PaxArr =  [String]()
    
    var subTotal = String()
    var gstTotal = Int()
    var sessionId = Int()

    var discountAmount : String = "0.00"
    
//    var tickType : String?
    
    
    @IBOutlet var submitBtn: UIButton!
    
    @IBOutlet var dropDownArr: UIImageView!
    
    @IBOutlet var classNameLbl: UILabel!
    @IBOutlet var quantityLbl: UILabel!
    @IBOutlet var subTotalLbl: UILabel!
    
    @IBOutlet var discountLbl: UILabel!
    
    @IBOutlet var sessionsViewHeight: NSLayoutConstraint!
    
    @IBOutlet var sessionView: UIView!
    @IBOutlet var grandTotalLbl: UILabel!
    
    @IBOutlet var sessionsLbl: UILabel!
    
   // @IBOutlet var PaxTable: UITableView!
    
    var userId :String = ""
    var accessToken :String = ""
    var DiscountDict = NSDictionary()

    @IBOutlet var couponTxt: UITextField!
   // @IBOutlet var paxview: UIView!
    @IBOutlet var gstLbl: UILabel!
    @IBOutlet var gstView: UIView!
    @IBOutlet var gstViewHeight: NSLayoutConstraint!
 
    var DetailsDict = [String:Any]()
    
    @IBOutlet var applyCouponLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.couponAppliedAlert.isHidden = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
               
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        //
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        
           self.dropDownArr.transform = CGAffineTransform(rotationAngle: (CGFloat.pi / 2))
        
        self.couponTxt.delegate = self
        userId = UserDefaults.standard.string(forKey: "user_id")!
        accessToken = UserDefaults.standard.string(forKey: "access_token")!

        
        
        
        
        
//        print(DetailsDict)
        
        
        
        
        
        
        
        
//        let double1 = Double("\(subTotal)")!
//               let double2 = Double("\(discountAmount)")!
//
//                let double3 = double1 + double2
//               print(double3)
        
      
//        self.grandTotalLbl.text = String(format: " $ %.2f", arguments: [(Double("\(subTotal)")! - Double("\(discountAmount)")!)])
        
        self.quantity = 1
    
//        for n in 1...quantity {
//            print(n)
//            self.PaxArr.append("\(n) pax")
//        }
//
//        print(self.PaxArr)
//
//        paxview.isHidden = true
//
//        self.PaxTable.tableFooterView = UIView.init(frame: CGRect.zero)

        print(gstTotal)
        if gstTotal == 0 {
            
            self.gstView.isHidden = true
            self.gstViewHeight.constant = 0
            
            self.grandTotal = (Double("\(subTotal)")! - Double("\(discountAmount)")!)

            
          self.grandTotalLbl.text =  String(format: " $ %.2f", arguments: [Double("\(self.grandTotal)")!])
           // self.grandTotalLbl.text = String(format: " $ %@", "\(self.grandTotal)")

            
        }else{
            self.gstView.isHidden = false
            self.gstViewHeight.constant = 45

            
           let double1  = (Double("\(subTotal)")! - Double("\(discountAmount)")!)
            
            let double2 = Double(gstTotal)/100.0
         
         
            let tax = Double(double1) * double2
            
           
            self.gstLbl.text = String(format: " $ %.2f", arguments: [Double("\(tax)")!])
//            gstTotal
            
            self.grandTotal = (Double("\(subTotal)")! - Double("\(discountAmount)")! + tax)


            self.grandTotalLbl.text = String(format: " $ %@","\(self.grandTotal)")

//            self.gstLbl.text = String(format: " $ %.2f", arguments: [Double("\(gstTotal)")!])
        }
        
    }
   
   

    override func viewWillAppear(_ animated: Bool) {
       
        self.classNameLbl.text = classname
        self.couponTxt.isUserInteractionEnabled = true

        self.submitBtn.backgroundColor = APPEARENCE_COLOR
        self.submitBtn.isUserInteractionEnabled = true

        
        if isSessions {
            // sessions present
            self.sessionsViewHeight.constant = 50
            self.sessionsLbl.text = self.sessionsStr
            self.sessionView.isHidden = false
        }else{
            // absent
             self.sessionsViewHeight.constant = 0
              self.sessionView.isHidden = true
        }
        
        self.quantityLbl.text = "1 pax"
        self.subTotalLbl.text = String(format: " $ %.2f", arguments: [Double("\(subTotal)")!])
     
    }
    
    
    var grandTotal  : Double = 0.0
    
    @IBAction func proceedToPayment_Tapped(_ sender: Any) {
         
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MakePaymentViewController") as! MakePaymentViewController
        vc.isLgw = true
        
        print(self.grandTotalLbl.text!)
        
        self.DetailsDict["grosse_total"] = self.grandTotal
        self.DetailsDict["coupon_code"] = self.couponTxt.text!
        self.DetailsDict["discount_amount"] = self.discount
        self.DetailsDict["session_id"] = self.sessionId
        vc.paramsDict = self.DetailsDict
           vc.StripePayAmount = self.grandTotalLbl.text!
        vc.gstAmount = self.gstLbl.text!
        vc.subTot = String(format: " %.2f", arguments: [Double("\(subTotal)")!])
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func paxBtn_Tapped(_ sender: Any) {
//         paxview.isHidden = false
    }
    
    
    @IBAction func submit_Couponcode(_ sender: Any) {
            
        if self.couponTxt.text == "" {
            self.showAlert(message: "Enter Coupon")
        }
        else {
            
            let paramsDict = [
                "token":accessToken,
                "coupon":self.couponTxt.text!,
                "lesson_provider_id": "\(self.DetailsDict["lesson_provider_id"]!)" //self.userId
                ] as [String : Any]
            
            print("\(paramsDict)")
            
            self.view.StartLoading()
            ApiManager().postRequestToGetAccessToken(service:WebServices.LGW_COUPON, params: paramsDict as [String : Any])
            { (result, success) in
                self.view.StopLoading()
                
                if success == false
                {
                    self.showAlert(message: result as! String )
                    return
                }
                else
                {
                    
//                    ["error": The coupon code you have entered is invalid. Please, contact administrator., "code": 404]
                    
                    let resultDictionary = result as! [String : Any]
                    print("\(resultDictionary)")
                    
                  
                    if let code : Int = resultDictionary["code"] as? Int {
                        print(code)
//                        if code == 404 {
                            self.showAlert(message: resultDictionary["error"] as! String)
//                        }else{
//
//                        }
                    }
                    
                    else{
                        
                        self.applyCouponLbl.text = "Coupon Applied "
//                        self.couponTxt.text = "Coupon Applied successfully"
                        self.couponAppliedAlert.isHidden = false
                        self.couponTxt.isUserInteractionEnabled = false
                        self.submitBtn.backgroundColor = UIColor.lightGray
                        self.submitBtn.isUserInteractionEnabled = false
                        
                        let  dataArr = (resultDictionary["data"]! as! NSArray).mutableCopy() as! NSMutableArray
                        self.DiscountDict =  dataArr[0] as! NSDictionary
                        
                        let discountType = self.DiscountDict["discount_type"] as? String
                        if discountType == "percent" {
                            
                            /* let DiscountAmt = self.DiscountDict["discount_amount"] as? String
                            
                            self.discount = DiscountAmt!
                            
                            //                        let double1 = Double("\(self.subTotal)")!
                            //                        let double2 = Double("\(DiscountAmt!)")!
                            
                            let discount = Double("\(self.subTotal)")! / Double("\(DiscountAmt!)")!
                            
                            self.discountLbl.text = String(format: " $ %.2f", arguments: [discount])
                            
  
                            let double1  = (Double("\(self.subTotal)")! - Double("\(discount)")!)
                                        
                            let double2 = Double(self.gstTotal)/100.0
                            
                            
                            let tax = Double(double1) * double2
                            
                            
                            self.gstLbl.text = String(format: " $ %.2f", arguments: [Double("\(tax)")!])
                            //            gstTotal
                            
                            self.grandTotal = (Double("\(self.subTotal)")! - Double("\(discount)")! + tax)
                            
                            
                            
//                            self.grandTotal = (Double("\(self.subTotal)")! - discount)
                            
                            self.grandTotalLbl.text = String(format: " $ %@","\(self.grandTotal)") */
                            
                            let discountPercent = Double("\(self.DiscountDict["discount_amount"]!)") //as? String
                            let discountPercentDouble = discountPercent! / 100.0
                            
                            let discountAmt = discountPercentDouble * (Double("\(self.subTotal)"))!
                                //* self.subTotal
                            self.discount = "\(discountAmt)"
                            let discountedTotal  = (Double("\(self.subTotal)")! - Double("\(self.discount)")!)
                            let gstAmt = Double(self.gstTotal)/100.0
                            
                            
                            let gstForDisTotal = gstAmt * Double(discountedTotal)
                            self.grandTotal = discountedTotal + gstForDisTotal
                            
                            
                            self.discountLbl.text = "$ " + self.discount //String(format: " $ %.2f", arguments: [self.discount])
                            self.gstLbl.text = String(format: " $ %.2f", arguments: [Double("\(gstForDisTotal)")!])
                            self.grandTotalLbl.text = String(format: " $ %@","\(self.grandTotal)")
                            
                        }else{
                            
                            let DiscountAmt = self.DiscountDict["discount_amount"] as? String
                            self.discount = DiscountAmt!
                            
                            let discount = Double("\(DiscountAmt!)")!
                            
                            self.discountLbl.text = String(format: " $ %.2f", arguments: [discount])
                            
                            
                            let double1  = (Double("\(self.subTotal)")! - Double("\(discount)")!)
                                        
                            let double2 = Double(self.gstTotal)/100.0
                            
                            
                            let tax = Double(double1) * double2
                            
                            
                            self.gstLbl.text = String(format: " $ %.2f", arguments: [Double("\(tax)")!])
                            //            gstTotal
                            
                            self.grandTotal = (Double("\(self.subTotal)")! - Double("\(discount)")! + tax)
                            
                            
                            
                            
                            
                          //  self.grandTotal = (Double("\(self.subTotal)")! - discount)

                            self.grandTotalLbl.text = String(format: " $ %@", "\(self.grandTotal)")
                            
                        }
                    }

                }
                
            }
        }
    }
    var discount : String  = "0.0"
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.couponTxt.resignFirstResponder()
        return true
    }
    
    
    func showAlert(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
       }
       
    
    @IBAction func backvc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
  
    @IBAction func okBtnTapped(_ sender: UIButton) {
        self.couponAppliedAlert.isHidden = true
    }
    
    
}
