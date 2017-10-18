//
//  usedArrayInViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/24/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import Foundation


//class that we will use in viewcontroller.swift


class UsedArrayInViewController: NSObject {
    
    //properties of the tasks
    var taskName = ""
    var taskProject = ""
    var taskProjectSection = ""
    var taskDueDate = ""
    var taskNotes = ""
    var taskIsRemind = false
    var isChecked = false
    var isStarred = false
    
    //necessary indexes for variety of puroses later on
    var todaySectionIndex = 0
    var todayItemIndex = 0
    var tempIndex = 0
    var usedArrayIndex = 0
    
    init(name: String, project: String, section: String?, dueDate: String?, notes: String?, remind: Bool, checked: Bool, starred: Bool, itemIndex: Int, sectionIndex: Int) {
        
        taskName = name
        taskProject = project
        taskProjectSection = section!
        taskIsRemind = remind
        taskDueDate = dueDate!
        taskNotes = (notes)!
        isChecked = checked
        isStarred = starred
        todayItemIndex = itemIndex
        todaySectionIndex = sectionIndex
        
}


}
