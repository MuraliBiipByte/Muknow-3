//
//  EditProfileViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController,UITextFieldDelegate{

    
    @IBOutlet var nameTxt: UITextField!
    
    @IBOutlet var mobileNoTxt: UITextField!
    
    @IBOutlet var dobTxt: UITextField!
    
    var datePicker : UIDatePicker!
    var AccessToken : String = ""

    var name = String()
    var number = String()
    var dob = String()
    
    var Device_Id : String = ""
    
    var selectedDate : Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton
        
        self.nameTxt.delegate = self
        self.mobileNoTxt.delegate = self
        self.dobTxt.delegate = self
        
        self.nameTxt.text = name
        self.mobileNoTxt.text = number
        self.dobTxt.text = dob
        
        userId = UserDefaults.standard.string(forKey: "user_id")!

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTxt.resignFirstResponder()
        self.mobileNoTxt.resignFirstResponder()
        self.dobTxt.resignFirstResponder()
        return true
        
    }

    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 400, width: self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
     self.datePicker.datePickerMode = UIDatePicker.Mode.date
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
       
       @objc func doneClick() {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
            selectedDate = datePicker.date
           dobTxt.text = formatter.string(from: datePicker.date)
           self.view.endEditing(true)
       }
       
       @objc func cancelClick() {
           
           self.view.endEditing(true)
           dobTxt.text = ""
           dobTxt.resignFirstResponder()
           
       }
       
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
          if textField == self.dobTxt {
              self.pickUpDate(self.dobTxt)
        }
        
    }
    
    var userId :String = ""

    @IBAction func submitEditedDetails_Tapped(_ sender: Any) {
        
        
        if (nameTxt.text!.isEmpty) {
            self.showAlert(message: "Please Enter Name")
            return
        }
        
        if (nameTxt.text?.isValidInput())!{
            //Message.shared.Alert(Title: "Alert", Message: "Invalid Username. \n Username should be in between 4 to 15 Characters", TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
            self.showAlert(message: "Please Enter valid Name")
            return
        }
        if (mobileNoTxt.text!.isEmpty){
            self.showAlert(message: "Please Enter Mobile Number")
            return
        }
        if !(mobileNoTxt.text?.isValidMobileNumber())! {
            self.showAlert(message: "Please Enter valid Mobile Number")
            return
        }
        
//        else if self.dobTxt.text == "" {
//            self.showAlert(message: "Enter Date of Birth")
//        }
        
        if (dobTxt.text!.isEmpty){
            self.showAlert(message: "Please Enter Date of Birth")
            return
        }
        
        if (selectedDate != nil) {
            let today = Date()
            if selectedDate! < today {
                print("selected date is smaller than today")
            }else{
                print("selected date is greater than today")
                self.showAlert(message: "Please Enter valid Date of Birth")
                return
            }
        }
       
        //else{
            
            self.AccessToken = UserDefaults.standard.object(forKey: "access_token") as! String

            let paramsDict = [
                "token": self.AccessToken,
                "full_name":self.nameTxt.text!,
                "mobile":self.mobileNoTxt.text!,
                "date_of_birth":self.dobTxt.text!
            ]
            
            print("\(paramsDict)")
            
            self.view.StartLoading()
//            http://devservices.mu-know.com:8080/auth/profile?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOlwvXC9tdWtub3dzZXJ2aWNlcy5jby5pblwvYXV0aFwvbG9naW4iLCJpYXQiOjE1ODg4NDI1NzMsImV4cCI6MTU4ODg0NjE3MywibmJmIjoxNTg4ODQyNTczLCJqdGkiOiJybzVKcVM5VVZGUG1jQzMyIiwic3ViIjoyNjA2NiwicHJ2IjoiOGI0MjJlNmY2NTc5MzJiOGFlYmNiMWJmMWUzNTZkZDc2YTM2NWJmMiJ9.2i3e-KjXClSDl3V27D56yFzj8mqAlwTX7fFBe9zRiwo&full_name=Abdulla Nofal tan&mobile=9742025841&date_of_birth=1988-09-05
            

            ApiManager().postRequest(service: WebServices.PROFILE_UPDATE, params: paramsDict) { (result, success) in
                self.view.StopLoading()
                if success == false
                {
                    self.showAlert(message: result as! String)
                    return
                    
                }
                else
                {
                    let resultDictionary = result as! [String : Any]
                    
                    //self.showAlert(message: "Profile Updated Successfully")
                    self.addUsersApi()

//                    let changePwVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
//                    changePwVc.params = self.paramsDict
//                    changePwVc.id = resultDictionary["id"] as? String
//                    self.present(changePwVc, animated: true, completion: nil)
                    
                    
                    
                }
                
            }
            
       // }
       
        
        
    }
    
    func addUsersApi() {
            

//        device_token=null&user_id=1&email_id=ram@gmail.com (http://user_id=1&email_id=ram@gmail.com/)&full_name=Ram K&display_name=Ram&mobile_num=1234567897&device_type=ios

        self.Device_Id = UserDefaults.standard.object(forKey: "fcm_Token") as? String ?? ""
              print(self.Device_Id)
        
            
                    let paramsDict = [
                        "device_token" : Device_Id,
                        "user_id":"\(userId)",
                        "email_id": UserDefaults.standard.value(forKey: "user_email") as! String,//UserDefaults.standard.set(self.userEmail, forKey: "user_email"),
                        "full_name":self.nameTxt.text!,//userName,
                        "mobile_num":self.mobileNoTxt.text!,
                        "display_name":self.nameTxt.text!,
                        "device_type":"ios"

                        ] as [String : Any]
                  
        print(paramsDict)
                self.view.StartLoading()
                    
            ApiManager().postRequest(service: WebServices.SMILES_ADD_USER, params: paramsDict, completion:
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
                    
                    
                    UserDefaults.standard.set(self.mobileNoTxt.text!, forKey: "user_mobile")
                    UserDefaults.standard.set(self.nameTxt.text!, forKey: "user_name")
                    //let dob = tmp_resultDict.value(forKey: "date_of_birth") is NSNull ? "" : tmp_resultDict.value(forKey: "date_of_birth") as! String
                    UserDefaults.standard.set(self.dobTxt.text!, forKey: "DOB")
                    
                    
                   // self.showAlertWithAction(message: "Profile Updated Successfully")
                    print("Profile Updated Successfully")
                    self.showAlertWithAction(message: "Profile Updated Successfully")
                    
                    
                }
            })
        }
    
    @IBAction func back_tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    /*
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToMyAccountVC), Controller: self)], Controller: self)
    }
    
    @objc func goToMyAccountVC()
         {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: MyAccountViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
         } */
    
    func showAlertWithAction(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToMyAccountVC), Controller: self)], Controller: self)
    }
    
    @objc func goToMyAccountVC()
         {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: MyAccountViewController.self) {
                    self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
         }

}
