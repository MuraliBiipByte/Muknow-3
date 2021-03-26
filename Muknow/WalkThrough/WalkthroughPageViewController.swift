//
//  WalkthroughPageViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//
//

import UIKit


protocol walkthroughPageViewControllerDelegate : class {
    func dipUpdatePageIndex(currentIndex:Int)
}
class WalkthroughPageViewController: UIPageViewController ,UIPageViewControllerDataSource,UIPageViewControllerDelegate{

    var pageHeadings = ["What is Muknow About?","Our Origins","Subscribed Courses","Our Team"]
    var pageSubheadings = ["Find self-improvement and career enhancing lessons in Singapore on LessonsGoWhere, Singapore's first online marketplace for all the lessons you ever need!","Excepted sint occaeckt cupidatatnon proident, sunt in culpa qui","Excepted sint occaeckt cupidatatnon proident","sub4"]
    
    var pageImages = ["walkthrough-1","walkthrough-2","walkthrough-3","walkthrough-4"]
    var currentIndex = 0
    
    weak var walkthroughDelegate : walkthroughPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index -= 1
        return contentViewController(at : index)
        
    
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! WalkthroughContentViewController).index
        index += 1
        return contentViewController(at : index)
        
    }
    
    func contentViewController(at index:Int)-> WalkthroughContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        
        if let pagecontrolvc = self.storyboard?.instantiateViewController(withIdentifier: "WalkthroughContentViewController") as? WalkthroughContentViewController {
            pagecontrolvc.imagefile = pageImages[index]
            pagecontrolvc.heading = pageHeadings[index]
            pagecontrolvc.subheading = pageSubheadings[index]
            pagecontrolvc.index = index
            
            return pagecontrolvc
            
        }
        return nil
    }
   
    func forwardPage() {

        currentIndex += 1
        if let nextVC = contentViewController(at: currentIndex) {
            setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? WalkthroughContentViewController {
                currentIndex = contentViewController.index
                walkthroughDelegate?.dipUpdatePageIndex(currentIndex: currentIndex)
            }
        }
    }
}
