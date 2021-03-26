//
//  ViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate {

    // launch screen image should adjust with width.
    
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPassword: UITextField!
    
    var userId : Int?
    var userName : String = ""
    var userEmail : String = ""
    var userDisplayName : String = ""
    var userMobileNo : String = ""
    var userImage : String = ""
    
    var Device_Id : String = ""
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
      
      
        
        txtEmail.delegate = self
        txtPassword.delegate = self
    }

    @IBAction func forgotPassword_Tapped(_ sender: Any) {
        let forgotVc = self.storyboard?.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        self.present(forgotVc, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtEmail.resignFirstResponder()
        txtPassword.resignFirstResponder()
        return true
    }
     
    @IBAction func login_Tapped(_ sender: Any) {
        
        
        /*
        if self.txtEmail.text == "" {
            self.showAlert(message: "Enter Email")
        }
        else if self.txtPassword.text == "" {
            self.showAlert(message: "Enter Password")
        } */
        
        
//         userId = UserDefaults.standard.string(forKey: "user_id")
        
        
//        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "Nav") as! UINavigationController
//
//        UITabBar.appearance().tintColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
//        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
//
//        self.present(nextViewController, animated: true, completion: nil)
        
        
        
        
        if self.txtEmail.text == "" {
            self.showAlert(message: "Enter Email")
            return
        }
        

        if !(txtEmail.text?.isValidEmail())! {
                self.showAlert(message: "Please Enter valid Email")
                return
        }
                
        else if self.txtPassword.text == "" {
            self.showAlert(message: "Enter Password")
            return
        }
        
        
        let paramsDict = [
            "email":self.txtEmail.text!,
            "password":self.txtPassword.text!]

        
          
        
           print("\(paramsDict)")

        self.view.StartLoading()
        ApiManager().postRequestToGetAccessToken(service:WebServices.APP_ACCESS_TOKEN, params: paramsDict)
              { (result, success) in
                  self.view.StopLoading()

                  if success == false
                  {
                    self.showAlert(message: result as! String )
                      return
                  }
            else
            {
              let resultDictionary = result as! [String : Any]
               print("\(resultDictionary)")
              
              let keyExists = resultDictionary["error"] != nil
              if keyExists{
                  DispatchQueue.main.async {
                      self.showAlert(message: "The email must be a valid email address")
                  }
              }else{
                  let access_token = resultDictionary["access_token"] as! String
                  
                    UserDefaults.standard.set(access_token, forKey: "access_token")
                    UserDefaults.standard.set(self.txtPassword.text!, forKey: "user_password")
                        
                    self.getUserDetails()
              }
              

            }
            
            
              }

    }
    
    var Access_Token : String = ""
    
    func getUserDetails() {
        
     Access_Token = UserDefaults.standard.object(forKey: "access_token") as! String
        
                let paramsDict = [
                    "token":Access_Token
                ]
                
        print(paramsDict)
            self.view.StartLoading()
                
        ApiManager().getRequestWithParameters(service: WebServices.APP_AUTHENDICATION, params: paramsDict, completion:
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
               
                
                _ = User(userDictionay: resultDictionary)
                
               
                // STORE THE USER INFORMATION
                
                self.userId = resultDictionary["id"] as? Int
                self.userMobileNo  = resultDictionary["mobile"] as! String
               
                
                self.userName = resultDictionary["full_name"] as! String
                self.userEmail = resultDictionary["email"] as! String
                self.userDisplayName = resultDictionary["display_name"] as? String ?? ""
                
                
                self.userImage = resultDictionary["user_image"] as? String ?? ""
                if self.userImage != "" {
                    let profileImageUrl = "\(WebServices.BASE_URL_SERVICE)image/\(self.userImage)"
                    UserDefaults.standard.setValue(profileImageUrl, forKey: "profile_image_URL_From_Login")
                    self.writeFileToModuleDirectory(fURL: profileImageUrl)
                }
                /*else{
                    SESSION.setIsProfielImgDownloading(isDownloading: false)
                } */
                
                

                
                self.addUsersApi()
                

                UserDefaults.standard.set(self.userId, forKey: "user_id")
                UserDefaults.standard.set(self.userName, forKey: "user_name")
                
                
                let tmp_resultDict = result as! NSDictionary
                let dob = tmp_resultDict.value(forKey: "date_of_birth") is NSNull ? "" : tmp_resultDict.value(forKey: "date_of_birth") as! String
                
                UserDefaults.standard.set(dob, forKey: "DOB")
//                UserDefaults.standard.set(resultDictionary["date_of_birth"] as! String, forKey: "DOB")


                 UserDefaults.standard.set(self.userEmail, forKey: "user_email")
                UserDefaults.standard.set(self.userMobileNo, forKey: "user_mobile")

                UserDefaults.standard.set(self.Access_Token, forKey: "access_token")
                
                

                
               // ["display_name": <null>, "uuid": 35a9cd1b-cfba-4577-b92b-8dd160d3f5d9, "update_time": <null>, "is_auth_enabled": 0, "is_subscribed": 0, "full_name": iostesttw, "id": 27302, "is_mobile": 1, "token": <null>, "mobile": 7204149460, "mobile_verified": 0, "gender": <null>, "email_verified": 0, "token_sent_time": <null>, "create_time": 2020-10-28 11:57:01, "google_auth_code": <null>, "date_of_birth": 2018-10-28, "user_image": 533012669.jpeg, "image_path": <null>, "email": iostest2@yopmail.com]
                
                
//                let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController
////                UITabBar.appearance().tintColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
////                UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
//                self.present(nextViewController, animated: true, completion: nil)
                
            }
        })
    }
    
    func writeFileToModuleDirectory(fURL : String) {
        
//        SESSION.setIsProfielImgDownloading(isDownloading: true)
//        SESSION.setIsProfileImgDownloaded(isDownloaded: false)
        
        let fileName = "ProfileImage.png"
        //let url = fURL
        
        let theURL = URL.init(string: fURL)
        let folderName =  self.getModuleIconFolderPath() //COMMONFUNCTION.getModuleFolderPathSync(ModuleName: moduleName)
        let destinationUrl = folderName.appendingPathComponent(fileName)
        
        let defaultSessionConfiguration = URLSessionConfiguration.default
        defaultSessionConfiguration.timeoutIntervalForRequest = 600000
        defaultSessionConfiguration.timeoutIntervalForResource = 600000
        defaultSessionConfiguration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        defaultSessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let defaultSession = URLSession(configuration: defaultSessionConfiguration)
        
        let request = URLRequest(url: theURL!)
        
        let task = defaultSession.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode) , \(fileName) downloaded...")
                }
                
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: destinationUrl)
//                    SESSION.setIsProfileImgDownloaded(isDownloaded: true)
//                    SESSION.setIsProfielImgDownloading(isDownloading: false)
                    
                    //                    completion()
                } catch (let writeError) {
                    print("error writing file \(destinationUrl) : \(writeError)")
//                    SESSION.setIsProfileImgDownloaded(isDownloaded: false)
//                    SESSION.setIsProfielImgDownloading(isDownloading: false)
                }
                
            } else {
                print("Failure:  \(fileName) Not downloaded...URL= \(fURL)")
//                SESSION.setIsProfielImgDownloading(isDownloading: false)
            }
        }
        task.resume()
    }
    
    //MARK:ModuleIconFolder Path
    func getModuleIconFolderPath()->URL
    {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[urls.count - 1] as URL
        let folderPath = documentsDirectory.appendingPathComponent("ModuleIcons")
        
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: folderPath.path)
        {
            //NSLog("ModuleIcons Folder Exists")
            print("ModuleIcons Folder Exists")
        }
        else
        {
            do {
                try fileManager.createDirectory(atPath: folderPath.path, withIntermediateDirectories: false, attributes: nil)
            } catch _ as NSError {
                //print(error.localizedDescription);
            }
        }
        
        return folderPath
    }
    func addUsersApi() {
            

//        device_token=null&user_id=1&email_id=ram@gmail.com (http://user_id=1&email_id=ram@gmail.com/)&full_name=Ram K&display_name=Ram&mobile_num=1234567897&device_type=ios

        self.Device_Id = UserDefaults.standard.object(forKey: "fcm_Token") as? String ?? ""
              print(self.Device_Id)
        
            
                    let paramsDict = [
                        "device_token" : Device_Id,
                        "user_id":"\(userId!)",
                        "email_id":userEmail,
                        "full_name":userName,
                        "mobile_num":userMobileNo,
                        "display_name":userDisplayName,
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
                    
                    let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "theNavigationVCSBID") as! UINavigationController
                    self.present(nextViewController, animated: true, completion: nil)
                    
                }
            })
        }
    
    
    @IBAction func skip_Tapped(_ sender: Any) {
        let HomeViewController = self.storyboard?.instantiateViewController(withIdentifier: "theNavigationVCSBID") as! UINavigationController
        self.present(HomeViewController, animated: true, completion: nil)
    }
    
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
}

