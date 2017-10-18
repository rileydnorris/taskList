//
//  ViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/21/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit
import CoreData

var taskClass: [TaskData] = []
var projects: [Projects] = []
var usedArray = [UsedArrayInViewController]()
var projectSections: [String] = ["General"]
var projectCounts: [Int] = []
var usedView = 1
var todayCount = 0
var weekCount = 0
var generalCount = 0
var pageTitle = "Your Day"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    
    //outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    @IBOutlet weak var addTaskTextField: UITextField!
    @IBOutlet weak var addTaskButton: UIButton!
    @IBOutlet weak var pageTitleLabel: UILabel!
    @IBOutlet weak var addDateButtonOutlet: UIButton!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var addTaskView: UIView!
    
    //variables
    var usedProjects: [String] = []
    var tempCellArray: [Int] = []
    var itemNum = 0
    let datePicker = UIDatePicker()
    var tempDate = ""
    
    

    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadList()
        
        for _ in 0..<projects.count{
            projectCounts.append(0)
        }
        
        //notification for refreshing the tableview
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        //menu bar button item configuration
        menuBarButton.target = revealViewController()
        menuBarButton.action = (#selector(SWRevealViewController.revealToggle(_:)))
        
        //table view customization function
        setTableViewCustomization()
        
        //gesture recognizer
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //generating all arrays for data purposes
        for i in 1...projects.count+4 {
            generateArrays(index: i)
        }
        
        //creating date picker for quick task
        createDatePicker()
        createPickerToolbar()
        
        //editting the addTaskView
        editAddTaskView()
        self.addTaskTextField.delegate = self;
        dueDateTextField.tintColor = UIColor.clear
    }
    
    
    
    //what happens every time the view appears
    override func viewWillAppear(_ animated: Bool) {
        
        //setting nav bar to white, it's cleaner
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Avenir Next", size: 18)!]
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationItem.title = pageTitle
    }
    
    
    
    
    
    //TABLEVIEW FUNCTIONS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    
    
    
    
    //Setting the tableView customization options
    func setTableViewCustomization() {
        tableView.separatorStyle = .none
    }

    
    
    //number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        
        //some random things I want to reset everytime the tableview is reloaded
        view.endEditing(true)
        addTaskTextField.text = ""
        tempDate = ""
        dueDateTextField.background = #imageLiteral(resourceName: "quickTaskDateIcon")
    
        //grab corect usedArray
        generateArrays(index: usedView)
        
        return usedProjects.count
    }
    
    
    
    //number of rows per section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        itemNum=0
        
        //setting up the right number of cells per section
        if usedView == 1 || usedView == 2 || usedView == 3 {
            
            //for every cell in usedArray, check if it is part of the current project and add 1 to item num if it is
            for num in 0..<usedArray.count {
                if usedArray[num].taskProject == usedProjects[section] {
                    itemNum += 1
                }
            }
        } else {
            
            //for every cell in usedArray, check if it is part of the current project section and add 1 to itemNum if it is
            for num in 0..<usedArray.count {
                if usedArray[num].taskProjectSection == usedProjects[section] {
                    itemNum += 1
                }
            }
        }
        
        return itemNum
    }
    
    
    
    //setting up the tasks
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //creating a temp array of indexes of the correct tasks to display based on the current section/project
        tempCellArray = []
        
        if usedView == 1 || usedView == 2 || usedView == 3 {
            for num in 0..<usedArray.count {
                if usedArray[num].taskProject == usedProjects[indexPath.section] {
                    tempCellArray.append(num)
                    usedArray[num].todaySectionIndex = indexPath.section
                }
            }
        } else {
            for num in 0..<usedArray.count {
                if usedArray[num].taskProjectSection == usedProjects[indexPath.section] {
                    tempCellArray.append(num)
                    usedArray[num].todaySectionIndex = indexPath.section
                }
            }
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! todayTableViewCell
            
        cell.taskNameLabel.text = usedArray[tempCellArray[indexPath.row]].taskName
        cell.projectSectionLabel.text = usedArray[tempCellArray[indexPath.row]].taskProjectSection
        
        //button images
        if usedArray[tempCellArray[indexPath.row]].taskIsRemind == true {
            cell.alarmIcon.isHidden = false
        } else {
            cell.alarmIcon.isHidden = true
        }
            
        if usedArray[tempCellArray[indexPath.row]].isChecked == false {
            cell.checkBoxButtonOutlet.setImage(#imageLiteral(resourceName: "checkBoxOUTLINE"), for: UIControlState.normal)
        } else {
            cell.checkBoxButtonOutlet.setImage(#imageLiteral(resourceName: "checkBoxFILLED"), for: UIControlState.normal)
        }
            
        if usedArray[tempCellArray[indexPath.row]].isStarred == false {
            cell.starButtonOutlet.setImage(#imageLiteral(resourceName: "StarIconDeselected"), for: UIControlState.normal)
        } else {
            cell.starButtonOutlet.setImage(#imageLiteral(resourceName: "StarIconSelected"), for: UIControlState.normal)
        }
        
        //gathering necessary indexes for viewTaskViewController
        for i in 0..<taskClass.count {
            if taskClass[i].taskName == usedArray[tempCellArray[indexPath.row]].taskName {
                usedArray[tempCellArray[indexPath.row]].todayItemIndex = i
                break
            }
        }
        
        //used to help setup the segue to viewTaskViewController
        usedArray[tempCellArray[indexPath.row]].tempIndex = indexPath.row
        
        //used in the tableViewCell file
        cell.index = tempCellArray[indexPath.row]
        
        //cell customization
        cell.selectionStyle = .none
            
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editTask", sender: tableView)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    //segue to the edit task screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "editTask" {
            
            //grabbing the indexPath from the tableView
            let indexPath = tableView.indexPathForSelectedRow!
            let vc = segue.destination as! viewTaskViewController
            var index = 0
            
            //getting the correct usedArray object to pass to viewTaskViewController
            for item in 0..<usedArray.count {
                if usedArray[item].tempIndex == indexPath.row && usedArray[item].todaySectionIndex == indexPath.section {
                    index = item
                    break
                }
            }
            
            //passing values
            vc.taskName = usedArray[index].taskName
            vc.titleText = usedArray[index].taskName
            vc.dueDate = usedArray[index].taskDueDate
            vc.project = usedArray[index].taskProject
            vc.projectSection = usedArray[index].taskProjectSection
            vc.notes = usedArray[index].taskNotes
            vc.remindIsOn = usedArray[index].taskIsRemind
            vc.classIndex = index
            
        } else if segue.identifier == "detailTask" {
            
            let vc = segue.destination as! addTaskViewController
            vc.taskNamePassed = addTaskTextField.text!
            vc.dueDatePassed = tempDate
            
            if usedView >= 5 {
                vc.currentProject = projects[usedView-5].projectName!
            } else {
                vc.currentProject = "General"
            }
        }
        
    }
    
    
    
    //setting up the headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! todayHeaderCell
        headerCell.headerNameLabel.text = usedProjects[section]
        
        return headerCell.contentView
    }
    
    
    
    //setting header height, necessary for it to display
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
    //creating the footer so there's blank space after each section
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 15))
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    
    
    //setting footer size or it won't display
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 12.0
    }
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            
            //getting the correct task to delete
            for item in 0..<usedArray.count {
                if usedArray[item].tempIndex == indexPath.row && usedArray[item].todaySectionIndex == indexPath.section {
                    let task = taskClass[usedArray[item].todayItemIndex]
                    context.delete(task)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    loadList()
                    break

                }
            }
        }
    }
    
    
    
    //reload tableView function
    func loadList(){
        getCoreData()
        tableView.reloadData()
    }
    
    
    
    
    
    //GENERATING ARRAYS - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
    
    
    
    
    //super necessary arrays that create the usedArray based on the criteria from usedView
    func generateArrays(index: Int) {
        
        view.endEditing(true)
        addTaskTextField.text = ""
        usedArray = [UsedArrayInViewController]()
        usedProjects = []
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        let dateTime = formatter.string(from: date)
        
        
        //TODAY ||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        if index == 1 {
            
            //checking for the tasks that are due on the current date
            for i in 0..<taskClass.count {
                let taskDate = taskClass[i].taskDueDate!.components(separatedBy: ",")
                if taskDate[0] == dateTime {

                    usedArray.append(UsedArrayInViewController(name: taskClass[i].taskName!, project: taskClass[i].taskProject!, section: taskClass[i].taskProjectSection, dueDate: taskClass[i].taskDueDate, notes: taskClass[i].taskNotes, remind: taskClass[i].taskIsRemind, checked: taskClass[i].isChecked, starred: taskClass[i].isStarred, itemIndex: Int(taskClass[i].todayItemIndex), sectionIndex: Int(taskClass[i].todaySectionIndex)))
                    
                    //gathering only the needed projects
                    if !usedProjects.contains(taskClass[i].taskProject!) {
                        if taskClass[i].taskProject == "General" {
                            usedProjects.insert("General", at: 0)
                        } else {
                            usedProjects.append(taskClass[i].taskProject!)
                        }
                    }
                }
            }
            
            //setting todayCount for the side bar
            todayCount = usedArray.count
            
            
            
        //WEEK |||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        } else if index == 2 {
            
            //checking for the tasks due within the next week
            for i in 0..<taskClass.count {
                
                //CHANGE THIS
                
                let taskDateWithoutTime = taskClass[i].taskDueDate!.components(separatedBy: ",")
                let date = dateTime.components(separatedBy: ",")
                let dateTime = date[0].components(separatedBy: "/")
                let dayInt = Int(dateTime[1])!
                
                for x in 0...6 {
                    let realDate = "\(dateTime[0])/\(dayInt+x)/\(dateTime[2])"
                    
                    if taskDateWithoutTime[0] == realDate {
                        usedArray.append(UsedArrayInViewController(name: taskClass[i].taskName!, project: taskClass[i].taskProject!, section: taskClass[i].taskProjectSection, dueDate: taskClass[i].taskDueDate, notes: taskClass[i].taskNotes, remind: taskClass[i].taskIsRemind, checked: taskClass[i].isChecked, starred: taskClass[i].isStarred, itemIndex: Int(taskClass[i].todayItemIndex), sectionIndex: Int(taskClass[i].todaySectionIndex)))
                        
                        //gathering only the needed projects
                        if !usedProjects.contains(taskClass[i].taskProject!) {
                            if taskClass[i].taskProject == "General" {
                                usedProjects.insert("General", at: 0)
                            } else {
                                usedProjects.append(taskClass[i].taskProject!)
                            }
                        }
                    }
                }
            }

            //setting weekCount for the side bar
            weekCount = usedArray.count
            
            
            
        //ALL |||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        } else if index == 3 {
            
            //gathering all tasks to add to the usedArray
            for i in 0..<taskClass.count {
                usedArray.append(UsedArrayInViewController(name: taskClass[i].taskName!, project: taskClass[i].taskProject!, section: taskClass[i].taskProjectSection, dueDate: taskClass[i].taskDueDate, notes: taskClass[i].taskNotes, remind: taskClass[i].taskIsRemind, checked: taskClass[i].isChecked, starred: taskClass[i].isStarred, itemIndex: Int(taskClass[i].todayItemIndex), sectionIndex: Int(taskClass[i].todaySectionIndex)))
                
                //gathering only the needed projects
                if !usedProjects.contains(taskClass[i].taskProject!) {
                    if taskClass[i].taskProject == "General" {
                        usedProjects.insert("General", at: 0)
                    } else {
                        usedProjects.append(taskClass[i].taskProject!)
                    }
                }
            }
            
            
            
        //GENERAL |||||||||||||||||||||||||||||||||||||||||||||||||||||
        } else if index == 4 {
            
            for i in 0..<taskClass.count {
                if taskClass[i].taskProject == "General" {
                    usedArray.append(UsedArrayInViewController(name: taskClass[i].taskName!, project: taskClass[i].taskProject!, section: taskClass[i].taskProjectSection, dueDate: taskClass[i].taskDueDate, notes: taskClass[i].taskNotes, remind: taskClass[i].taskIsRemind, checked: taskClass[i].isChecked, starred: taskClass[i].isStarred, itemIndex: Int(taskClass[i].todayItemIndex), sectionIndex: Int(taskClass[i].todaySectionIndex)))
                    
                    //gathering only the needed projects
                    if !usedProjects.contains(taskClass[i].taskProjectSection!) {
                        if taskClass[i].taskProjectSection == "General" {
                            usedProjects.insert("General", at: 0)
                        } else {
                            usedProjects.append(taskClass[i].taskProjectSection!)
                        }
                    }
                }
            }
            generalCount = usedArray.count
            
            
            
        //PROJECTS |||||||||||||||||||||||||||||||||||||||||||||||||||||
        } else {
            
            //checking for the tasks needed for the current project that was selected through usedView
            for i in 0..<taskClass.count {
                if taskClass[i].taskProject! == projects[index-5].projectName {
                    usedArray.append(UsedArrayInViewController(name: taskClass[i].taskName!, project: taskClass[i].taskProject!, section: taskClass[i].taskProjectSection, dueDate: taskClass[i].taskDueDate, notes: taskClass[i].taskNotes, remind: taskClass[i].taskIsRemind, checked: taskClass[i].isChecked, starred: taskClass[i].isStarred, itemIndex: Int(taskClass[i].todayItemIndex), sectionIndex: Int(taskClass[i].todaySectionIndex)))
                    
                    //gathering only the needed projects
                    if !usedProjects.contains(taskClass[i].taskProjectSection!) {
                        if taskClass[i].taskProjectSection == "General" {
                            usedProjects.insert("General", at: 0)
                        } else {
                            usedProjects.append(taskClass[i].taskProjectSection!)
                        }
                    }
                }
            }
            projectCounts[index-5] = usedArray.count
        }
    }
    
    
    
    //fetching the data for taskClass
    func getCoreData() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            taskClass = try context.fetch(TaskData.fetchRequest())
            projects = try context.fetch(Projects.fetchRequest())
        } catch {
            print("Fetch failed")
        }
    }
}





