//
//  sideBarTableViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/22/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class sideBarTableViewController: UITableViewController {
    
    var titleArray: [String] = []
    
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadSidebar"), object: nil)
        
        self.clearsSelectionOnViewWillAppear = false
        
        tableView.separatorStyle = .none
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        titleArray = []
        tableView.reloadData()
    }
    
    
    
    //setting all the rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count + 5
    }
    
    
    
    //setting the cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addProjectCell", for: indexPath) as! AddProjectTableViewCell
            
            //cell customization
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "sideBarCell", for: indexPath) as! sideBarTableViewCell
            
                //today cell
            if indexPath.row == 1 {
                
                cell.iconImageView.image = UIImage(named: "todayIcon")
                cell.cellLabel.text = "Your day"
                titleArray.append("Your Day")
                cell.taskCount.text = "\(todayCount)"
                
                //this week cell
            } else if indexPath.row == 2 {
                
                cell.iconImageView.image = UIImage(named: "thisWeekIcon")
                cell.cellLabel.text = "Your week"
                titleArray.append("Your Week")
                cell.taskCount.text = "\(weekCount)"

                //all tasks cell
            } else if indexPath.row == 3 {
                
                cell.iconImageView.image = UIImage(named: "allTasksIcon")
                cell.cellLabel.text = "All tasks"
                titleArray.append("All Tasks")
                cell.taskCount.text = "\(taskClass.count)"
                
            } else if indexPath.row == 4 {
                
                cell.iconImageView.image = UIImage(named: "projectIcon")
                cell.cellLabel.text = "General"
                titleArray.append("General")
                cell.taskCount.text = "\(generalCount)"

                //project cells
            } else {
                
                let index = indexPath.row - 5
                
                cell.iconImageView.image = UIImage(named: "projectIcon")
                cell.cellLabel.text = projects[index].projectName
                titleArray.append(projects[index].projectName!)
                cell.taskCount.text = "\(projectCounts[index])"
            }

            return cell
        }
    }
    
    
    
    //segue to ViewController, we pass in usedView to indicate what we want to display
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTasks" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            usedView = indexPath.row
            pageTitle = titleArray[indexPath.row-1]
        }
            
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 71
        } else {
            return 55
        }
    }
    
    
    
    //function to reload tableVIew
    func loadList(notification: NSNotification) {
        tableView.reloadData()
    }


}
