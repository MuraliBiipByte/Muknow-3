//
//  Extensions.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}
@IBDesignable
class DesignableTextField: UITextField {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
extension UIColor
{
    public convenience init?(hexString: String)
    {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

extension UIView {
    
    // MARK: - Loader {
    
    func StartLoading() {
        
        if let _ = viewWithTag(10000)
        {
            //View is already Loading
        }
        else
        {
            
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor.clear
            lockView.tag = 10000
            
            addSubview(lockView)
            
            let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            container.backgroundColor = UIColor.lightGray
            container.layer.cornerRadius = 5
            container.clipsToBounds = true
            container.center =  lockView.center
            lockView.addSubview(container)
            
            let activity = UIActivityIndicatorView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
            activity.style = .whiteLarge
            activity.hidesWhenStopped = true
            activity.center = container.center
            
            lockView.addSubview(activity)
            lockView.bringSubviewToFront(activity)
            
            activity.startAnimating()
        }
    }
    
    func isLoading() -> Bool
    {
        if viewWithTag(10000) != nil {
            return true
        }
        return false
    }
    
    func StopLoading()
    {
        if let lockView = viewWithTag(10000)
        {
            UIView.animate(withDuration: 0.2, animations:
                {
                
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
}
}
