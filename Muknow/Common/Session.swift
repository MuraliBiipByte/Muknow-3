//
//  Session.swift
//  Muknow
//
//  Created by Apple on 24/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

class Session: NSObject {
    
    static let shared = Session()
    var myUserDefaults = UserDefaults()

    override init() {
        super .init()
        myUserDefaults = UserDefaults.standard
    }
    
    
   /* func setIsProfielImgDownloading(isDownloading: Bool) {
        myUserDefaults.set(isDownloading, forKey: IS_PROFILE_IMAGE_DOWNLOADING)
        myUserDefaults.synchronize()
    }
    
    func isProfileImgDownloading() -> Bool {
        return myUserDefaults.bool(forKey: IS_PROFILE_IMAGE_DOWNLOADING)
    }
    
    
    
    func setIsProfileImgDownloaded(isDownloaded: Bool) {
        myUserDefaults.set(isDownloaded, forKey: IS_PROFILE_IMAGE_DOWNLOADED)
        myUserDefaults.synchronize()
    }
    
    func isProfileImgDownloaded() -> Bool {
        return myUserDefaults.bool(forKey: IS_PROFILE_IMAGE_DOWNLOADED)
    } */
}


