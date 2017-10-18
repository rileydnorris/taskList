//
//  AddProjectTableViewCell.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/30/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class AddProjectTableViewCell: UITableViewCell {

    @IBOutlet weak var addProjectTextField: UITextField!
    
    
    @IBAction func editButtonAction(_ sender: Any) {
        
    }
    
    
    
    @IBAction func addProjectButtonAction(_ sender: Any) {
        
        //setting up coreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let project = Projects(context: context)
        
        //setting TaskData values
        project.projectName = addProjectTextField.text!
        
        //saving to coreData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        //reloading the tableView
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSidebar"), object: nil)
        
        projectCounts.append(0)
        addProjectTextField.text = ""
    }

}
