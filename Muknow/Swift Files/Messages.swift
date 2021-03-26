//
//  Messages.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

final class Message
{
    
    static let shared = Message()
    
    func Alert(Title:String,Message:String, TitleAlign:AlertTextAllignment, MessageAlign:AlertTextAllignment,Actions:[UIAlertAction],Controller:UIViewController)
    {
        
        let Alert = UIAlertController.init(title: TitleAlign == .normal ? Title : nil, message: MessageAlign == .normal ? Message : nil, preferredStyle: UIAlertController.Style.alert)
        
        let TitleStr:String? = Title == "Muknow" ? nil : Title
        let MsgStr:String? = Message == "" ? nil : Message
        
        var AttributedTitle = NSAttributedString()
        var AttributedMessage = NSAttributedString()
        
        if (TitleStr != nil) {
            if TitleAlign != .normal {
                let TitleParaStyle = NSMutableParagraphStyle()
                TitleParaStyle.alignment = TitleAlign == .left ? .left : .right
                AttributedTitle = NSAttributedString.init(string: TitleStr!, attributes: [NSAttributedString.Key.paragraphStyle:TitleParaStyle,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor:UIColor.black])
                Alert.setValue(AttributedTitle, forKey: "attributedTitle")
            }
        }
        
        if (MsgStr != nil) {
            if MessageAlign != .normal {
                let MessageParaStyle = NSMutableParagraphStyle()
                MessageParaStyle.alignment = MessageAlign == .left ? .left : .right
                AttributedMessage = NSAttributedString.init(string: MsgStr!, attributes: [NSAttributedString.Key.paragraphStyle:MessageParaStyle,NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.darkGray])
                Alert.setValue(AttributedMessage, forKey: "attributedMessage")
            }
        }
        
        for Action in Actions {
            Alert.addAction(Action)
        }

        Controller.present(Alert, animated: true, completion: nil)
        
    }
    
    class func AlertActionWithSelector(Title:NSString,Selector:Selector,Controller:UIViewController) -> UIAlertAction
    {
        let Action = UIAlertAction.init(title: Title as String, style: UIAlertAction.Style.default, handler: { (AlertAction:UIAlertAction) in
            
            Controller.perform(Selector)
            
        })
        return Action
    }
    
    class func AlertActionWithOutSelector(Title:NSString) -> UIAlertAction
    {
        let Action = UIAlertAction.init(title: Title as String, style: UIAlertAction.Style.default, handler: nil)
        return Action
    }

    
    enum AlertTextAllignment {
        case left,right,normal
    }
    
}
