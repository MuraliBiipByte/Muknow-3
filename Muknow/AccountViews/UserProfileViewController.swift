//
//  UserProfileViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    
    @IBOutlet weak var myLoader: UIActivityIndicatorView!
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var profileImgEditBtn: UIButton!
    @IBOutlet var userMobileNoLbl: UILabel!
    
    @IBOutlet var userEmail: UILabel!
    
    @IBOutlet var subscriptionStatus: UILabel!
    
    @IBOutlet var userNameLbl: UILabel!
    
    @IBOutlet var ReferLbl: UILabel!
    @IBOutlet var referralCode: UILabel!
    var userId : String?
    var username : String = ""
    var userEmailStr : String = ""
    var usernumber : String = ""
    var userDOB : String = ""
    var userImage : String = ""
    
    @IBOutlet var UserDataView: UIView!
    @IBAction func profileImgBtnTapped(_ sender: UIButton) {
     
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.openCamera()
                }))

                alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
                    self.openGallery()
                }))

                alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
    }
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery()
   {
       if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
           imagePicker.allowsEditing = true
           imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
           self.present(imagePicker, animated: true, completion: nil)
       }
       else
       {
           let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
   }
    //MARK:-- ImagePicker delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            let correctedImage = pickedImage.upOrientationImage()
            uploadImage(selectedImg: correctedImage!)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImage(selectedImg : UIImage){
     
        let accessToken = UserDefaults.standard.object(forKey: "access_token") as! String
        let paramsDict = ["token":accessToken] as [String:Any]

        print(paramsDict)
        self.view.StartLoading()
        ApiManager().uploadImageRequest(imageToUpload:selectedImg, service: WebServices.IMAGE_UPLOAD, params: paramsDict as [String : Any]) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
              //self.showAlert(message: result as! String )
                self.showAlert(message: "upload failed")
              return
            }
            else
            {
                print("Profile Update in Success Block....")
                self.showAlert(message: "Profile Image Uploaded")
                
                self.profileImgView.image = selectedImg
                self.profileImgView.contentMode = .scaleToFill
                
                
                
                if let data = selectedImg.pngData() {
                    let fileURL = self.getModuleIconFolderPath().appendingPathComponent("ProfileImage.png")
                    
                    do {
                        // Write to Disk
                        try data.write(to: fileURL)
                    } catch {
                        print("Unable to Write Data to Disk (\(error))")
                    }
                }
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setProfileImage()
    }
    
    fileprivate func setProfileImage() {
        
        self.myLoader.isHidden = true
        self.myLoader.stopAnimating()
        
        let iconFolderPath = self.getModuleIconFolderPath().path
        let imageURL = URL(fileURLWithPath: iconFolderPath).appendingPathComponent("ProfileImage.png")
        if FileManager.default.fileExists(atPath: imageURL.path){
            let image = UIImage(contentsOfFile: imageURL.path)
            if image != nil{
                self.profileImgView.image = image
                self.profileImgView.contentMode = .scaleToFill
            }
        }else{
            print("File Not Exists....")
            if UserDefaults.standard.value(forKey: "profile_image_URL_From_Login") != nil {

                let urlFromLogin = (UserDefaults.standard.value(forKey: "profile_image_URL_From_Login") as! String)

                self.myLoader.isHidden = false
                self.myLoader.startAnimating()
                self.profileImgView.sd_setImage(with: URL(string: urlFromLogin ), placeholderImage: UIImage(named: "PlaceholderImg"), options: .highPriority) { (img, err, cacheType, imageUrl) in
                 print("Image Downloaded by SD_WEB")
                    self.myLoader.isHidden = true
                    self.myLoader.stopAnimating()
                    
                }
                self.profileImgView.contentMode = .scaleToFill
                
            }
            
        }
    }
  
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profileImgView.image = UIImage(named: "NewProfile")

        profileImgView.layer.borderWidth = 1
        profileImgView.layer.masksToBounds = true
        profileImgView.layer.borderColor = UIColor.black.cgColor
        profileImgView.layer.cornerRadius = profileImgView.frame.size.width / 2
        profileImgView.clipsToBounds = true
        profileImgView.contentMode = .scaleToFill
        
        //profileImgEditBtn.isHidden = true
               self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        navigationItem.leftBarButtonItem = leftbarButton

        
               
                  userId = UserDefaults.standard.string(forKey: "user_id")
                
                  if userId == nil {
        //
        //              signOutBtn.setTitle("SignIn", for: .normal)
        //              self.showAlert(message: "Please login to Continue")
                  }
                  else{
                      username = UserDefaults.standard.object(forKey: "user_name") as! String
                      userEmailStr = UserDefaults.standard.object(forKey: "user_email") as! String
                    usernumber = UserDefaults.standard.object(forKey: "user_mobile") as! String
                    userDOB = UserDefaults.standard.object(forKey: "DOB") as! String
        
                      self.getUserData()
                  }
        
        UserDataView.isHidden = true
        self.userNameLbl.text = ""
        
        
    }
   
    
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
                    self.UserDataView.isHidden = true
                     self.userNameLbl.text = ""
                    self.showAlert(message: result as! String )
                      return
                  }
                  else
                  {
                    
                    self.UserDataView.isHidden = false
                    let resultDictionary = result as! [String : Any]
               
                    print(resultDictionary)
                    
                    let data = resultDictionary ["data"] as! [String:Any]
                    let UserData = data ["response"] as! [String:Any]
                    print(UserData)
                    let status = UserData["status"] as! String
                    
                    if status == "2" || status == "0" { //if status == "0" {
                        self.subscriptionStatus.text = "Non_Subscriber"
                        self.referralCode.text = ""
                        self.ReferLbl.isHidden = true
                    }else{
                        self.subscriptionStatus.text = "Subscriber"
                        self.referralCode.text = UserData["refferalcode"] as? String
                        if self.referralCode.text != "" {
                            self.ReferLbl.isHidden = false
                        }else{
                            self.ReferLbl.isHidden = true
                        }
                    }
                    
                    self.userEmail.text = self.userEmailStr
                    self.userNameLbl.text = self.username
                    self.userMobileNoLbl.text = self.usernumber
                  }
              }
        
    }

    
    @IBAction func edit_ProfileDetails(_ sender: Any) {
        
        let editVc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
       
        
        editVc.name = self.userNameLbl.text!
        editVc.number = self.userMobileNoLbl.text!
        editVc.dob = self.userDOB
        
        self.navigationController?.pushViewController(editVc, animated: true)

        
    }
    
    
    @IBAction func selectProfileImg(_ sender: Any) {
        
        
        
    }
    
    
    
    
    @IBAction func back_tapped(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func showAlert(message:String)
           {
               Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
           }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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

}

extension UserProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
}

