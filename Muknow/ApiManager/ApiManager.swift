//
//  ApiManager.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import Alamofire


struct WebServices {
 
    //Test
    /* IP Address has been changed */
//    static let BASE_URL_SERVICE = "http://devservices.mu-know.com:8080/"
//    static let BASE_URL = "https://lessonsgowhere.com.sg/"
    
    /*
    static let BASE_URL_SERVICE = "http://stgservices.mu-know.com/"
    static let BASE_URL = "http://beta.lessonsgowhere.com.sg/"
    static let ARTICLE_BASE_URL = "http://stgadmin.mu-know.com/admin/" */
    
    
    
   // http://devservices.mu-know.com:8080/auth/upload
      
    
    
    //dev
   static let BASE_URL_SERVICE = "http://devservices.mu-know.com/"
    static let BASE_URL = "https://lessonsgowhere.com.sg/"
    static let ARTICLE_BASE_URL = "http://devadmin.mu-know.com/"
    
    /* static let BASE_URL_SERVICE = "http://devservices.mu-know.com/";
    static let BASE_URL = "https://lessonsgowhere.com.sg/";
    static let ARTICLE_BASE_URL = "http://devadmin.mu-know.com:8082/"; */
    
    /* //Beta
    static let BASE_URL_SERVICE = "http://stgservices.mu-know.com/"
    static let BASE_URL = "http://stgadmin.mu-know.com/admin/";
    static let ARTICLE_BASE_URL = "http://beta.lessonsgowhere.com.sg/"; */
    
    //Staging
   /* static let BASE_URL_SERVICE = "http://stgservices.mu-know.com/"
    static let BASE_URL = "http://stg.lessonsgowhere.com.sg/"
    static let ARTICLE_BASE_URL = "http://stgadmin.mu-know.com/" */
    
    
//    public static final String REST_URL_DOMAIN = "http://stgservices.mu-know.com/";
//        public static final String REST_URL_DOMAIN_IMAGE = "http://stg.lessonsgowhere.com.sg/";
//        public static final String REST_URL_DOMAIN_SMILES_FILES = "http://stgadmin.mu-know.com/";

//    //Live
//    //    static let BASE_URL_SERVICE = "https://muknow.com.sg/index.php/"
//    //    static let BASE_URL = "https://muknow.com.sg/"
//   static let APP_VERSION = "register_user/get_app_version"
    
    static let APP_ACCESS_TOKEN = "auth/login"
    static let IMAGE_UPLOAD = "auth/upload"
    static let FORGET_PWD = "password/reset"
    static let FORGET_PWD_OTP = "password/resetMobileOTPValidate"
//    static let CHANGE_PWD = "resetSuccessful"
    static let CHANGE_PWD = "password/resetSuccessful"
    static let OTP_SUCCESS = "registerSuccessful"
    static let SMILES_ADD_USER = "smiles_add_users"
    
    static let APP_AUTHENDICATION = "auth/me"
    static let HOME_COURSES = "home"
    static let LESSIONS = "lesson"
    
    static let REGISTRATION = "register"
    static let CATEGORIES = "category"
    static let SMILES_CATEGORIES = "smilescategory"
    static let COURSES_HISTORY = "myhistory"

    static let SMILES_ARTICLES = "smiles_all_articles_list"
    static let SMILES_ARTICLES_DETAILS = "smiles_article_details"
    static let SMILES_ADD_ARTICLE_VIEWS = "smiles_add_article_views"
    static let SESSIONS = "getsessions"
    static let LGW_SEARCH = "search"
    static let SMILES_SEARCH = "smiles_search_articles"
    
    // With login
    static let LESSIONS_LOGIN = "auth/lesson"
    static let HOME_LOGIN = "auth/home"
    static let LOGOUT = "auth/logout"
    static let  WISHLIST_LOGIN = "auth/roi"
    static let  ADD_WISHLIST_LOGIN = "auth/roi/create"
    static let  NOTIFY_WISHLIST_LOGIN = "auth/roi/notify"
    static let  INTEREST = "auth/roi/interest" 
    static let  REMOVE_WISHLIST_LOGIN = "auth/roi/delete"
    static let  SMILES_FAVOURITE = "smiles_add_fauourite_article"
    static let  SMILES_UNFAVOURITE = "smiles_removed_fauourite_article"
    static let  FAVOURITE_ARTICLES = "smiles_all_favorite_articles"
    static let  ARTICLES_REVIEWS = "smiles_add_article_reviews"
    static let ALL_REVIEWS = "smiles_get_article_reviews"

