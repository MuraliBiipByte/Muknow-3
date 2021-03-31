//
//  ArticleDetailsViewController.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer
import WebKit
import YouTubePlayer
import QuickLook


class ArticleDetailsViewController: UIViewController,AVPlayerViewControllerDelegate,FloatRatingViewDelegate {

    var imgArr = [UIImage]()
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var imageContainer: UIView!
    var userId : String?
    var articleId :Int?
    var fileStr : String?
    var fileType : String?
    
//    var player : AVPlayer?
//    var playerLayer : AVPlayerLayer?
    
    
    @IBOutlet weak var showInFullScreenBtn: UIButton!
    @IBAction func showInFullScreenBtnTapped(_ sender: UIButton) {
        showMyDocPreview(currIndex: 0)
    }
    
    @IBOutlet var articleNameLbl: UILabel!
    
    
    @IBOutlet var authorName: UILabel!
    @IBOutlet var articleDescription: UILabel!
    @IBOutlet var loadFilesView: UIView!

    
    @IBOutlet var ratingView: FloatRatingView!
    
    
    @IBOutlet var scrollView: UIScrollView!

    
    @IBOutlet var quizView: UIView!
    
    @IBOutlet var quizViewHeight: NSLayoutConstraint!
    
    
    
    @IBOutlet var articleDisplayImg: UIImageView!
    
    
   var Articles_Details_List = [AnyObject]()
   var Article_Quiz_Details = [AnyObject]()

    var Dict : NSDictionary!
    
    var selectedAnswer = String()
    var actualAnswer = String()

    
    @IBOutlet var quizQuestionLbl: UILabel!
    
    @IBOutlet var option1Lbl: UILabel!
    @IBOutlet var option2Lbl: UILabel!
    @IBOutlet var option3Lbl: UILabel!
    
    @IBOutlet var option4Lbl: UILabel!
    
    @IBOutlet var AnswerCheckImg: UIImageView!
    

    let quickLookController = QLPreviewController()
    var fileURLs = [URL]()
    //var tap : UITapGestureRecognizer?
    
    @IBAction func viewReviewsBtnTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AllReviewsVCSBID") as! AllReviewsVC
        vc.articlesID = self.articleId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageContainer.isHidden = true
        
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
        
