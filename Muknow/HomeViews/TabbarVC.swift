//
//  TabbarVC.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TabbarVC: UIViewController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        createTabBarController()
        

    }
 
    
    func createTabBarController() {
        
        let tabBarCnt = UITabBarController()
        tabBarCnt.tabBar.tintColor = APPEARENCE_COLOR

        let firstVc = UIViewController()
      
        firstVc.tabBarItem = UITabBarItem.init(title: "Home", image: UIImage(named: "Home"), tag: 0)
        let secondVc = UIViewController()
       
        secondVc.tabBarItem = UITabBarItem.init(title: "Categories", image: UIImage(named: "categoriesIcon"), tag: 0)

        tabBarCnt.viewControllers = [firstVc, secondVc]
        
        self.view.addSubview(tabBarCnt.view)
    }
    
    
     func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//           print("Selected item")
       }

       // UITabBarControllerDelegate
       func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
                 
//            print("Selected item")
           
       }
    
    
}
