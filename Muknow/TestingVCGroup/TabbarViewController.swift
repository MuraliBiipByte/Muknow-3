//
//  TabbarViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        print("Selected item")
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
              
        
        
    }
    
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        if(item.tag == 1) {
//            // Code for item 1
//        } else if(item.tag == 2) {
//            // Code for item 2
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MicroLearningCategoriesVC") as! MicroLearningCategoriesVC
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        }
//    }
    //
    
    
    
//    @objc private func goToSearchPage() {
//        let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "LGWSearchViewController") as! LGWSearchViewController
//        self.navigationController?.pushViewController(searchVc, animated: true)
//
//    }
//
    
   

}
