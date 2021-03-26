//
//  RatingCell.swift
//  Muknow
//
//  Created by Apple on 12/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


protocol RatingCellDelegate : class {
//    func openFile(selectedImg:UIImage,fileUrl:URL,alteredFileName:String)
//    func downloadFile(url : URL,fileName : String,destinationUrl : URL,index : Int)
//    func didFileNotFound(message : String)
    
    func openWriteReviewVC(articleId : Int)
    func openRatingVC(articleId : Int)
}

class RatingCell: UITableViewCell {
    
    var delegate: RatingCellDelegate?
    
    @IBOutlet var articleNameLbl: UILabel!
    @IBOutlet var authorName: UILabel!
    
    @IBOutlet var ratingView: FloatRatingView!

    var articleId : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func ratingBtnTapped(_ sender: UIButton) {
        self.delegate?.openRatingVC(articleId: self.articleId!)
    }
    
    @IBAction func writeReviewBtnTapped(_ sender: UIButton) {
        self.delegate?.openWriteReviewVC(articleId: self.articleId!)
    }
}
