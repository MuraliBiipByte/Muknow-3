//
//  ApiManager.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation


struct WebServices {
    //Test
    /* IP Address has been changed */
   static let BASE_URL_SERVICE = "http://54.255.115.196/muknow_new/index.php/"
   static let BASE_URL = "http://54.255.115.196/muknow_new/"
    
    //Live
    //    static let BASE_URL_SERVICE = "https://shserv.muknow.com.sg/index.php/"
    //    static let BASE_URL = "https://shserv.muknow.com.sg/"
    
   static let APP_VERSION = "register_user/get_app_version"
    
    
   
}

//class ApiManager {
//    func postRequest(service:String,params: [String:Any], completion: @escaping (_ result:Any,_ success:Bool) -> ())
//    {
//        let urlString = WebServices.BASE_URL_SERVICE + service
//        let serviceUrl = URL(string: urlString)
//        
//        if !(Alamofire.NetworkReachabilityManager()?.isReachable)!
//        {
//            completion("The Internet connection appears to be offline.",false)
//            return
//        }
//        
//        Alamofire.request(serviceUrl!, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
//            {(response:DataResponse) in
//                
//                switch response.result
//                {
//                case .success( _):
//                    print(response.result.value as! [String : Any])
//                    let jsonResponse = response.result.value as! [String : Any]
//                    let response = jsonResponse["response"] as! [String:Any]
//                    
//                    let status = "\(String(describing: response["status"]!))"
//                    
//                    let message = response["message"] as! String
//                    switch Int(status)
//                    {
//                    case 0:
//                        completion(message,false)
//                        break
//                    case 1:
//                        completion(response,true)
//                        break
//                    default:
//                        print(status)
//                    }
//                    break
//                case .failure(let error):
//                    
//                    completion(error.localizedDescription,false)
//                    break
//                }
//        }
//    }
//}
