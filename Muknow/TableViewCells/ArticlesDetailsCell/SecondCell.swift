//
//  SecondCell.swift
//  Muknow
//
//  Created by Apple on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol SecondCellDelegate : class {
//    func openFile(selectedImg:UIImage,fileUrl:URL,alteredFileName:String)
//    func downloadFile(url : URL,fileName : String,destinationUrl : URL,index : Int)
//    func didFileNotFound(message : String)
    func refreshSecondCell(row:Int,section:Int)
    func viewInFullScreen()
}

class SecondCell: UITableViewCell {

    var delegate: SecondCellDelegate?
    
    @IBOutlet weak var lContainerView: UIView!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var loadView: UIView!
    @IBOutlet weak var articleImgView: UIImageView!
    
    @IBOutlet weak var viewFullScreenBtn: UIButton!
    
    var section: Int = 0
    var row: Int = 0
    
//    @IBOutlet weak var containerView: UIView!
//    @IBOutlet weak var myScrollView: UIScrollView!
    
    var articlesImgArr = [String]()
    
    @IBOutlet weak var multiImgCV: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.multiImgCV.dataSource = self
                self.multiImgCV.delegate = self
        
                self.multiImgCV.register(UINib.init(nibName: "MultiImgCVCell", bundle: nil), forCellWithReuseIdentifier: "MultiImgCVCellID")
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /*
    override func layoutSubviews() {
        print("lContainer frame = ",self.lContainerView.frame)
        print("loadView frame = ",self.loadView.frame)
        print("articleImgView Frame = ",self.articleImgView.frame)
        print("viewFullScreenBtn Frame",self.viewFullScreenBtn.frame)
        
    } */
    
    func doDefaultUI(){
        self.multiImgCV.delegate = self
        self.multiImgCV.dataSource = self
        //self.delegate?.refreshSecondCell(row: self.row, section: self.section)
    }
    /*
    func setupImages(imageURLs: [String]){
        for i in 0..<imageURLs.count {
            let imageView = UIImageView()
            
            imageView.sd_setImage(with: URL(string: imageURLs[i]), placeholderImage: UIImage(named: "PlaceholderImg"))
//            imageView.image = images[i]

            let xPosition = containerView.bounds.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: containerView.frame.width, height: containerView.frame.height)
            imageView.contentMode = .scaleAspectFill
            myScrollView.contentSize.width = myScrollView.frame.width * CGFloat(i + 1)
            myScrollView.addSubview(imageView)
        }
    } */
    
    @IBAction func viewInFullScreenBtnTapped(_ sender: UIButton) {
        self.delegate?.viewInFullScreen()
    }
}
//extension SecondCell : UIScrollViewDelegate {
//
//}


extension SecondCell : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.articlesImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiImgCVCellID", for: indexPath as IndexPath) as! MultiImgCVCell
        
        
        cell.articlesImgView.sd_setImage(with: URL(string: self.articlesImgArr[indexPath.row]), placeholderImage: UIImage(named: "PlaceholderImg"))
        cell.articlesImgView.contentMode = .scaleAspectFill
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.multiImgCV.frame.size
    }
    

}
