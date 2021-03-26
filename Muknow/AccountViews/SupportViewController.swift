//
//  SupportViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class SupportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var supportTableHeight: NSLayoutConstraint!
    @IBOutlet var SupportTable: UITableView!
    var helpAttributes = [String]()
    var userId : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()

               self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        userId = UserDefaults.standard.string(forKey: "user_id")

        helpAttributes = ["Abount MuKnow","Email us","FAQ","Share"]
        SupportTable.delegate = self
        SupportTable.dataSource = self

        self.getUserData()
    }
    
    var ReferCode : String = ""

        func getUserData() {
            
            let paramsDict = [
                "lgw_user_id":self.userId!]

            print(paramsDict)
            self.view.StartLoading()
            ApiManager().postRequest(service:WebServices.PROFILE_DETAILS, params: paramsDict as [String : Any])
                  { (result, success) in
                      self.view.StopLoading()

                      if success == false
                      {
                        self.ReferCode = ""
//                        self.UserDataView.isHidden = true
//                         self.userNameLbl.text = ""
//                        self.showAlert(message: result as! String )
                          return
                      }
                      else
                      {
                        
                      
                        let resultDictionary = result as! [String : Any]
                   
                        print(resultDictionary)
                        
                        let data = resultDictionary ["data"] as! [String:Any]
                        let UserData = data ["response"] as! [String:Any]
                        print(UserData)
                        let status = UserData["status"] as! String
                        
                        if status == "0" {
                          
                            self.ReferCode = ""

                        }else{
                                                      
                            self.ReferCode = (UserData["refferalcode"] as? String)!
 

                            
                        }
                        
    //                    self.userMobileNoLbl.text =
                      }

                  }
            
        }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return helpAttributes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let helpCell = tableView.dequeueReusableCell(withIdentifier: "HelpTableViewCell") as! HelpTableViewCell
        helpCell.lblHelpAttribute.text = "\(helpAttributes[indexPath.row])"
        helpCell.accessoryType = .disclosureIndicator
        
        supportTableHeight.constant = SupportTable.contentSize.height
        supportTableHeight.isActive = true
        
        return helpCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if indexPath.row == 1 {
            let emailVc = self.storyboard?.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
            //            contactVc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(emailVc, animated: true)
            
        }
        else if indexPath.row == 3 {
            
            let activityVC = UIActivityViewController(activityItems: ["Join me on MuKnow App.Enter my code \(self.ReferCode) to earn cashback"], applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
            
        }
        
//        switch indexPath.row
//        {
//        case 1:
//            let emailVc = self.storyboard?.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
////            contactVc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(emailVc, animated: true)
//        default:
//
//              let contactVc = self.storyboard?.instantiateViewController(withIdentifier: "EmailViewController") as! EmailViewController
//             self.navigationController?.pushViewController(contactVc, animated: true)
//
////            let privacyVc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewController") as! PrivacyPolicyViewController
////            privacyVc.title = "\(helpAttributes[indexPath.row].uppercased())"
////            privacyVc.urlIndex = indexPath.row
////            self.navigationController?.pushViewController(privacyVc, animated: true)
//        }
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)

    }
    

}
