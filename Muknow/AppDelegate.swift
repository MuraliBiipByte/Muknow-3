//
//  AppDelegate.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import Firebase
import FirebaseAuth
import Stripe
import IQKeyboardManagerSwift


@available(iOS 10.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

//    MessagingDelegate
    var window: UIWindow?
    var tooltip :Bool?
    var storyboard:UIStoryboard!
    var userId :String?
    var isGuide : Bool = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UITabBar.appearance().tintColor = APPEARENCE_COLOR
        STPAPIClient.shared().publishableKey = STRIPE_SMILES_PUBLISHABLE_KEY
        IQKeyboardManager.shared.enable = true
        
        isGuide = UserDefaults.standard.bool(forKey: "user_guide")
       /* if isGuide {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//
//            let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            let window = UIApplication.shared.delegate!.window!
//            window?.rootViewController = mainViewController

            
            
        }else{
            
            let storyboard = UIStoryboard(name: "WalkthroughStoryboard", bundle: nil)
            
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController
            
        } */
        
        if isGuide {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "theNavigationVCSBID") as! UINavigationController
            
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController

        }else{
            
            let storyboard = UIStoryboard(name: "WalkthroughStoryboard", bundle: nil)
            let mainViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
            let window = UIApplication.shared.delegate!.window!
            window?.rootViewController = mainViewController
            
        }
        
        
        
        //         userId = UserDefaults.standard.string(forKey: "user_id")
        //        if userId == nil {
        //
        //            let storyboard = UIStoryboard(name: "WalkthroughStoryboard", bundle: nil)
        //
        //            let mainViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as! WalkthroughViewController
        //            let window = UIApplication.shared.delegate!.window!
        //            window?.rootViewController = mainViewController
        //        }else{
        //
        ////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        ////
        ////            let mainViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        ////            let window = UIApplication.shared.delegate!.window!
        ////            window?.rootViewController = mainViewController
//
        ////            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        ////            let mainViewController = storyboard.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        ////           let window = UIApplication.shared.delegate!.window!
        ////           window?.rootViewController = mainViewController
        //
        //            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //            let mainViewController = storyboard.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController
        //            let window = UIApplication.shared.delegate!.window!
        //            window?.rootViewController = mainViewController
        //
        //        }
        //        if tooltip == true
        //        {
        //            tooltip = false
        //            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "TutorialPageViewController") as! TutorialPageViewController
        //            let window = UIApplication.shared.delegate!.window!
        //            window?.rootViewController = mainViewController
        //        }
        //        else{
        //
        //            let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "Nav") as! UINavigationController
        //                       let window = UIApplication.shared.delegate!.window!
        //                       window?.rootViewController = mainViewController
        //
        //
        //        }
        
        
        FirebaseApp.configure()
        registerForNotifications()
        Messaging.messaging().delegate = self
        
        
        
        return true
    }

    
    func registerForNotifications()
    {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in
            
            DispatchQueue.main.async
                {
                    UIApplication.shared.registerForRemoteNotifications()
            }
        })
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String)
    {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcm_Token")

    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for notifications!")
//        let deviceTokenString = deviceToken.hexString
//          print(deviceTokenString)
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
            print("Device Token = ",token)
    }
//
//    var hexString: String {
//          let hexString = map { String(format: "%02.2hhx", $0) }.joined()
//          return hexString
//      }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        
        completionHandler([.alert, .badge, .sound])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        print(response)
    }
   
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        tooltip = false
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Muknow")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

