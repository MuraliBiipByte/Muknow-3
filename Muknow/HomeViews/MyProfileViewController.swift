//
//  MyProfileViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
 let AccountInfoTitles = ["My Profile","Settings","Support"]
    
    @IBOutlet var AccountTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//
        AccountTable.tableFooterView = UIView.init(frame: CGRect.zero)
        AccountTable.separatorColor = UIColor.clear
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return AccountInfoTitles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell")as! ProfileTableViewCell
        
//        cell.accessoryType = .detailDisclosureButton
        cell.lblProfileListName.text = AccountInfoTitles[indexPath.row]
        
        cell.layoutView.layer.shadowColor = UIColor.lightGray.cgColor
        cell.layoutView.layer.shadowOffset =  CGSize(width: 1, height: 1)
        cell.layoutView.layer.shadowOpacity = 1;
        cell.layoutView.layer.shadowRadius = 1.0;
        cell.layoutView.layer.masksToBounds = false;
        
        
        
//        tblHight.constant = tableView.contentSize.height
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    
}
