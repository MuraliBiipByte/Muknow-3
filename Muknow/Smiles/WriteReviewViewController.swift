//
//  WriteReviewViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class WriteReviewViewController: UIViewController,FloatRatingViewDelegate,UITextViewDelegate {

    @IBOutlet weak var ratingView: FloatRatingView!

    @IBOutlet var txtComment: UITextView!
    var articleId :Int?
    var userId : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        
        navigationItem.leftBarButtonItem = leftbarButton
        
        
        userId = UserDefaults.standard.string(forKey: "user_id")!

        
        ratingView.delegate = self
        ratingView.contentMode = UIView.ContentMode.scaleAspectFit
        txtComment.placeholder = "Write your comment."
        txtComment.delegate = self
        
        ratingView.editable = true
        ratingView.rating = 5
    }
   
     /* Updated for Swift 4 */
       func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               txtComment.resignFirstResponder()
               return false
           }
           return true
       }

       /* Older versions of Swift */
       func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
           if(text == "\n") {
               txtComment.resignFirstResponder()
               return false
           }
           return true
       }
    

    @IBAction func submit_Review(_ sender: Any) {
            
           self.view.endEditing(true)
              
              if self.ratingView.rating == 0.0
              {
                  self.showAlert(message: "Please Choose Rating")
                  return
              }
              if (txtComment.text?.isEmpty)! || txtComment.text == ""
              {
                  self.showAlert(message: "Please enter your comment")
                  return
              }
              
        let paramsDic = ["lgw_user_id":userId,"article_id":articleId!,"rate":self.ratingView.rating,"comment":txtComment.text!] as [String:Any]
    
        print(paramsDic)
              self.view.StartLoading()
              ApiManager().postRequest(service: WebServices.ARTICLES_REVIEWS, params: paramsDic)
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
                    
                    self.showAlertWithAction(message: "Review inserted successfully.", selector: #selector(self.moveToArticlesDetailsPage))
                     
                  }
              }
       }
    
    @objc func moveToArticlesDetailsPage()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showAlertWithAction(message:String,selector:Selector)
      {
          Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:selector, Controller: self)], Controller: self)
      }
      
    
    
    @IBAction func back_vc(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
      func showAlert(message:String)
           {
               Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
           }

    
}