//ALL QUICK TASK FUNCTIONALITY - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -





//All the quick task functionality
extension ViewController {
    
    
    
    //function to add a quick task
    @IBAction func addQuickTask(_ sender: Any) {
        
        if addTaskTextField.text != "" {
            
            //setting up coreData
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = TaskData(context: context)
            
            //setting TaskData values
            task.taskName = addTaskTextField.text!
            
            if usedView >= 5 {
                task.taskProject = projects[usedView-5].projectName
            } else {
                task.taskProject = "General"
            }

            task.taskProjectSection = "General"
            task.taskDueDate = tempDate
            task.taskNotes = ""
            task.taskIsRemind = false
            task.isChecked = false
            task.isStarred = false
            task.todayItemIndex = 0
            task.todaySectionIndex = 0
            
            //saving to coreData
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            addTaskTextField.text = ""
            tempDate = ""
            dueDateTextField.background = #imageLiteral(resourceName: "quickTaskDateIcon")
            getCoreData()
            tableView.reloadData()
        }
        
        view.endEditing(true)
    }
    
    
    
    //the button for adding a task with extra options
    @IBAction func detailAddTaskButton(_ sender: Any) {
        performSegue(withIdentifier: "detailTask", sender: sender)
    }
    
    
    
    //creating the date picker
    func createDatePicker() {
        
        dueDateTextField.inputView = datePicker
        datePicker.backgroundColor = UIColor.white
    }
    
    
    
