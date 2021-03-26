//
//  QuizQandACell.swift
//  Muknow
//
//  Created by Apple on 13/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit


protocol QuizQandACellDelegate : class {
    //    func openFile(selectedImg:UIImage,fileUrl:URL,alteredFileName:String)
    //    func downloadFile(url : URL,fileName : String,destinationUrl : URL,index : Int)
    //    func didFileNotFound(message : String)

    func submitTapped(index : Int)
    func refreshSecondCell()
}

class QuizQandACell: UITableViewCell {

    
    var index: Int = 0
    var section: Int = 0
    
    var delegate: QuizQandACellDelegate?
    @IBOutlet weak var quizQandAContainer: UIView!
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var answerImgView: UIImageView!
    
    
    @IBOutlet weak var option1Btn: UIButton!
    @IBOutlet weak var option2Btn: UIButton!
    @IBOutlet weak var option3Btn: UIButton!
    @IBOutlet weak var option4Btn: UIButton!
    
    @IBOutlet weak var option1Lbl: UILabel!
    @IBOutlet weak var option2Lbl: UILabel!
    @IBOutlet weak var option3Lbl: UILabel!
    @IBOutlet weak var option4Lbl: UILabel!
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var correctAnswerLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func doDefaultUI(){
        self.delegate?.refreshSecondCell()
    }
    
    
    @IBAction func optionBtnTapHandle(_ sender: UIButton) {
    }
    @IBAction func submitBtnTapped(_ sender: UIButton) {
        self.delegate?.submitTapped(index: sender.tag)
    }
}
