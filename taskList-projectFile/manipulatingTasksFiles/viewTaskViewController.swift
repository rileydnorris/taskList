//
//  viewTaskViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/22/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class viewTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var projectSectionTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var actualView: UIView!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var starOutlet: UIButton!
    @IBOutlet weak var editTaskButton: UIButton!
    @IBOutlet weak var editTaskView: UIView!
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var notesTextView: UITextView!
    
    var titleText = ""
    var taskName = ""
    var project = ""
    var projectSection = ""
    var dueDate = ""
    var notes = ""
    var remindIsOn = false
    var classIndex = 0
    let datePicker = UIDatePicker()
    var selectedProject = ""
    var selectedProjectTask = ""
    var isChecked = false
    var isStarred = false
    
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        self.taskNameTextField.delegate = self;
        self.dueDateTextField.delegate = self;
        self.projectTextField.delegate = self;
        self.projectSectionTextField.delegate = self;
        self.notesTextView.delegate = self;

        
        //setting text
        titleLabel.text = titleText
        taskNameTextField.text = taskName
        projectTextField.text = project
        projectSectionTextField.text = projectSection
        dueDateTextField.text = dueDate
        notesTextView.text = notes
        remindSwitch.isOn = remindIsOn
        
        if notes == "" {
            let defaultNote = "Write down some notes, whether it be important information or just some general reminders."
            let style = NSMutableParagraphStyle()
            style.lineSpacing = 10
            let attributes = [NSAttributedStringKey.paragraphStyle : style]
            notesTextView.attributedText = NSAttributedString(string: defaultNote, attributes: attributes)
            notesTextView.font = UIFont.systemFont(ofSize: 15, weight: .light)
            notesTextView.textColor = UIColor.lightGray
        } else {
            notesTextView.text = notes
        }
        
        //setting values for buttons on top
        if taskClass[usedArray[classIndex].todayItemIndex].isChecked {
            checkBoxOutlet.setImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: UIControlState.normal)
            isChecked = true
        } else {
            checkBoxOutlet.setImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControlState.normal)
            isChecked = false
        }
        
        if taskClass[usedArray[classIndex].todayItemIndex].isStarred {
            starOutlet.setImage(#imageLiteral(resourceName: "StarIconSelected "), for: UIControlState.normal)
            isStarred = true
        } else {
            starOutlet.setImage(#imageLiteral(resourceName: "StarIconDeselected "), for: UIControlState.normal)
            isStarred = false
        }
        
        //project picker
        createPicker(item: 1)
        createPickerToolbar(item: 1)
        
        //project task picker
        createPicker(item: 2)
        createPickerToolbar(item: 2)
        
        //date picker
        createDatePicker()
        createPickerToolbar(item: 3)
        
        //customizing the view
        actualView.layer.shadowRadius = 20
        actualView.layer.cornerRadius = 10
        actualView.layer.shadowColor = UIColor.darkGray.cgColor
        actualView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        actualView.layer.shadowRadius = 2.0
        actualView.layer.shadowOpacity = 1.0
        
        //editting the add button
        editTaskButton.layer.shadowColor = UIColor.lightGray.cgColor
        editTaskButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        editTaskButton.layer.shadowRadius = 1.0
        editTaskButton.layer.shadowOpacity = 0.8
        editTaskButton.layer.cornerRadius = 10
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == UIColor.lightGray {
            notesTextView.text = nil
            notesTextView.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text.isEmpty {
            notesTextView.text = "Write down some notes, whether it be important information or just some reminders."
            notesTextView.textColor = UIColor.lightGray
        }
    }
    
    
    
    @IBAction func pickView(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            editTaskView.isHidden = false
            notesView.isHidden = true
        case 1:
            editTaskView.isHidden = true
            notesView.isHidden = false
        default:
            break;
        }

    }
    
    

    //discard the chanes and close window
    @IBAction func discardButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //make change to the task and dismiss view
    @IBAction func editTaskButtonAction(_ sender: Any) {
        if taskNameTextField.text != "" {
            //setting project and project section if nothing is selected
            if projectTextField.text == "" {
                projectTextField.text = "General"
            }
            if projectSectionTextField.text == "" {
                projectSectionTextField.text = "General"
            }
            
            //setting up coreData
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            //updating values
            taskClass[usedArray[classIndex].todayItemIndex].taskName = taskNameTextField.text!
            taskClass[usedArray[classIndex].todayItemIndex].taskProject = projectTextField.text!
            taskClass[usedArray[classIndex].todayItemIndex].taskProjectSection = projectSectionTextField.text!
            taskClass[usedArray[classIndex].todayItemIndex].taskDueDate = dueDateTextField.text!
            taskClass[usedArray[classIndex].todayItemIndex].taskDueDateObject = datePicker.date
            taskClass[usedArray[classIndex].todayItemIndex].taskNotes = notesTextView.text!
            taskClass[usedArray[classIndex].todayItemIndex].taskIsRemind = remindSwitch.isOn
            taskClass[usedArray[classIndex].todayItemIndex].isChecked = isChecked
            taskClass[usedArray[classIndex].todayItemIndex].isStarred = isStarred
            
            //saving updated values to coreData
            appDelegate.saveContext()
            
            //reloading the tableView in ViewController
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            
            //dismiss view
            dismiss(animated: true, completion: nil)
        }
    }


    
    //ccreating the pickers
    func createPicker(item: Int) {
        
        let picker = UIPickerView()
        picker.delegate = self
        
        //item 1 = project and item 2 = project task
        if item == 1 {
            picker.tag = 1
            projectTextField.inputView = picker
        } else {
            picker.tag = 2
            projectSectionTextField.inputView = picker
        }
        
        //customization
        picker.backgroundColor = UIColor.white
        
    }
    
    
    
    //creating the toolbar for the picker with the done button
    func createPickerToolbar(item: Int) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        var doneButton = UIBarButtonItem()
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        //if the toolbar is for the date picker we need a different function to be called
        if item == 3 {
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(viewTaskViewController.dismissDateKeyboard))
        } else {
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(viewTaskViewController.dismissKeyboard))
        }
        
        toolBar.setItems([flexButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        toolBar.barTintColor = UIColor.white
        toolBar.tintColor = UIColor.darkGray
        
        if item == 1 {
            projectTextField.inputAccessoryView = toolBar
            taskNameTextField.inputAccessoryView = toolBar
            notesTextView.inputAccessoryView = toolBar
        } else if item == 2 {
            projectSectionTextField.inputAccessoryView = toolBar
        } else {
            dueDateTextField.inputAccessoryView = toolBar
        }
    }
    
    
    
    //dimiss any keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //dimiss the date picker
    @objc func dismissDateKeyboard() {
        view.endEditing(true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        dueDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    
    //action for the checkBox
    @IBAction func checkBoxButtonAction(_ sender: Any) {
        if isChecked {
            checkBoxOutlet.setImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControlState.normal)
            isChecked = false
        } else {
            checkBoxOutlet.setImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: UIControlState.normal)
            isChecked = true
        }
    }

    
    
    //action for the star
    @IBAction func starButtonAction(_ sender: Any) {
        if isStarred {
            starOutlet.setImage(#imageLiteral(resourceName: "StarIconDeselected "), for: UIControlState.normal)
            isStarred = false
        } else {
            starOutlet.setImage(#imageLiteral(resourceName: "StarIconSelected "), for: UIControlState.normal)
            isStarred = true
            
        }
    }
    
    
    
    //creating the date picker
    func createDatePicker() {
        dueDateTextField.inputView = datePicker
        
        datePicker.backgroundColor = UIColor.white
    }
}



//extending the viewTaskViewController with picker delegates
extension viewTaskViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    //number of sections in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    //number of rows in the pickers based on tag for project or project section
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return projects.count + 1
        } else {
            return projectSections.count
        }
        
    }
    
    
    
    //setting values for pickers based on tag for project of project section
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView.tag == 1 {
            
            if row == 0 {
                return "General"
            } else {
                return projects[row-1].projectName
            }
            
        } else {
            return projectSections[row]                                 //NEED TO CHANGE
        }
    }
    
    
    
    //setting values when picker selects something
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            
            if row == 0 {
                selectedProject = "General"
                projectTextField.text = selectedProject
            } else {
                selectedProject = projects[row-1].projectName!
                projectTextField.text = selectedProject
            }

        } else {
            
            selectedProjectTask = projectSections[row]
            projectSectionTextField.text = selectedProjectTask
        }
    }

    
}
