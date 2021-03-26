//
//  TutorialPageViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class TutorialPageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func goToContentWritter_Tapped(_ sender: Any) {
        
        
        let vc = UIStoryboard.init(name: "WalkthroughStoryboard", bundle: Bundle.main).instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController
//        self.navigationController?.pushViewController(vc!, animated: true)

        self.present(vc!, animated: true, completion: nil)
        
        
//       let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentWritterViewController") as! ContentWritterViewController
////       self.navigationController?.pushViewController(vc, animated: true)
//        self.present(vc, animated: true, completion: nil)
//
//
    }
    

}
