//
//  User.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

class  User
{

    static var userID:String?
   


    init(userDictionay:[String:Any])
    {
        User.userID          = userDictionay["id"] as? String
       
    }
    
}

