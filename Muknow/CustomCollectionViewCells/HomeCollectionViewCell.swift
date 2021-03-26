//
//  HomeCollectionViewCell.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    //Objects For Featured courses
    @IBOutlet weak var imgFeatured: UIImageView!
    @IBOutlet weak var featuredTagName: UILabel!
 
    @IBOutlet var featuredPrice: UILabel!
    @IBOutlet var featuredSFC: UILabel!
    
    @IBOutlet var featuredWSQ: UILabel!
    
    @IBOutlet var featuredIsLearning: UILabel!
    
    
    
    //Objects For popular courses
    @IBOutlet weak internal var imgPopular: UIImageView!
    @IBOutlet weak internal var popularTagName: UILabel!
    
    @IBOutlet var popularPrice: UILabel!
   
    @IBOutlet var popularSFC: UILabel!
      
      @IBOutlet var popularWSQ: UILabel!
    
    @IBOutlet var popularElearning: UILabel!
    
    
    
      //Objects For latest courses
      @IBOutlet weak internal var imglatestCourses: UIImageView!
      @IBOutlet weak internal var latestCourseTagName: UILabel!
    
    @IBOutlet var latestPrice: UILabel!
   
    @IBOutlet var latestSFC: UILabel!
      
      @IBOutlet var latestWSQ: UILabel!
    
    @IBOutlet var latestElearning: UILabel!
    
       //Objects For Favourite courses
    
    @IBOutlet var favouritesImg: UIImageView!
    
    @IBOutlet var favouritesPrice: UILabel!
    
    @IBOutlet var favouriteTitle: UILabel!
    
    
    // Objects for lessions List
    
    @IBOutlet var lessionImg: UIImageView!
    @IBOutlet var lessionTitle: UILabel!
    @IBOutlet var lessonsPriceLbl: UILabel!
    
    // Objects for LGW search COllection
    
    @IBOutlet var LessionsImg: UIImageView!
    @IBOutlet var LessionsTitleLbl: UILabel!
    @IBOutlet var LessonsPrice: UILabel!
    
    @IBOutlet var searchElearning: UILabel!
    
    @IBOutlet var searchWSQ: UILabel!
    
    @IBOutlet var searchSFC: UILabel!
    
    
    // Objects for Smiles search COllection
    
    @IBOutlet var ArticlesImg: UIImageView!
    @IBOutlet var ArticleTitleLbl: UILabel!
    @IBOutlet var ArticlePrice: UILabel!
    
    
    // Objects for wish list collection
    
    @IBOutlet var wishListImg: UIImageView!
    @IBOutlet var wishedItemName: UILabel!
    @IBOutlet var wishedPrice: UILabel!
    @IBOutlet var wishSfc: UILabel!
    @IBOutlet var wishWSQ: UILabel!
    @IBOutlet var wishLearning: UILabel!
    
    @IBOutlet var deleteFavBtn: UIButton!
    
}