    //creating the toolbar for the picker with the done button
    func createPickerToolbar() {
        let toolBar = UIToolbar()
        var doneButton = UIBarButtonItem()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTaskViewController.dismissDateKeyboard))
        
        toolBar.setItems([flexButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        toolBar.tintColor = UIColor.darkGray
        toolBar.barTintColor = UIColor.white
        toolBar.backgroundColor = UIColor.white
        toolBar.sizeToFit()
        
        dueDateTextField.inputAccessoryView = toolBar
        
    }
    
    
    
    //dimiss the date picker
    func dismissDateKeyboard() {
        view.endEditing(true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        dueDateTextField.background = #imageLiteral(resourceName: "thisWeekIcon")
        tempDate = dateFormatter.string(from: datePicker.date)
    }
    
    
    
    //editting the addTaskView to be purtty
    func editAddTaskView () {

        addTaskView.layer.shadowColor = UIColor.lightGray.cgColor
        addTaskView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        addTaskView.layer.shadowRadius = 1.0
        addTaskView.layer.shadowOpacity = 0.8
        addTaskView.layer.cornerRadius = 10
        
        let str = NSAttributedString(string: "Add a task...", attributes: [NSForegroundColorAttributeName:UIColor.white])
        addTaskTextField.attributedPlaceholder = str
        
        addTaskButton.tintColor = UIColor.white
    }
    
    
    
    
    
    
    
    //function closes the keyboard on "return" press
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

