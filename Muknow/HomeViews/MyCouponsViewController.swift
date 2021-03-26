//
//  MyCouponsViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyCouponsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var Access_Token : String = ""
    var Coupons_Arr = [AnyObject]()

    @IBOutlet var CouponTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

               self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
//        lefticonButton.addTarget(self, action: #selector(self.goBack), for: UIControl.Event.touchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        Access_Token = UserDefaults.standard.object(forKey: "access_token") as! String

        
         self.CouponTable.isHidden = true
        
        CouponTable.dataSource = self
        CouponTable.delegate = self
        CouponTable.separatorColor = .clear
        CouponTable.tableFooterView = UIView.init(frame: CGRect.zero)

        
        self.getMyCoupons()

        
    }
    
    func getMyCoupons() {
        
        
        let paramsDict = [
            "token":Access_Token
        ]
        
        
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.MY_COUPONS, params: paramsDict, completion:
            { (result, success) in
                
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
              
                    self.Coupons_Arr = (resultDictionary["data"] as? [AnyObject]) != nil  ?  (resultDictionary["data"] as! [AnyObject]) : []
                    
                    
                    if self.Coupons_Arr.count > 0 {
                        self.CouponTable.isHidden = false
                        self.CouponTable.reloadData()
                    }
                    
                   
                }
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.Coupons_Arr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
              
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponsTableViewCell") as? CouponsTableViewCell
        
        
        cell!.couponCodeTxt.text =  String(format: "Coupon : %@",self.Coupons_Arr[indexPath.row]["code"] as! String)

        cell!.couponDesc.text =  String(format: "Description : %@",self.Coupons_Arr[indexPath.row]["description"] as! String)

        let discounttype = self.Coupons_Arr[indexPath.row]["discount_type"] as! String
        if discounttype == "percent" {
       
            cell!.discountPercentage.text = "Discount percentage : \(self.Coupons_Arr[indexPath.row]["discount_amount"] as! String) %"
//            cell!.discountPercentage.text =  String(format: "Discount percentage : %@ %",self.Coupons_Arr[indexPath.row]["discount_amount"] as! String)
        }
        else
        {
            cell!.discountPercentage.text =  String(format: "Discount Amount : $ %@",self.Coupons_Arr[indexPath.row]["discount_amount"] as! String)
            }
        
        
        cell!.couponValidity.text =  String(format: "Validity : %@ to %@",(self.Coupons_Arr[indexPath.row]["valid_from"] as! String),(self.Coupons_Arr[indexPath.row]["valid_to"] as! String))

        
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //132
    }
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }

    @IBAction func back_vc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

        
    }
   
    
    

}
