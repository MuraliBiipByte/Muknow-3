//
//  MicroLearningCategoriesVC.swift
//  Muknow
//
//  Created by Admin on 21/02/2018 .
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class MicroLearningCategoriesVC: UIViewController,UITableViewDataSource,UITableViewDelegate,ExpandableHeaderViewDelegate {


    @IBOutlet var tableView: UITableView!
    
    var sections = [Section(genre:"Leaderships",movies:["Business Decisions                          Models","Roles of Leaders"],expanded:false),
                    
                    Section(genre:"Trible Policy",movies:["The Lion King","The Incredibles"],expanded:false),
                    
                    Section(genre:"Productivity",movies:["The Lion King","The Incredibles","The Incredibles"],expanded:false),
                    
                    Section(genre:"Innovation Team",movies:["The Lion King","The Incredibles","The Incredibles"],expanded:false),
                    
                    Section(genre:"Enterprises",movies:["The Lion King","The Incredibles","The Incredibles"],expanded:false),
                    
                    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            
            return 44
            
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].genre, section: section, delegate: self)
        
        //        let imageName = "rightArrow"
        //
        //        image = UIImage(named: imageName)!
        //        let imageView = UIImageView(image: image)
        //        Finally you'll need to give imageView a frame and add it your view for it to be visible:
        //
        //        imageView.frame = CGRect(x: 330, y: 5, width: 30, height: 30)
        //        header.addSubview(imageView)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
        cell.textLabel?.text = sections[indexPath.section].movies[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        tableView.beginUpdates()
        
        for i in 0 ..< sections[section].movies.count
        {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        
        tableView.endUpdates()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SampleViewController") as! SampleViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}