    static let  SUBSCRIPTION_LIST = "smiles_subscription_view_details"
    static let  LGW_COUPON = "coupon"
    static let  PROFILE_DETAILS = "smiles_payment_subscription_user_check"
//   static let  PROFILE_UPDATE = "profile"
    static let  PROFILE_UPDATE = "auth/profile"
    static let  MY_COUPONS = "mycoupon"

    
    static let  LGW_STRITPE_PAYMENT = "actionCheckout"
    static let  LGW_FILTER = "search/advance"
    static let  STRITPE_REGISTER_USER = "smiles_create_customer_account_strip"
    static let  STRITPE_UPDATE_USER = "smiles_test_update_account_strip"
    static let  STRITPE_CHECK_USER = "smiles_stripe_payment_register_user_check"
    static let  STRITPE_PAYMENT = "smiles_stripe_payment_checkout"
    static let  CHECK_REFERRAL_CODE = "smiles_stripe_payment_subscribed_user_referralcode"
    
    
    
    static let  TRANSACTION_HISTORY = "smiles_stripe_payment_customer_transaction_history"
    
    static let  REFERRAL_HISTORY = "smiles_stripe_payment_get_cash_back_transactions"

    static let  NOTIFICATION_HISTORY = "smiles_recieved_notification_messages"
   
    static let  NOTIFICATION_UPDATE = "smiles_add_status_for_send_notification_fcm"
    static let EMAIL_NOTIFICATION_UPDATE = "smiles_add_status_for_send_notification_email"

    static let  EMAUL_US = "smiles_add_contactus_data"


    
//    http://devservices.mu-know.com:8080/category/1
    // API_KEY should replace with New Key
//  static let API_KEY = "tz6n5M+lnJVw007muIr7UXATrR4quD9V4Z+upTXcDXWzD7LE1eZaHdcyBe/Z3TjChzPdgS5dKvVIQm6gq6HVuw=="
   
}


