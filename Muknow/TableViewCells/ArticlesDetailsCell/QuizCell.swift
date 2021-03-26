//
//  QuizCell.swift
//  Muknow
//
//  Created by Apple on 13/11/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol QuizCellDelegate : class {
    
}
class QuizCell: UITableViewCell {

    var delegate: QuizCellDelegate?
    @IBOutlet weak var testLbl: UILabel!
    @IBOutlet weak var quizTV: UITableView!
    
    var dataDict : NSDictionary!
    var Article_Quiz_Details = [AnyObject]()
    var quizDict = NSDictionary()
    
    var index: Int = 0
    var section: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        TheContainerTV.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCellID" )
        quizTV.register(UINib(nibName: "QuizQandACell", bundle: nil), forCellReuseIdentifier: "QuizQandACellID")
       
        self.quizTV!.estimatedRowHeight = 1000
        self.quizTV.delegate = self
        self.quizTV.dataSource = self
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func doDefaultUI(){
        if self.dataDict != nil {
            self.Article_Quiz_Details = ( self.dataDict["article_quiz_details"] as? [AnyObject]) != nil  ?  ( self.dataDict["article_quiz_details"] as! [AnyObject]) : []
        }
        
    }
    
    func reloadQuizTV()
    {
        self.quizTV.reloadData()
    }
    
}
extension QuizCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Article_Quiz_Details.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizQandACellID", for: indexPath) as! QuizQandACell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.delegate = self
        
        cell.index = index
        cell.section = section
        cell.answerImgView.isHidden = true

            self.quizDict = self.Article_Quiz_Details[indexPath.row] as! NSDictionary
            
            cell.questionLbl.text = quizDict["question"] as? String
            cell.option1Lbl.text = quizDict["option1"] as? String
            cell.option2Lbl.text = quizDict["option2"] as? String
            cell.option3Lbl.text = quizDict["option3"] as? String
            cell.option4Lbl.text = quizDict["option4"] as? String
            
            cell.submitBtn.tag = indexPath.row
        
//            self.actualAnswer =  (quizDict["answer_key"] as? String)!


        
        return cell
    }
    
    
}
extension QuizCell : QuizQandACellDelegate{
    func refreshSecondCell() {
        
    }
    
    func submitTapped(index: Int) {
        print("submitBtn index = :",index)
//        self.quizTV.reloadRows(at: [index], with: .none)
    }
    
    
}
