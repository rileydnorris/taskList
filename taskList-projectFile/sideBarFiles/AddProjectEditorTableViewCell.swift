//
//  AddProjectEditorTableViewCell.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 7/5/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class AddProjectEditorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var projectNameTextField: UITextField!
    
    
    
    @IBAction func addProject(_ sender: Any) {
        
        //setting up coreData
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let project = Projects(context: context)
        
        //setting TaskData values
        project.projectName = projectNameTextField.text!
        project.dueDate = ""
        project.notes = ""
        project.remindDate = ""
        
        //saving to coreData
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        do {
            projects = try context.fetch(Projects.fetchRequest())
        } catch {
            print("Fetch failed")
        }
        
        //reloading the tableView
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSidebar"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadProjectEditor"), object: nil)
        
        projectCounts.append(0)
        projectNameTextField.text = ""
    }

}
