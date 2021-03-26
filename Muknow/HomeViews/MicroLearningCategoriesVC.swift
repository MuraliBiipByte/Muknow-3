
import UIKit


class MicroLearningCategoriesVC: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    var expandTableHeight:CGFloat?
    
    var categoriesList = [AnyObject]()
    var subCategoriesList = [AnyObject]()
    var isSelected : Bool = false
    var dictObjects:[[String:Any]] = []
    
    var List = [AnyObject]()
        var userId :String?
    
    @IBOutlet var CategoriesTV: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
       
                  let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
                          lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
                     //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
             //
                           let leftbarButton = UIBarButtonItem(customView: lefticonButton)
             //
             //
                         let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
                           righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
                              righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
             //
               let rightbarButton = UIBarButtonItem(customView: righticonButton)
             //
                 navigationItem.leftBarButtonItem = leftbarButton
                    navigationItem.rightBarButtonItem = rightbarButton
               
        self.CategoriesTV.isHidden = true
        self.CategoriesTV.tableFooterView = UIView.init(frame: CGRect.zero)
        getAllCategoriesList()
    }
    
    @objc private func goToSearchPage() {
        
        
    
          userId = UserDefaults.standard.string(forKey: "user_id")
        if userId != nil || userId != "" {
            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "SmilesSearchViewController") as! SmilesSearchViewController
//            searchVc.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(searchVc, animated: true)
        }
        else{
            
            self.showAlertWithAction(message: "Please login to continue")
            
        }
        
       
        
    }
    
    func getAllCategoriesList()
    {
        
//        self.view.StartLoading()
//        ApiManager().getRequest(service:WebServices.CATEGORIES)
//        { (result, success) in
        
//        Access_Token = UserDefaults.standard.object(forKey: "access_token") as! String
//
//                      let paramsDict = [
//                          "token":Access_Token
//                      ]
//
                      
                  self.view.StartLoading()
                      
        ApiManager().getRequestWithParameters(service: WebServices.CATEGORIES, params: [:], completion:
                      { (result, success) in
                        
                        
            self.view.StopLoading()
            
            if success == false
            {
                self.showAlert(message: result as! String)
                return
            }
            else
            {
                
                let response = result as! [String : Any]
                let data = response ["data"] as! [String:Any]
                let categoryresponse = data ["response"] as! [String:Any]
                let categorydata = categoryresponse ["data"] as! [String:Any]
                
                self.categoriesList = (categorydata["categories"] as? [AnyObject]) != nil  ?  (categorydata["categories"] as! [AnyObject]) : []
                
                var dict:[String:Any] = [:]
                
                for i in self.categoriesList {
                    dict["Categories"] = i
                    dict["isSelected"] = 0
                    
                    self.dictObjects.append(dict)
                    
                }
                
                if (self.categoriesList.count > 0)
                {
                    
                    self.CategoriesTV.dataSource = self
                    self.CategoriesTV.delegate = self
                    self.CategoriesTV.reloadData()
                    self.CategoriesTV.isHidden = false
                    
                }
            }
        })
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dictObj = dictObjects[indexPath.section]
        let isSelected = dictObj["isSelected"] as? Int
        if isSelected == 0 {
            
            return 55
            
        }else{
            if indexPath.row == 0 {
                return 55
            }else{
                return 45
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dictObj = dictObjects[section]
        let List = dictObj["Categories"] as! NSDictionary
        
        let Subcategories = List["subcategories"] as! NSArray
       
        let isSelected:Int = dictObj["isSelected"] as! Int
        if isSelected == 1 {
//            return 1
            return Subcategories.count + 1
        } else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dictObj = dictObjects[indexPath.section]
        let isSelected = dictObj["isSelected"] as? Int
        if isSelected == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
            
            let List = dictObj["Categories"] as! NSDictionary
            
            cell!.sectionLbl.text = List["name"] as? String ?? ""
//            cell!.lessonPageTitleLbl.text = List["lesson_page_title"] as? String ?? ""
           
            return cell!
        } else {
            
            if indexPath.row == 0 {
          
                let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
                let List = dictObj["Categories"] as! NSDictionary
               
                cell!.sectionLbl.text = List["name"] as? String ?? ""
//                cell!.lessonPageTitleLbl.text = List["lesson_page_title"] as? String ?? ""
                
//                cell!.rightArrImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
                cell!.selectionStyle = .none

                return cell!
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
                
                let List = dictObj["Categories"] as! NSDictionary
                let Subcategories = List["subcategories"] as! NSArray
                let dict = Subcategories[indexPath.row - 1] as! NSDictionary
                cell!.customCellLbl.text = dict["name"] as? String
                
                cell!.selectionStyle = .none
                
                return cell!
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SectionTableViewCell") as? SectionTableViewCell
        
        var dictObj = dictObjects[indexPath.section]
        let isSelected = dictObj["isSelected"] as? Int
        if isSelected == 0 {
            cell!.rightArrImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi/2)
            
            dictObj["isSelected"] = 1
            dictObjects[indexPath.section] = dictObj
            CategoriesTV.reloadData()
            
        } else {
            
            if indexPath.row == 0 {
                dictObj["isSelected"] = 0
                dictObjects[indexPath.section] = dictObj
                CategoriesTV.reloadData()
                cell!.rightArrImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi/3)
            }else{
                dictObj["isSelected"] = 1
                let List = dictObj["Categories"] as! NSDictionary
                let Subcategories = List["subcategories"] as! NSArray
                let dict = Subcategories[indexPath.row - 1] as! NSDictionary
                
                let id = dict["id"] as? Int
                
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "LessionsListViewController") as! LessionsListViewController
                controller.hidesBottomBarWhenPushed = true
                controller.lessionId = id
                self.navigationController?.pushViewController(controller, animated: true)
            }
       
        }
        
    }
    
    
    @objc func goToLogin()
     {
         let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
       
        self.navigationController?.pushViewController(LoginController, animated: true)
     }
    

    @IBAction func back_vc(_ sender: Any) {

        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeTabbar") as! UITabBarController

        nextViewController.selectedIndex = 0
        self.present(nextViewController, animated: true, completion: nil)


    }
    
    
       func showAlertWithAction(message:String)
       {
           Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(goToLogin), Controller: self)], Controller: self)
       }
     
    
    
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
}
