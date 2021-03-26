//
//  RegistrationViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate  {
    

    @IBOutlet var nameTxt: UITextField!
    @IBOutlet var emailTxt: UITextField!
    @IBOutlet var mobileTxt: UITextField!
    @IBOutlet var passwordTxt: UITextField!
    @IBOutlet var confirmPwTxt: UITextField!
    @IBOutlet var dobTxt: UITextField!
    @IBOutlet var btnTermsConditions: UIButton!
    var termsAccept = false
     var datePicker : UIDatePicker!
    
    var paramsDict = [String:Any]()
    
    var selectedDate : Date?
    
    @IBOutlet weak var termsOfServiceBtn: UIButton!
    let yourAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.systemFont(ofSize: 14),
    .foregroundColor: UIColor.blue,
    .underlineStyle: NSUnderlineStyle.single.rawValue]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btnTermsConditions.setImage(#imageLiteral(resourceName: "unCheck"), for:.normal)

        
        mobileTxt.keyboardType = .phonePad
        
        btnTermsConditions.setImage(UIImage(named: "unCheck"), for: .normal);
        self.dobTxt.delegate = self
        
        let attributeString = NSMutableAttributedString(string: "Terms of Service",
                                                        attributes: yourAttributes)
        termsOfServiceBtn.setAttributedTitle(attributeString, for: .normal)
    }
    
    @IBAction func create_NewAccount(_ sender: Any) {
        
        /*
        if self.nameTxt.text == "" {
            self.showAlert(message: "Enter Name")
        }
        else if self.emailTxt.text == "" {
                   self.showAlert(message: "Enter Email")
               }
        else if self.mobileTxt.text == "" {
            self.showAlert(message: "Enter Mobile Number")
        }
        else if self.passwordTxt.text == "" {
            self.showAlert(message: "Enter Password")
        }
        else if self.confirmPwTxt.text == "" {
            self.showAlert(message: "Re-Enter Password")
        }
        else if self.passwordTxt.text != self.confirmPwTxt.text {
                self.showAlert(message: "Password & Confirm Password are not matching.")
        }
            
        else if self.dobTxt.text == "" {
            self.showAlert(message: "Enter Date Of Birth")
        }
        
        else if termsAccept != true{
             self.showAlert(message: "Accept Terms & Conditions")
        } */
        
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
        
        if (nameTxt.text!.isEmpty) {
            self.showAlert(message: "Please Enter Name")
            return
        }
        
        if (nameTxt.text?.isValidInput())!{
            //Message.shared.Alert(Title: "Alert", Message: "Invalid Username. \n Username should be in between 4 to 15 Characters", TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
            self.showAlert(message: "Please Enter valid Name")
            return
        }
        if (emailTxt.text!.isEmpty){
            self.showAlert(message: "Please Enter Email")
            return
        }
        if !(emailTxt.text?.isValidEmail())! {
            self.showAlert(message: "Please Enter valid Email")
            return
        }
        if (mobileTxt.text!.isEmpty){
            self.showAlert(message: "Please Enter Mobile Number")
            return
        }
        if !(mobileTxt.text?.isValidMobileNumber())! {
            self.showAlert(message: "Please Enter valid Mobile Number")
            return
        }
        if (passwordTxt.text!.isEmpty){
            self.showAlert(message: "Please Enter Password")
            return
        }

        if (passwordTxt.text!.count < 6 ){
            self.showAlert(message: "The password must be at least 6 characters ")
            return
        }
        
        if (confirmPwTxt.text!.isEmpty){
            self.showAlert(message: "Please Re-Enter Password")
            return
        }
        if passwordTxt.text! != confirmPwTxt.text! {
            self.showAlert(message: "Password & Confirm Password are not matching.")
            return
        }
       
        
        
        
        
        
        if (termsAccept != true){
            self.showAlert(message: "Please Accept Terms & Conditions")
            return
        }
        // web service integration for sign up
        paramsDict = [
            "email":self.emailTxt.text!,
            "password":self.passwordTxt.text!,
            "full_name":self.nameTxt.text!,
            "mobile":self.mobileTxt.text!,
            "date_of_birth":self.dobTxt.text!
            
        ]
        
//        http://devservices.mu-know.com:8080/register?email=asdfgf99d.09@gmail.com&password=asdfghjgfdes&full_name=ABD&mobile=12345678&date_of_birth=1988-05-09
    
        
        
//        http://devservices.mu-know.com:8080/smiles_add_trainer_users?user_type=trainer&full_name=TrRaja&password=qwe123&confirm_password=qwe123&email_id=train1@yopmail.com&device_type=ios&device_token=1234567890&telcode=+65&phone=1234567890
        
        
        print("\(paramsDict)")
        
        self.view.StartLoading()
        
        
        ApiManager().postRequest(service: WebServices.REGISTRATION, params: paramsDict) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                let resultDictionary = result as! [String : Any]
                
                
                _ = User(userDictionay: resultDictionary)
                
                print(resultDictionary)
                // STORE THE USER INFORMATION
                
                let keyExists = resultDictionary["error"] != nil
                if keyExists{
                    DispatchQueue.main.async {
                        self.showAlert(message: "Email Already Registered")
                    }
                    
                }else{
                    let changePwVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
                    changePwVc.params = self.paramsDict
                    changePwVc.id = resultDictionary["id"] as? String
                    self.present(changePwVc, animated: true, completion: nil)
                }

                /*
                UserDefaults.standard.set(resultDictionary["id"], forKey: "user_id")
                UserDefaults.standard.set(resultDictionary["full_name"], forKey: "user_name")
                
                UserDefaults.standard.set(resultDictionary["email"], forKey: "user_email")
                
                let changePwVc = self.storyboard?.instantiateViewController(withIdentifier: "RegisterOTPViewController") as! RegisterOTPViewController
                changePwVc.params = self.paramsDict
                changePwVc.id = resultDictionary["id"] as? String
                self.present(changePwVc, animated: true, completion: nil)*/
                
                
                
            }
            
        }
        

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
    
    
    
    @objc func myAccount()
    {
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Nav") as! UINavigationController
        
//        UITabBar.appearance().tintColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
//        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
        
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func agreeTerms_Conditions_Tapped(_ sender: Any) {
        
        if termsAccept
        {
            termsAccept = false
            btnTermsConditions.setImage(#imageLiteral(resourceName: "unCheck"), for:.normal)
        }
        else
        {
            termsAccept = true
            btnTermsConditions.setImage(#imageLiteral(resourceName: "check"), for:.normal)
        }
    }

    @IBAction func back_vc(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }

    func showAlert(message:String)
      {
          Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
      }
    
      func showAlertWithAction(message:String)
      {
          Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(myAccount), Controller: self)], Controller: self)
      }
    
    @IBAction func termsOfServiceBtnTapped(_ sender: UIButton) {
        /* if let url = URL(string: "http://54.255.115.196/sharent_new/index.php/welcome/terms_conditions") {
            UIApplication.shared.open(url)
        }*/
    }
    
}