        self.scrollView.isHidden = true
        
        
       //tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        
        quickLookController.dataSource = self
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
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        print("LoadFilesView Tapped...")
        showMyDocPreview(currIndex: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.showInFullScreenBtn.isHidden = true
        
        self.quizView.isHidden = true
        self.quizViewHeight.constant = 0
        
        self.AnswerCheckImg.isHidden = true
        userId = UserDefaults.standard.string(forKey: "user_id")
        getAllArticleDetailsData()
    }
    
    
    var wkwebViewSamle: WKWebView!
    
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
                  self.scrollView.isHidden = true
                self.showAlert(message: result as! String)
                return
                
            }
            else
            {
                
                  self.scrollView.isHidden = false
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
                        self.articleNameLbl.text = self.Dict["title"] as? String
                           
                        self.authorName.text = "By \(self.Dict["author_name"] as! String)"
                        
                        //let short_description =  self.Dict["short_description"] as? String
                        let html_description =  self.Dict["description"] as? String
                      
                        self.articleDescription.text = html_description?.stripOutHtml()
                        
                        
                        
                        
                        // let descText = description!.replacingOccurrences(of: "\n", with: "<br>")
                        //print(attributed.string)
                        
                        //self.articleDescription.attributedText = description?.htmlToAttributedString
                        
                        
                        
                        
                        
                        //let attributed = try NSAttributedString(data: description.data(using: .unicode)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                        
                        //let htmlString = "LCD Soundsystem was the musical project of producer <a href='http://www.last.fm/music/James+Murphy' class='bbcode_artist'>James Murphy</a>, co-founder of <a href='http://www.last.fm/tag/dance-punk' class='bbcode_tag' rel='tag'>dance-punk</a> label <a href='http://www.last.fm/label/DFA' class='bbcode_label'>DFA</a> Records. Formed in 2001 in New York City, New York, United States, the music of LCD Soundsystem can also be described as a mix of <a href='http://www.last.fm/tag/alternative%20dance' class='bbcode_tag' rel='tag'>alternative dance</a> and <a href='http://www.last.fm/tag/post%20punk' class='bbcode_tag' rel='tag'>post punk</a>, along with elements of <a href='http://www.last.fm/tag/disco' class='bbcode_tag' rel='tag'>disco</a> and other styles. <br />"
                        
                        
                        if self.Dict["favorite"] as? String == "No" {
                            self.favBtn.setImage(UIImage(named: "unfavouriteIcon"), for: .normal)
                            self.favTag = 0
                        }else{
                            self.favBtn.setImage(UIImage(named: "favouriteIcon"), for: .normal)
                            self.favTag = 1
                        }
                        
//
//                        let float:Float = 2.2 // 2.2
                     
                        
                        let avgRate = self.Dict["avg_rate"] as! Double
                       
                        
                        self.ratingView.editable = false
                        self.ratingView.rating = avgRate
                        self.ratingView.type = .wholeRatings
                        self.ratingView.delegate = self
                        self.ratingView.backgroundColor = UIColor.clear
                        
                        self.fileType =  self.Dict["file_type"] as? String
                        
                        print( self.fileType!)
                        if self.fileType == "2" {
                            imageContainer.isHidden = false
                            
//                            let img1 = "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["photo_orig1"]!)"
//                            let img2 = "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["photo_orig2"]!)"
//                            let img3 = "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["photo_orig3"]!)"
                            
                            /* DispatchQueue.main.async   {
                                for n in 1...3{
                                    
                                    let tmpURLStr = "\(WebServices.ARTICLE_BASE_URL)\(self.Dict[("photo_orig" + "\(n)")]!)"
                                    if tmpURLStr != "<null>" {
                                        downloadImage(from:URL(string: tmpURLStr)!)
                                    }
                                    
                                }
                                self.setupImages(imgArr)
                            } */
//                            imgArr.append(img1)
//                            imgArr.append(img2)
//                            imgArr.append(img3)
                            
                            //self.setupImages(imgArr)
                            
                            
                            
                            //let image  =  "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["photo_orig1"]!)"
                            
                            //imgArr.removeAll()
                            /*
                             self.articleDisplayImg.sd_setImage(with: URL(string: img1), placeholderImage: UIImage(named: "PlaceholderImg"))
                            imgArr.append(self.articleDisplayImg.image!)
                            
                            self.articleDisplayImg.sd_setImage(with: URL(string: img2), placeholderImage: UIImage(named: "PlaceholderImg"))
                            imgArr.append(self.articleDisplayImg.image!)
                            
                            self.articleDisplayImg.sd_setImage(with: URL(string: img3), placeholderImage: UIImage(named: "PlaceholderImg"))
                            imgArr.append(self.articleDisplayImg.image!)*/
                            
                            
                              
                            
                            
                            self.articleDisplayImg.isHidden = true
                            self.loadFilesView.isHidden = true
                        }
                            
                        else if self.fileType == "3" {
                            imageContainer.isHidden = true
                            //self.articleDisplayImg.isHidden = true
                            self.loadFilesView.isHidden = false
                             let video  =  "\(WebServices.ARTICLE_BASE_URL)\(self.Dict["video"]!)"
                         
                            
                          /*
                            let player = AVPlayer(url: URL(string: video)!)
                            let playerLayer = AVPlayerLayer(player: player)
                            //playerLayer.player = player
                            playerLayer.frame = self.loadFilesView.bounds
                            self.loadFilesView.layer.addSublayer(playerLayer)
                            player.play()*/
                            
                            let player = AVPlayer(url: URL(string: video)!)
                            let avPlayerViewController = AVPlayerViewController()
                            avPlayerViewController.player = player

                            avPlayerViewController.view.frame = self.loadFilesView.frame
                            self.loadFilesView.addSubview(avPlayerViewController.view)
                            self.addChild(avPlayerViewController)

                            player.play()
                        }
                            
                        else if self.fileType == "4" {
//                            you tube video
                            imageContainer.isHidden = true
//                            self.articleDisplayImg.isHidden = true
                            self.loadFilesView.isHidden = false
                        let videoUrl: URL! = URL(string: self.Dict["url_link"] as! String)
                           
                            print(videoUrl!)
                            
                            let videoPlayer = YouTubePlayerView(frame: CGRect( x: 0, y: 0, width: self.loadFilesView.frame.size.width, height: self.loadFilesView.frame.size.height))

                            videoPlayer.loadVideoURL(videoUrl!)

                            self.loadFilesView.addSubview(videoPlayer)
                        }

                        else if self.fileType == "5"  || self.fileType == "6"  {
                            //ppt ,pdf
                            self.showInFullScreenBtn.isHidden = false
                            
                            imageContainer.isHidden = true
//                            self.articleDisplayImg.isHidden = true
                            self.loadFilesView.isHidden = false
                            
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
                            self.wkwebViewSamle?.frame = CGRect(origin: CGPoint.zero, size: self.loadFilesView.frame.size)
                            
                            let req = NSURLRequest(url:url)
                            self.wkwebViewSamle.load(req as URLRequest)
                                
                            //self.wkwebViewSamle.addGestureRecognizer(self.tap!)
                            //self.wkwebViewSamle.isUserInteractionEnabled = true
                            
                            self.loadFilesView.addSubview(self.wkwebViewSamle)

                        }
                        
                        
                        var quizDict = NSDictionary()
                        
                        self.Article_Quiz_Details = ( self.Dict["article_quiz_details"] as? [AnyObject]) != nil  ?  ( self.Dict["article_quiz_details"] as! [AnyObject]) : []

                      
                        if self.Article_Quiz_Details.count > 0 {
                            
                            self.quizView.isHidden = false
                            self.quizViewHeight.constant = 363
                            
                            quizDict = self.Article_Quiz_Details[0] as! NSDictionary
                        
                            self.quizQuestionLbl.text = quizDict["question"] as? String
                        
                        self.option1Lbl.text = quizDict["option1"] as? String
                        self.option2Lbl.text = quizDict["option2"] as? String
                        self.option3Lbl.text = quizDict["option3"] as? String
                        self.option4Lbl.text = quizDict["option4"] as? String
                        self.actualAnswer =  (quizDict["answer_key"] as? String)!
                            
                        }
                    }else{
                        self.showAlert(message: "No Article data found")
                    }
                }
            }
            self.view.StopLoading()
        }
    }
    
    func setupImages(_ images: [UIImage]){
        for i in 0..<images.count {
            let imageView = UIImageView()
            imageView.image = images[i]
            let xPosition = imageContainer.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: imageContainer.frame.width, height: imageContainer.frame.height)
            imageView.contentMode = .scaleAspectFill
            imageScrollView.contentSize.width = imageScrollView.frame.width * CGFloat(i + 1)
            imageScrollView.addSubview(imageView)
        }
    }
       
    func downloadImage(from url: URL) {
        print("Download Started")
        // Create Data Task
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                self?.imgArr.append(UIImage(data: data)!)
                print("Download Completed...")
                /* DispatchQueue.main.async {
                    // Create Image and Update Image View
//                    self?.imageView.image = UIImage(data: data)
                    self?.imgArr.append(UIImage(data: data)!)
                    
                }*/
            }
        }

        // Start Data Task
        dataTask.resume()
    
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    @IBAction func writeReview_Tapped(_ sender: Any) {
        
        
        
               let controller = self.storyboard?.instantiateViewController(withIdentifier: "WriteReviewViewController") as! WriteReviewViewController
            

            controller.articleId = articleId
        
               self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
   
    
                
           
            @IBOutlet var favBtn: UIButton!
               var favTag : Int = 0
               
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
                        
//                }
            }
            

    @objc func removeFromWishList() {
              
              
//              userId = UserDefaults.standard.object(forKey: "user_id") as? String
//
//              if userId == "" || userId == nil {
//                  self.showAlert(message: "Please login to Continue")
//              }
//              else{
                  
            
        
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
    
    
    @IBAction func submitAnswerTapped(_ sender: Any) {
        
        
        
        if selectedAnswer == actualAnswer {
            self.AnswerCheckImg.image = UIImage(named: "checkMark")
        }else{
            self.AnswerCheckImg.image = UIImage(named: "redRadiobutton")
        }
         self.AnswerCheckImg.isHidden = false
    }
    
    
    
    
    @IBOutlet var optionThree: UIButton!
    @IBOutlet var optionOne: UIButton!
    @IBOutlet var optionFour: UIButton!
    @IBOutlet var optionTwo: UIButton!
    
    
    @IBAction func optionOneTapped(_ sender: Any) {
        
    
        optionOne.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        selectedAnswer = self.option1Lbl.text!
        
     
    }
    
    @IBAction func optionTwoTapped(_ sender: Any) {
        
        optionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        selectedAnswer = self.option2Lbl.text!
        
        
        
        
    }
    
    @IBAction func optionThreeTapped(_ sender: Any) {
        
        optionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        selectedAnswer = self.option3Lbl.text!
    }
   
    
    @IBAction func optionFourTapped(_ sender: Any) {
        
        optionOne.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionTwo.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionThree.setImage(
            UIImage(named: "radioUncheck"),
            for: .normal)
        optionFour.setImage(
            UIImage(named: "radioCheck"),
            for: .normal)
        selectedAnswer = self.option4Lbl.text!
    }
    
    
    
    
    
    
    
    
    
    func showAlert(message:String)
             {
                 Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithOutSelector(Title: "Ok")], Controller: self)
             }
    
    
    func showAlertWithAction(message:String)
          {
     
            Message.shared.Alert(Title:APP_NAME, Message: message, TitleAlign: .normal, MessageAlign: .normal, Actions: [Message.AlertActionWithSelector(Title: "Ok", Selector:#selector(self.removeFromWishList), Controller: self),Message.AlertActionWithSelector(Title: "Cancel", Selector:#selector(cancelTapped), Controller: self)], Controller: self)
          }
    
    @objc func cancelTapped()
          {
            favTag = 1
            print("Cancel tapped...")
          }
         
    
    @IBAction func back_Tapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension ArticleDetailsViewController : QLPreviewControllerDataSource {
    
    func numberOfPreviewItemsInPreviewController(controller: QLPreviewController) -> Int {
                return fileURLs.count
            }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
                return fileURLs[index] as QLPreviewItem
            }

    @available(iOS 4.0, *)
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
                return fileURLs.count
            }
    
    func showMyDocPreview(currIndex:Int) {

        if fileURLs.count > 0 {
            if QLPreviewController.canPreview(fileURLs[currIndex] as QLPreviewItem) {
                quickLookController.currentPreviewItemIndex = currIndex
                navigationController?.pushViewController(quickLookController, animated: true)
            }else{
                print("cant peview the file....")
            }
        }
    }
}

extension ArticleDetailsViewController:  URLSessionDownloadDelegate {
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

