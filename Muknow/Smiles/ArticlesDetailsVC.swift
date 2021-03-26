//
//  ArticlesDetailsVC.swift
//  Muknow
//
//  Created by Apple on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import WebKit
import YouTubePlayer
import QuickLook

class ArticlesDetailsVC: UIViewController {
    
    @IBOutlet weak var TheContainerTV: UITableView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet var favBtn: UIButton!
    
    var articleId :Int?
    var userId : String?
    var favTag : Int = 0
    
    var Articles_Details_List = [AnyObject]()
    var Article_Quiz_Details = [AnyObject]()
    var Dict : NSDictionary!
    
    var fileStr : String?
    var fileURLs = [URL]()
    var wkwebViewSamle: WKWebView!
    
    var numberOfRows : Int = 0
    var arrOfQAStruct = [QAStruct]()
    
    var selectionImg = UIImage()
    var unSelectionImg = UIImage()
    var correctImg = UIImage()
    var wrongImg = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let lefticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 35, height: 35)))
        lefticonButton.setBackgroundImage(UIImage(named: "muknowAppLogo"), for: .normal)
        //        btn1.addTarget(self, action: Selector("action1:"), forControlEvents: .TouchUpInside)
        
        let leftbarButton = UIBarButtonItem(customView: lefticonButton)
        let righticonButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 20, height: 20)))
        righticonButton.setBackgroundImage(UIImage(named: "searchIcon"), for: .normal)
        righticonButton.addTarget(self, action: #selector(self.goToSearchPage), for: UIControl.Event.touchUpInside)
        
        let rightbarButton = UIBarButtonItem(customView: righticonButton)
        //
        navigationItem.leftBarButtonItem = leftbarButton
        navigationItem.rightBarButtonItem = rightbarButton
        
        TheContainerTV.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCellID" )
        TheContainerTV.register(UINib(nibName: "SecondCell", bundle: nil), forCellReuseIdentifier: "SecondCellID" )
        TheContainerTV.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCellID" )
//        TheContainerTV.register(UINib(nibName: "QuizCell", bundle: nil), forCellReuseIdentifier: "QuizCellID" )
        TheContainerTV.register(UINib(nibName: "QuizQandACell", bundle: nil), forCellReuseIdentifier: "QuizQandACellID" )
        
        
        selectionImg = UIImage(named: "radioCheck")!
        unSelectionImg = UIImage(named: "radioUncheck")!
        
        correctImg = UIImage(named: "checkMark")!
        wrongImg = UIImage(named: "redRadiobutton")!
        
    }
    override func viewWillAppear(_ animated: Bool) {
       /*
        self.showInFullScreenBtn.isHidden = true
        
        self.quizView.isHidden = true
        self.quizViewHeight.constant = 0
        
        self.AnswerCheckImg.isHidden = true */
        userId = UserDefaults.standard.string(forKey: "user_id")
        getAllArticleDetailsData()
    }
    func getAllArticleDetailsData()
    {
        
        
      // let params = ["lgw_user_id":userId,"article_id":articleId!] as [String:Any]

       
        
        
         let params = ["lgw_user_id":userId!,"article_id":articleId!] as [String:Any]
        
        print(params)
//        lgw_user_id=1&article_id=12
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.SMILES_ARTICLES_DETAILS, params: params) { [self] (result, success) in
            
            if success == false
            {
//                  self.scrollView.isHidden = true
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
//                  self.scrollView.isHidden = false
                let response = result as! [String : Any]
                
                if let code : Int = response["code"] as? Int {
                    print(code)
                    if code == 404 {
                        self.showAlert(message: response["error"]  as! String)
                    }else{
                        
                    }
                }else{
                    
                    let data = response ["data"] as! [String:Any]
                  
                    let response = data ["response"] as! [String:Any]
                    let Articlesdata = response ["data"] as! [String:Any]
                    
                    self.Articles_Details_List = (Articlesdata["articles_details"] as? [AnyObject]) != nil  ?  (Articlesdata["articles_details"] as! [AnyObject]) : []
                    
                  
                    if self.Articles_Details_List.count > 0 {
                        
                        self.Dict = self.Articles_Details_List[0] as? NSDictionary
                      
                        print(self.Dict!)
                        if self.Dict["favorite"] as? String == "No" {
                            self.favBtn.setImage(UIImage(named: "unfavouriteIcon"), for: .normal)
                            self.favTag = 0
                        }else{
                            self.favBtn.setImage(UIImage(named: "favouriteIcon"), for: .normal)
                            self.favTag = 1
                        }
                        
                        
                        //For Quiz
                        self.Article_Quiz_Details = ( self.Dict["article_quiz_details"] as? [AnyObject]) != nil  ?  ( self.Dict["article_quiz_details"] as! [AnyObject]) : []
                        
                        self.numberOfRows = self.Article_Quiz_Details.count + 3
                        
                       self.arrOfQAStruct.removeAll()
                        for _ in 1...3{
                            let aStruct = QAStruct()
                            self.arrOfQAStruct.append(aStruct)
                        }
                        for aDict in self.Article_Quiz_Details {
                            var aStruct = QAStruct()
                            let tempDict = aDict as! NSDictionary
                            aStruct.Question = (tempDict.value(forKey: "question") as! String)
                            aStruct.answer1 = (tempDict.value(forKey: "option1") as! String)
                            aStruct.answer2 = (tempDict.value(forKey: "option2") as! String)
                            aStruct.answer3 = (tempDict.value(forKey: "option3") as! String)
                            aStruct.answer4 = (tempDict.value(forKey: "option4") as! String)
                            aStruct.actualAnwser = (tempDict.value(forKey: "answer_key") as! String)
                            
                            aStruct.isOption1Tapped = false
                            aStruct.isOption2Tapped = false
                            aStruct.isOption3Tapped = false
                            aStruct.isOption4Tapped = false
                            
                            aStruct.isAnswerImgViewHidden = true
                            aStruct.isSubmitBtnTapped = false
                            
                            self.arrOfQAStruct.append(aStruct)
                        }
                    }else{
                        self.showAlert(message: "No Article data found")
                    }
                    self.TheContainerTV.reloadData()
                }
            }
            self.view.StopLoading()
        }
    }
    
    @objc private func goToSearchPage() {
        
        userId = UserDefaults.standard.string(forKey: "user_id")
        if userId != nil || userId != "" {
            let searchVc = self.storyboard?.instantiateViewController(withIdentifier: "SmilesSearchViewController") as! SmilesSearchViewController
            self.navigationController?.pushViewController(searchVc, animated: true)
        }
        else{
            self.showAlertWithAction(message: "Please login to continue")
        }
        
    }
    func showAlertWithAction(message:String)
    {
        
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(self.removeFromWishList), Controller: self),Message.AlertActionWithSelector(Title: "Cancel", Selector:#selector(cancelTapped), Controller: self)], Controller: self)
    }
    
    
   
    func showAlert(message:String)
    {
        Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
    }
    
    @objc func removeFromWishList() {
        
        let params = ["lgw_user_id":userId!,"article_id":articleId!] as [String:Any]
        print(params)
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.SMILES_UNFAVOURITE, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                let resultDictionary = result as! [String : Any]
                print(resultDictionary)
                
                let tmpArr:[Any] = [resultDictionary["data"]!]
                let response_data = tmpArr[0] as! [String: AnyObject]
                let response_object = response_data["response"] as! [String: AnyObject]
                let message_object = response_object["message"] as! String
                
                if let code : Int = resultDictionary["code"] as? Int {
                    print(code)
                    if code == 404 {
                        self.showAlert(message: resultDictionary["error"] as! String)
                    }else{
                        
                    }
                }
                else{
                    
                    self.showAlert(message: message_object)
                    
                    self.favBtn.setImage(UIImage(named: "unfavouriteIcon"), for: UIControl.State.normal)
                    self.favTag = 0
                }
            }
            
        }
        //              }
        
    }
    @objc func cancelTapped()
    {
        favTag = 1
        print("Cancel tapped...")
    }
    
    
    @IBAction func btn_fav_Tapped(_ sender: Any) {
        if favTag == 0 {
            
            self.addToWishList()
            //favTag = 1
            
        }else{
            
            self.showAlertWithAction(message: "Do You want to remove from Favourites")
            //self.removeFromWishList()
            //favTag = 0
        }
        
    }
    
    
    func addToWishList() {
        
        let params = ["lgw_user_id":userId!,"article_id":articleId!] as [String:Any]
        print(params)
        self.view.StartLoading()
        
        ApiManager().postRequest(service: WebServices.SMILES_FAVOURITE, params: params) { (result, success) in
            self.view.StopLoading()
            if success == false
            {
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                
                let resultDictionary = result as! [String : Any]
                print(resultDictionary)
                
                let tmpArr:[Any] = [resultDictionary["data"]!]
                let tmp:[Any] = [tmpArr[0]]
                print("tmp is ",tmp)
                
                
                
                
                let response_data = tmpArr[0] as! [String: AnyObject]
                let response_object = response_data["response"] as! [String: AnyObject]
                let message_object = response_object["message"] as! String
                
                if let code : Int = resultDictionary["code"] as? Int {
                    print(code)
                    if code == 404 {
                        self.showAlert(message: resultDictionary["error"] as! String)
                    }else{
                        
                    }
                }
                else{
                    
                    self.showAlert(message: message_object)
                    self.favBtn.setImage(UIImage(named: "favouriteIcon"), for: UIControl.State.normal)
                    self.favTag = 1
                }
            }
        }
    }
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension ArticlesDetailsVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150 //RatingCell
        }else if indexPath.row == 1{
            return 260 //ImgVideo Cell
        }else if indexPath.row == 2{
            return UITableView.automaticDimension //Description Cell
        }else{
            return 270 // QA Cell
        }
        
        
