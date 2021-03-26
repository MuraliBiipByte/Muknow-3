//
//  FilterViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    var category_id : Int?
//    var LLVC : LessionsListViewController?
    var LLVC : LessionsListVC2?
    

    @IBOutlet var minPriceTxt: UITextField!
    
    @IBOutlet var maxPriceTxt: UITextField!
    
    @IBOutlet var minAgeTxt: UITextField!
    
    @IBOutlet var maxAgeTxt: UITextField!
    
    
    var SFCBookingType = String()

    
    var paramDict = [String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
        //
        let rightbarButton = UIBarButtonItem(customView: righticonButton)
        //
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = rightbarButton
  
    }
    
    var ArrFilterList = [AnyObject]()

    
    
    @IBAction func submit_Tapped(_ sender: Any) {
        
//        if self.minPriceTxt.text == "" {
//            self.showAlert(message: "Enter Min Price")
//        }
//        else if self.maxPriceTxt.text == "" {
//            self.showAlert(message: "Enter Max Price")
//        }
//
//        else if optionOne.currentBackgroundImage == UIImage(named: "radioUncheck") && optionTwo.currentBackgroundImage == UIImage(named: "radioUncheck") && optionThree.currentBackgroundImage == UIImage(named: "radioUncheck") && optionFour.currentBackgroundImage == UIImage(named: "radioUncheck") {
//
//            self.showAlert(message: "Select Class Level")
//        }
//
//        else if self.minAgeTxt.text == "" {
//            self.showAlert(message: "Enter Min Age")
//        }
//        else if self.maxAgeTxt.text == "" {
//            self.showAlert(message: "Enter Max Age")
//        }
//
//        else if sfcOptionOne.currentBackgroundImage == UIImage(named: "radioUncheck") && sfcOptionTwo.currentBackgroundImage == UIImage(named: "radioUncheck")  {
//
//            self.showAlert(message: "Select SFC Booking Type")
//        }
            
//        else{
//           let paramsDict = [
//                "min_price":self.minPriceTxt.text!,
//                "max_price":self.maxPriceTxt.text!,
//                "min_age":self.minAgeTxt.text!,
//                "max_age":self.maxAgeTxt.text!,
//                "class_level":self.selectedAnswer,
//                "sfc_booking_type":self.SFCBookingType,
//            "category_id" : "\(category_id!)"
//
//            ]
//        print("paramsDict = \(paramsDict)")
            
        
            //min_price=50&max_price=150&class_level=1&sfc_booking_type=1&min_age=20&max_age=80
            
            
            
        self.paramDict["category_id"] = "\(category_id!)"
        if !(minPriceTxt.text!.isEmpty) {
            if !(maxPriceTxt.text!.isEmpty) {
                if Int(minPriceTxt.text!)! < Int(maxPriceTxt.text!)! {
                    self.paramDict["min_price"] = minPriceTxt.text
                    self.paramDict["max_price"] = maxPriceTxt.text
                }else{
                    showAlert(message: "Max Price Should be Greater than Min Price")
                    return
                }
                
            }else{
                self.paramDict["min_price"] = minPriceTxt.text
            }
        }else{
            if !(maxPriceTxt.text!.isEmpty) {
                self.paramDict["max_price"] = maxPriceTxt.text
            }
        }
        
        if !(selectedAnswer.isEmpty){
            self.paramDict["class_level"] = self.selectedAnswer
        }
        
        if !(minAgeTxt.text!.isEmpty) {
            if !(maxAgeTxt.text!.isEmpty) {
                
                if Int(minAgeTxt.text!)! < Int(maxAgeTxt.text!)! {
                    self.paramDict["min_age"] = minAgeTxt.text
                    self.paramDict["max_age"] = maxAgeTxt.text
                }else{
                    showAlert(message: "Max Age Should be Greater than Min Age")
                    return
                }
                
            }else{
                self.paramDict["min_age"] = minAgeTxt.text
            }
        }else{
            if !(maxAgeTxt.text!.isEmpty) {
                self.paramDict["max_age"] = maxAgeTxt.text
            }
        }
        
        if SFCBookingType == "0" || SFCBookingType == "1"{
            self.paramDict["sfc_booking_type"] = SFCBookingType
        }
        
        
        print("paramDict = \(paramDict)")
            
        
            self.view.StartLoading()
            
            
            ApiManager().postRequest(service: WebServices.LGW_FILTER, params: paramDict) { (result, success) in
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
                    
//                    ["error": There is no data., "code": 404]
                    

                    if let code : Int = resultDictionary["code"] as? Int {
                        print(code)
                        if code == 404 {
                            self.showAlert(message: resultDictionary["error"] as! String)
                        }else{
                            
                        }
                    }
                    else{
                        
//                        self.showAlertWithAction(message: self.transaction_id, selector:#selector(self.goToHome))
                        print(resultDictionary)
                      
                       /* let lessonsVc = self.storyboard?.instantiateViewController(withIdentifier: "LessionsListViewController") as! LessionsListViewController
                        
                        self.ArrFilterList = resultDictionary["data"] as! [AnyObject]

                        
                        lessonsVc.isfilter = true
                        lessonsVc.ArrLessionsList =  self.ArrFilterList */
                        
                        self.ArrFilterList = resultDictionary["data"] as! [AnyObject]
                        self.LLVC?.isfilter = true
                        self.LLVC?.ArrLessionsList = self.ArrFilterList
                        
                        self.navigationController?.popViewController(animated: false)
//                        self.navigationController.dismiss(animated: true, completion: nil)
                        
//                        lessonsVc.params = self.paramsDict
                        //self.present(lessonsVc, animated: true, completion: nil)

                        
                        
                    }
                    
                    
                    
                    //                    let changePwVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
                    //                    changePwVc.params = self.paramsDict
                    //                    self.present(changePwVc, animated: true, completion: nil)
                    
                    
                    
                }
                
            }
//        }
        
    }
    
    var selectedAnswer = String()

    
    @IBOutlet var optionOne: UIButton!
    
    @IBOutlet var optionTwo: UIButton!
    
    @IBOutlet var optionThree: UIButton!
    
    @IBOutlet var optionFour: UIButton!
    
    
    
    
    @IBAction func optionOneTapped(_ sender: Any) {
        
    
        optionOne.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        //selectedAnswer = "0"  // No need to send parameter...
        
     
    }
    
    @IBAction func optionTwoTapped(_ sender: Any) {
        
        optionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        selectedAnswer = "1"
        
        
        
        
    }
    
    @IBAction func optionThreeTapped(_ sender: Any) {
        
        optionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        selectedAnswer = "2"
    }
    
    @IBAction func optionFourTapped(_ sender: Any) {
        
        optionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        selectedAnswer = "3"
    }
  
    @IBOutlet var sfcOptionOne: UIButton!
    
    
    @IBOutlet var sfcOptionTwo: UIButton!
    
    @IBAction func sfcOptionOne(_ sender: Any) {
        
        sfcOptionOne.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        sfcOptionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
      
        SFCBookingType = "1"
    }
    
    
    @IBAction func sfcOptionTwo(_ sender: Any) {
        
        sfcOptionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        sfcOptionTwo.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
      
        SFCBookingType = "0"
    }
    
    
    
    
    func showAlert(message:String)
      {
          Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
      }
    
    
    
    @IBAction func back_Tapped(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
//        self.navigationController!.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
       @objc private func goToSearchPage() {
            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "LGWSearchVCSBID") as! LGWSearchVC
        searchVc.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(searchVc, animated: true)
    
        }

}