class ApiManager {
 
    
    func uploadImageRequest(imageToUpload:UIImage,service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
    {
        let urlString = WebServices.BASE_URL_SERVICE + service
        let serviceUrl = URL(string: urlString)
        print(serviceUrl!)
        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
        {
            completion("The Internet connection appears to be offline.",false)
            return
        }
    
        let headers: HTTPHeaders = [
              /* "Authorization": "your_access_token",  in case you need authorization header */
              "Content-type": "multipart/form-data"
          ]
        AF.upload(
                  multipartFormData: { multipartFormData in
                    for (key, value) in params {
                           multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                       }
                    if let imageData = imageToUpload.jpegData(compressionQuality: 1) {
                      multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
                    }
              }
        ,
                  to: serviceUrl!, method: .post , headers: headers)
                  .response { resp in
                      print("REsponse from Image Upload is : ",resp)
//                    print("RESult from Image Upload is : ",Result)
                    
                    
                    switch resp.result {
                    case .failure(let error):
                        print("FAil....",error)
                        completion(resp,false)
                    case .success( _):
                        print("sucess ---",resp.result)
                        completion(resp,true)
                    }
                    
              }
        
       /* AF.upload(
                  multipartFormData: { multipartFormData in
                    for (key, value) in params {
                           multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                       }
                    if let imageData = imageToUpload.jpegData(compressionQuality: 1) {
                      multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
                    }
              }
        ,
            to: serviceUrl!, method: .post , headers: headers).responseJSON { (data) in
                print("REsponse from Image Upload is : ",data)
//                    print("RESult from Image Upload is : ",Result)
                
              completion(data,true)
            } */
        
        
        
        
        
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//            for (key, value) in params {
//                   multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//               }
//            if let imageData = imageToUpload.jpegData(compressionQuality: 1) {
//              multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
//            }
//
//        }, usingThreshold: UInt64.init(), to: serviceUrl!, method: .post, headers: headers) { (result) in
//            switch result{
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print("Succesfully uploaded")
//                    if let err = response.error{
//                        onError?(err)
//                        return
//                    }
//                    onCompletion?(nil)
//                }
//            case .failure(let error):
//                print("Error in upload: \(error.localizedDescription)")
//                onError?(error)
//            }
//        }
        
//        AF.upload(multipartFormData: { (multipart: MultipartFormData) in
//            for (key, value) in params {
//                   multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
//               }
//            if let imageData = imageToUpload.jpegData(compressionQuality: 1) {
//              multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType: "image/png")
//            }
//            },usingThreshold: UInt64.init(),
//               to: serviceUrl!,
//               method: .post,
//               headers: headers,
//               encodingCompletion: { (result) in
//                switch result {
//                case .success(let upload, _, _):
//                    upload.uploadProgress(closure: { (progress) in
//                      print("Uploading")
//                    })
//                    break
//                case .failure(let encodingError):
//                    print("err is \(encodingError)")
//                        break
//                    }
//                })
                  
                  
        
        
        
        
        
        
        
        
        
        /* if let data = data,
            let urlContent = NSString(data: data, encoding: String.Encoding.ascii.rawValue) {
            print(urlContent)
        } else {
            print("Error: \(error)")
        }*/
    }
    
   
    
    
    func postRequest(service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
    {
        let urlString = WebServices.BASE_URL_SERVICE + service
        let serviceUrl = URL(string: urlString)
        print("Service URL = ",serviceUrl!)
        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
        {
            completion("The Internet connection appears to be offline.",false)
            return
        }
       
        
        AF.request(serviceUrl!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
            {(response:DataResponse) in
                
                switch response.result
                {
               case .success(let data):
                   // print(response.result)
//                    print(response.result.value as! NSDictionary)
                    
                     let jsonResponse = data as! [String : Any]
                    print(jsonResponse)
                    
//                    let access_token = jsonResponse["access_token"] as! String
//                    print(access_token)
                    
                  
                    
//                    print(response.result.value as! [String : Any])
//                    let jsonResponse = response.result.value as! [String : Any]
//                    let response = jsonResponse["response"] as! [String:Any]
//
//                    let status = "\(String(describing: response["status"]!))"
//                  switch Int(status)
                    
//                    let status = "1"
//                    let message = "message"
////                    switch Int(status)
//                    switch 1
//                    {
//                    case 0:
//                        completion(message,false)
//                        break
//                    case 1:
                        completion(jsonResponse,true)
//                        break
//                    default:
//                        print(1)
//                    }
//                    break
                case .failure(let error):
                    
                    completion(error.localizedDescription,false)
                    break
                }
        }
    }
    
    
    
    func postRequestToGetAccessToken(service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
        {
            let urlString = WebServices.BASE_URL_SERVICE + service
            let serviceUrl = URL(string: urlString)
            print(serviceUrl!)
            if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
            {
                completion("The Internet connection appears to be offline.",false)
                return
            }
            
            AF.request(serviceUrl!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
                {(response:DataResponse) in
                    
                    switch response.result
                    {
                    case .success(let data):
                        
                        
//                        print(data)
                      
                        if let dataArr: NSArray = data as? NSArray {
                           
                            completion("User Not Found",false)

                        }
//                        print(response.result)
//
//
//                            print(response.result.value)
//
                        else{
                        let jsonResponse = data as! [String : Any]
                        print(jsonResponse)
//
////                        let access_token = jsonResponse["access_token"] as! String
////                        print(access_token)
////
                          completion(jsonResponse,true)
                        
//                         completion(jsonResponse,true)
//
                     
                        break
                        }
                    case .failure(let error):
                        
                        completion(error.localizedDescription,false)
                        break
                    }
            }
        }
    
    
    
    func getRequest(service:String, completion: @escaping (_ result:Any,_ success:Bool) -> ())
        {
            let urlString = WebServices.BASE_URL_SERVICE + service
            let serviceUrl = URL(string: urlString)
          print("service url is = ",serviceUrl!)
            if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
            {
                completion("The Internet connection appears to be offline.",false)
                return
            }
            
            AF.request(serviceUrl!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON
                {(response:DataResponse) in
                    
                    switch response.result
                    {
                     case .success(let data):
                        print(response.result)
                        
                         let jsonResponse = data as! [String : Any]
                        print(jsonResponse)
                       
                         completion(jsonResponse,true)
                        
                        
    //                    print(response.result.value as! [String : Any])
    //                    let jsonResponse = response.result.value as! [String : Any]
    //                    let response = jsonResponse["response"] as! [String:Any]
    //
    //                    let status = "\(String(describing: response["status"]!))"
    //                  switch Int(status)
                        
    //                    let status = "1"
//                        let message = "message"
//    //                    switch Int(status)
//                        switch 1
//                        {
//                        case 0:
//                            completion(message,false)
//                            break
//                        case 1:
//                            completion(response,true)
//                            break
//                        default:
//                            print(1)
//                        }
                        break
                    case .failure(let error):
                        print(response.result)
                        completion(error.localizedDescription,false)
                        break
                    }
            }
        }
    
    

        func getRequestWithParameters(service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
            {
                let urlString = WebServices.BASE_URL_SERVICE + service
                let serviceUrl = URL(string: urlString)
               print(serviceUrl!)
                if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
                {
                    completion("The Internet connection appears to be offline.",false)
                    return
                }
                
                AF.request(serviceUrl!, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
                    {(response:DataResponse) in
                        
                        switch response.result
                        {
                          case .success(let data):
                            print(response.result)
                            
                             let jsonResponse = data as! [String : Any]
                            print(jsonResponse)
                           
                             completion(jsonResponse,true)
                            
       
                            break
                        case .failure(let error):
                            print(response.result)
                            completion(error.localizedDescription,false)
                            break
                        }
                }
            }
    
    
    
    
    enum ResponceCodes
    {
        case success, authError, badRequest, requestTimeOut, internalServerError, serviceUnavailable, notFound, forbidden, OtherError, NoInternet
        
        func GetResponceCode() -> Int
        {
            var result: Int = 0
            switch self
            {
            case .success:
                result = 200
            case .authError:
                result = 401
            case .badRequest:
                result = 400
            case .requestTimeOut:
                result = 408
            case .internalServerError:
                result = 500
            case .serviceUnavailable:
                result = 503
            case .notFound:
                result = 404
            case .forbidden:
                result = 403
            case .NoInternet:
                result = 007
            case .OtherError:
                result = 0
            }
            return result
        }
    }
    
    
}
