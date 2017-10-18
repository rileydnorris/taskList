//
//  ProjectEditorTableViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 7/5/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class ProjectEditorTableViewController: UITableViewController {

    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //menu bar button item configuration
        menuBarButton.target = revealViewController()
        menuBarButton.action = (#selector(SWRevealViewController.revealToggle(_:)))
        
        //gesture recognizer
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "loadProjectEditor"), object: nil)
        
        tableView.separatorStyle = .none
    }
    
    
    
    //what happens every time the view appears
    override func viewWillAppear(_ animated: Bool) {
        
        //setting nav bar to white, it's cleaner
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!]
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        
        self.navigationItem.title = "Edit Projects"
    }

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count+1
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addProject", for: indexPath) as! AddProjectEditorTableViewCell
            
            //cell customization
            cell.selectionStyle = .none
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "projectCell", for: indexPath) as! ProjectEditorTableViewCell

                
            let index = indexPath.row - 1
                
            cell.projectIcon.image = UIImage(named: "projectIcon")
            cell.projectName.text = projects[index].projectName
            cell.projectCount.text = "\(projectCounts[index])"
            
            //cell customization
            cell.selectionStyle = .none

            return cell
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 60
        } else {
            return 60
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */


    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            for i in 0..<taskClass.count {
                if taskClass[i].taskProject! == projects[indexPath.row-1].projectName {
                    context.delete(taskClass[i])
                }
            }
            context.delete(projects[indexPath.row-1])
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                taskClass = try context.fetch(TaskData.fetchRequest())
                projects = try context.fetch(Projects.fetchRequest())
            } catch {
                print("Fetch failed")
            }

            
            //reloading the tableView
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSidebar"), object: nil)
            tableView.reloadData()
        }
    }
    
    
    
    func loadList() {
        tableView.reloadData()
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentProjectDetails" {
            
            let vc = segue.destination as! EditProjectViewController
            let index = tableView.indexPathForSelectedRow!
            
            vc.projectName = projects[index.row-1].projectName!
            vc.dueDate = projects[index.row-1].dueDate!
            vc.notes = projects[index.row-1].notes!
            vc.remindDate = projects[index.row-1].remindDate!
            
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
