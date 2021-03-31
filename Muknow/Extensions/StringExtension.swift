//
//  StringExtension.swift
//  TripArcher
//
//  Created by APPLE on 02/01/19.
//  Copyright © 2019 APPLE. All rights reserved.
//

import UIKit

extension String {
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"    
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    
    func isValidInput() -> Bool {
        let RegEx = ".*[^A-Za-z ].*" //"[\\b([A-Za-z]{4,})([0-9._# $%+-@]{0,})]{4,}"
        let Test = NSPredicate(format:"SELF MATCHES %@", RegEx)
        return Test.evaluate(with: self)
    }
    
    func isValidMobileNumber() -> Bool {

       let phoneRegex = "^[0-9]{8,10}$";
       let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
       return valid
    }
    
    func stripOutHtml() -> String? {
        do {
            guard let data = self.data(using: .unicode) else {
                return nil
            }
            let attributed = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributed.string
        } catch {
            return nil
        }
    }

}