//        else if indexPath.row == 3{
//            return 500//UITableView.automaticDimension
//        }else {
//            return 100
//        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCellID", for: indexPath) as! RatingCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            
            if self.Dict != nil {
                cell.articleId = self.articleId //self.Dict[""] as? String
                cell.articleNameLbl.text = self.Dict["title"] as? String
                cell.authorName.text = "By \(self.Dict["author_name"] as! String)"
                
                
                let avgRate = self.Dict["avg_rate"] as! Double
                cell.ratingView.editable = false
                cell.ratingView.rating = avgRate
                cell.ratingView.type = .wholeRatings
                cell.ratingView.delegate = self
                cell.ratingView.backgroundColor = UIColor.clear
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SecondCellID", for: indexPath) as! SecondCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            
            if self.Dict != nil {
                let fileType =  self.Dict["file_type"] as? String
                if fileType == "2" {
                    /* let image  =  "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["photo_orig1"]!)"
                    
                    self.articleDisplayImg.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))
                    self.articleDisplayImg.isHidden = false
                    self.loadFilesView.isHidden = true */
                    
                    let image  =  "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["photo_orig1"]!)"
                    cell.articleImgView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "PlaceholderImg"))
                    cell.articleImgView.isHidden = false
                    cell.viewFullScreenBtn.isHidden = true
                    cell.loadView.isHidden = true
                    cell.viewFullScreenBtn.isHidden = true
                    cell.articleImgView.contentMode = .scaleAspectFill
                }else if fileType == "3"{
                    cell.articleImgView.isHidden = true
                    cell.loadView.isHidden = false
                    cell.viewFullScreenBtn.isHidden = true
                    let video  =  "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["video"]!)"
                 
                    let player = AVPlayer(url: URL(string: video)!)
                    let avPlayerViewController = AVPlayerViewController()
                    avPlayerViewController.player = player

                    avPlayerViewController.view.frame = cell.loadView.frame
                    cell.loadView.addSubview(avPlayerViewController.view)
                    self.addChild(avPlayerViewController)

                    player.play()
                }else if fileType == "4" {
//                    you tube video
                    
                    cell.articleImgView.isHidden = true
                    cell.loadView.isHidden = false
                    cell.viewFullScreenBtn.isHidden = true
                    let videoUrl: URL! = URL(string: self.Dict["url_link"] as! String)
                    print(videoUrl!)
                    
                    let videoPlayer = YouTubePlayerView(frame: CGRect( x: 0, y: 0, width: cell.loadView.frame.size.width, height: cell.loadView.frame.size.height))
                    videoPlayer.loadVideoURL(videoUrl!)
                    cell.loadView.addSubview(videoPlayer)
                }
                else if (fileType == "5"  || fileType == "6" ) {
                    //ppt ,pdf
                    
                    
                    cell.viewFullScreenBtn.isHidden = false
                    cell.articleImgView.isHidden = true
                    cell.loadView.isHidden = false
                    
                    self.fileStr =  "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["files"]!)"
                    
                    print(self.fileStr!)
                    //if (self.fileStr!.hasSuffix(".pdf")){
                        let url: URL! = URL(string: self.fileStr!)
                    
                    //self.fileURLs.append(url)
                    
                    let urlSession = URLSession(configuration: .default, delegate: (self as URLSessionDelegate), delegateQueue: OperationQueue())
                    
                    let downloadTask = urlSession.downloadTask(with: url)
                    downloadTask.resume()
                    

                    self.wkwebViewSamle = WKWebView()
                    //self.wkwebViewSamle = WKWebView(frame: CGRect( x: 0, y: 0, width: self.view.frame.size.width, height: 240 ), configuration: WKWebViewConfiguration())
                    
//                    self.wkwebViewSamle?.frame = CGRect(origin: CGPoint.zero, size: cell.loadView.frame.size)
                    
                    let req = NSURLRequest(url:url)
                    self.wkwebViewSamle.load(req as URLRequest)
                        
                    //self.wkwebViewSamle.addGestureRecognizer(self.tap!)
                    //self.wkwebViewSamle.isUserInteractionEnabled = true
                    
                    cell.loadView.addSubview(self.wkwebViewSamle)

                }
            }
            
            
            
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCellID", for: indexPath) as! DescriptionCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            if self.Dict != nil{
                let html_description =  self.Dict["description"] as? String
                cell.descriptionLbl.text = html_description?.stripOutHtml()
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizQandACellID", for: indexPath) as! QuizQandACell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            
            let aQAStruct = self.arrOfQAStruct[indexPath.row]
            cell.questionLbl.text = aQAStruct.Question
            cell.option1Lbl.text = aQAStruct.answer1
            cell.option2Lbl.text = aQAStruct.answer2
            cell.option3Lbl.text = aQAStruct.answer3
            cell.option4Lbl.text = aQAStruct.answer4
            
            
            cell.option1Btn.tag = indexPath.row
            cell.option1Btn.accessibilityHint = "1"
            if aQAStruct.isOption1Tapped {
                cell.option1Btn.setImage(selectionImg, for: .normal)
            }else{
                cell.option1Btn.setImage(unSelectionImg, for: .normal)
            }
            cell.option1Btn.addTarget(self, action: #selector(option1Tapped(sender:)), for: .touchUpInside)
            
            
            if aQAStruct.isSubmitBtnTapped {
                cell.answerImgView.isHidden = false
                if aQAStruct.actualAnwser == aQAStruct.selectedAnswer {
                    cell.answerImgView.image = self.correctImg
                }else{
                    cell.answerImgView.image = self.wrongImg
                }
                
            }else{
                cell.answerImgView.isHidden = true //aQAStruct.isAnswerImgViewHidden
            }
            
            
            cell.option2Btn.tag = indexPath.row
            cell.option2Btn.accessibilityHint = "2"
            if aQAStruct.isOption2Tapped {
                cell.option2Btn.setImage(selectionImg, for: .normal)
            }else{
                cell.option2Btn.setImage(unSelectionImg, for: .normal)
            }
            cell.option2Btn.addTarget(self, action: #selector(option2Tapped(sender:)), for: .touchUpInside)
            
            
            
            cell.option3Btn.tag = indexPath.row
            cell.option3Btn.accessibilityHint = "3"
            if aQAStruct.isOption3Tapped {
                cell.option3Btn.setImage(selectionImg, for: .normal)
            }else{
                cell.option3Btn.setImage(unSelectionImg, for: .normal)
            }
            cell.option3Btn.addTarget(self, action: #selector(option3Tapped(sender:)), for: .touchUpInside)
            
            
            
            cell.option4Btn.tag = indexPath.row
            cell.option4Btn.accessibilityHint = "4"
            cell.option4Btn.addTarget(self, action: #selector(option4Tapped(sender:)), for: .touchUpInside)
            
            if aQAStruct.isOption4Tapped {
                cell.option4Btn.setImage(selectionImg, for: .normal)
            }else{
                cell.option4Btn.setImage(unSelectionImg, for: .normal)
            }
            
            
            
            
            cell.submitBtn.tag = indexPath.row
            cell.submitBtn.accessibilityHint = "5"
            cell.submitBtn.addTarget(self, action: #selector(submitBtnTapped(sender:)), for: .touchUpInside)
            
            
            
            
            return cell
        }
        
        /*else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCellID", for: indexPath) as! QuizCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.delegate = self
            
            
            cell.testLbl.text = "Quiz"
            cell.index = indexPath.row
            cell.section = indexPath.section
            
            if self.Dict != nil {
                cell.dataDict = self.Dict
            }
            
            cell.doDefaultUI()
            cell.reloadQuizTV()
            return cell
        }*/
    }
    
    @objc func option1Tapped(sender: UIButton){
        let buttonTag = sender.tag
        print("cell index is ",buttonTag)
        print("option1 tapped")
        
        if self.arrOfQAStruct[buttonTag].isOption1Tapped {
//            self.arrOfQAStruct[buttonTag].isOption1Tapped = false
        }else{
            self.arrOfQAStruct[buttonTag].isOption1Tapped = true
            self.arrOfQAStruct[buttonTag].isOption2Tapped = false
            self.arrOfQAStruct[buttonTag].isOption3Tapped = false
            self.arrOfQAStruct[buttonTag].isOption4Tapped = false
            
            self.arrOfQAStruct[buttonTag].selectedAnswer = self.arrOfQAStruct[buttonTag].answer1
        }
        updateTheCell(cellIndex: buttonTag, sender: sender)
        
    }
    
    @objc func option2Tapped(sender: UIButton){
        let buttonTag = sender.tag
        print("cell index is ",buttonTag)
        print("option1 tapped")
        
        if self.arrOfQAStruct[buttonTag].isOption2Tapped {
//            self.arrOfQAStruct[buttonTag].isOption2Tapped = false
        }else{
            self.arrOfQAStruct[buttonTag].isOption2Tapped = true
            self.arrOfQAStruct[buttonTag].isOption1Tapped = false
            self.arrOfQAStruct[buttonTag].isOption3Tapped = false
            self.arrOfQAStruct[buttonTag].isOption4Tapped = false
            
            self.arrOfQAStruct[buttonTag].selectedAnswer = self.arrOfQAStruct[buttonTag].answer2
        }
        updateTheCell(cellIndex: buttonTag, sender: sender)
        
    }
    
    @objc func option3Tapped(sender: UIButton){
        let buttonTag = sender.tag
        print("cell index is ",buttonTag)
        print("option1 tapped")
        
        if self.arrOfQAStruct[buttonTag].isOption3Tapped {
//            self.arrOfQAStruct[buttonTag].isOption3Tapped = false
        }else{
            self.arrOfQAStruct[buttonTag].isOption3Tapped = true
            self.arrOfQAStruct[buttonTag].isOption1Tapped = false
            self.arrOfQAStruct[buttonTag].isOption2Tapped = false
            self.arrOfQAStruct[buttonTag].isOption4Tapped = false
            
            self.arrOfQAStruct[buttonTag].selectedAnswer = self.arrOfQAStruct[buttonTag].answer3
        }
        updateTheCell(cellIndex: buttonTag, sender: sender)
        
    }
    
    @objc func option4Tapped(sender: UIButton){
        let buttonTag = sender.tag
        print("cell index is ",buttonTag)
        print("option1 tapped")
        
        if self.arrOfQAStruct[buttonTag].isOption4Tapped {
//            self.arrOfQAStruct[buttonTag].isOption4Tapped = false
        }else{
            self.arrOfQAStruct[buttonTag].isOption4Tapped = true
            self.arrOfQAStruct[buttonTag].isOption1Tapped = false
            self.arrOfQAStruct[buttonTag].isOption2Tapped = false
            self.arrOfQAStruct[buttonTag].isOption3Tapped = false
            
            self.arrOfQAStruct[buttonTag].selectedAnswer = self.arrOfQAStruct[buttonTag].answer4
        }
        updateTheCell(cellIndex: buttonTag, sender: sender)
        
    }
    
    
    @objc func submitBtnTapped(sender: UIButton){
        let cellIndex = sender.tag
        print("Cell index is ",cellIndex)
        
        if self.arrOfQAStruct[cellIndex].isSubmitBtnTapped {
//            self.arrOfQAStruct[buttonTag].isOption1Tapped = false
        }else{
            self.arrOfQAStruct[cellIndex].isSubmitBtnTapped = true
            
        }
        updateTheCell(cellIndex: cellIndex, sender: sender)
    }
    
    func updateTheCell(cellIndex : Int,sender : UIButton){
        
        let selectedIndexPath = IndexPath(row: cellIndex, section: 0)
        let cell = self.TheContainerTV.cellForRow(at: selectedIndexPath as IndexPath) as! QuizQandACell
        
        switch sender.accessibilityHint {
            case "1":
                if self.arrOfQAStruct[cellIndex].isOption1Tapped {
                    cell.option1Btn.setImage(selectionImg, for: .normal)
                    cell.option2Btn.setImage(unSelectionImg, for: .normal)
                    cell.option3Btn.setImage(unSelectionImg, for: .normal)
                    cell.option4Btn.setImage(unSelectionImg, for: .normal)
                    
                }else{
//                    cell.option1Btn.setImage(unSelectionImg, for: .normal)
                }
                break
        case "2":
            if self.arrOfQAStruct[cellIndex].isOption2Tapped {
                cell.option2Btn.setImage(selectionImg, for: .normal)
                cell.option1Btn.setImage(unSelectionImg, for: .normal)
                cell.option3Btn.setImage(unSelectionImg, for: .normal)
                cell.option4Btn.setImage(unSelectionImg, for: .normal)
            }else{
//                cell.option2Btn.setImage(unSelectionImg, for: .normal)
            }
            break
        case "3":
            if self.arrOfQAStruct[cellIndex].isOption3Tapped {
                cell.option3Btn.setImage(selectionImg, for: .normal)
                cell.option1Btn.setImage(unSelectionImg, for: .normal)
                cell.option2Btn.setImage(unSelectionImg, for: .normal)
                cell.option4Btn.setImage(unSelectionImg, for: .normal)
                
            }else{
//                cell.option3Btn.setImage(unSelectionImg, for: .normal)
            }
            break
        case "4":
            if self.arrOfQAStruct[cellIndex].isOption4Tapped {
                cell.option4Btn.setImage(selectionImg, for: .normal)
                cell.option1Btn.setImage(unSelectionImg, for: .normal)
                cell.option2Btn.setImage(unSelectionImg, for: .normal)
                cell.option3Btn.setImage(unSelectionImg, for: .normal)
                
            }else{
//                cell.option4Btn.setImage(unSelectionImg, for: .normal)
            }
            break
            
        case "5" :
            if self.arrOfQAStruct[cellIndex].isSubmitBtnTapped {
                
                cell.answerImgView.isHidden = false
                if self.arrOfQAStruct[cellIndex].actualAnwser  == self.arrOfQAStruct[cellIndex].selectedAnswer {
                    cell.answerImgView.image = self.correctImg
                }else{
                    cell.answerImgView.image = self.wrongImg
                }
            }else{
                cell.answerImgView.isHidden = true
            }
            break
            
        default:
            break
        }
    }
    
}

extension ArticlesDetailsVC : RatingCellDelegate {
    
    func openRatingVC(articleId: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllReviewsVCSBID") as! AllReviewsVC
        vc.articlesID = self.articleId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func openWriteReviewVC(articleId: Int) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
        controller.articleId = articleId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
extension ArticlesDetailsVC : SecondCellDelegate {
    func viewInFullScreen() {
        
    }
    
    func refreshSecondCell(row: Int, section: Int) {
        
    }
    
    
}
extension ArticlesDetailsVC : FloatRatingViewDelegate {
    
}
extension ArticlesDetailsVC : DescriptionCellDelegate {
    func refreshSecondCell() {
        
    }
}
extension ArticlesDetailsVC : QuizQandACellDelegate {
    func submitTapped(index: Int) {
        
    }
}
/*extension ArticlesDetailsVC : QuizCellDelegate {
    
} */
extension ArticlesDetailsVC:  URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            //self.pdfURL = destinationURL
            self.fileURLs.append(destinationURL)
            print("Download File URL :",destinationURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
