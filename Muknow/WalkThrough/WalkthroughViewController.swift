//
//  WalkthroughViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//


import UIKit

class WalkthroughViewController: UIViewController,walkthroughPageViewControllerDelegate {
   
    

    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var loginBtn : UIButton! {
        didSet {
            loginBtn.layer.cornerRadius = 25.0
            loginBtn.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var registerBtn : UIButton! {
        didSet {
            registerBtn.layer.cornerRadius = 25.0
            registerBtn.layer.masksToBounds = true
        }
    }
    
    
    
     @IBOutlet var skipBtn : UIButton!
    
    var walkthroughPageViewController : WalkthroughPageViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func skipButtonTapped(sender:UIButton) {
        
        UserDefaults.standard.set(true, forKey: "user_guide")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        /*
            let HomeViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController
            //        UITabBar.appearance().tintColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
            //        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
                    self.present(HomeViewController, animated: true, completion: nil)*/
        
        
        
        
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "theNavigationVCSBID") as! UINavigationController
        self.present(nextViewController, animated: true, completion: nil)

        
       // dismiss(animated: true, completion: nil)
    }
   
    @IBAction func loginButtonTapped(sender:UIButton) {
////        if let index = walkthroughPageViewController?.currentIndex{
////            switch index {
////            case 0...2:
//                walkthroughPageViewController?.forwardPage()
//
////            case 3:
////                self.dismiss(animated: true, completion: nil)
////            default:
////                break
////            }
//
////        }
      UserDefaults.standard.set(true, forKey: "user_guide")

        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    @IBAction func registerButtonTapped(sender:UIButton) {
//        if let index = walkthroughPageViewController?.currentIndex{
//            switch index {
//            case 0...2:
//                walkthroughPageViewController?.forwardPage()
            
//            case 3:
//                self.dismiss(animated: true, completion: nil)
//            default:
//                break
//            }
//
//        }
        
        UserDefaults.standard.set(true, forKey: "user_guide")

           let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegistrationViewController") as? RegistrationViewController
            self.present(vc!, animated: true, completion: nil)
                
        
        
        
    }
    
    
    
    func updateUI() {
        if let index = walkthroughPageViewController?.currentIndex{
            switch index {
            case 0...2:
                loginBtn.setTitle("Login", for: .normal)
                registerBtn.setTitle("Register", for: .normal)
                //                    skipBtn.isHidden = false
                
            case 3:
                loginBtn.setTitle("Login", for: .normal)
                registerBtn.setTitle("Register", for: .normal)
                skipBtn.isHidden = false
                
            default:
                break
            }
            
        }
        
    }
    
    func dipUpdatePageIndex(currentIndex: Int) {
           updateUI()
       }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? WalkthroughPageViewController {
            walkthroughPageViewController = pageViewController
            walkthroughPageViewController?.walkthroughDelegate = self
            
        }
    }
    
}
