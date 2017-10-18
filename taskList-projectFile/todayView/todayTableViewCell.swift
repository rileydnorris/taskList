//
//  todayTableViewCell.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/21/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class todayTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBoxButtonOutlet: UIButton!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var alarmIcon: UIImageView!
    @IBOutlet weak var starButtonOutlet: UIButton!
    @IBOutlet weak var projectSectionLabel: UILabel!
    
    var index = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    //action for the checkBox
    @IBAction func checkBoxAction(_ sender: Any) {
        if !usedArray[index].isChecked {
            
            checkBoxButtonOutlet.setImage(#imageLiteral(resourceName: "checkBoxFILLED"), for: UIControlState.normal)
            taskClass[usedArray[index].todayItemIndex].isChecked = true
            usedArray[index].isChecked = true
            appDelegate.saveContext()
            
        } else {
            
            checkBoxButtonOutlet.setImage(#imageLiteral(resourceName: "checkBoxOUTLINE"), for: UIControlState.normal)
            taskClass[usedArray[index].todayItemIndex].isChecked = false
            usedArray[index].isChecked = false
            appDelegate.saveContext()
        }

    }
    
    
    
    //action for the star
    @IBAction func starAction(_ sender: Any) {
        if !usedArray[index].isStarred {
            
            starButtonOutlet.setImage(#imageLiteral(resourceName: "StarIconSelected"), for: UIControlState.normal)
            taskClass[usedArray[index].todayItemIndex].isStarred = true
            usedArray[index].isStarred = true
            appDelegate.saveContext()
            
        } else {
            
            starButtonOutlet.setImage(#imageLiteral(resourceName: "StarIconDeselected"), for: UIControlState.normal)
            taskClass[usedArray[index].todayItemIndex].isStarred = false
            usedArray[index].isStarred = false
            appDelegate.saveContext()
        }
    }
    
    



}
