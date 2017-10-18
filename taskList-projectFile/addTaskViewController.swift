//
//  addTaskViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 6/22/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit
import CoreData

class addTaskViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var projectTextField: UITextField!
    @IBOutlet weak var projectSectionTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var actualView: UIView!
    @IBOutlet weak var writeNotesView: UIView!
    @IBOutlet weak var addTaskView: UIView!
    @IBOutlet weak var addTaskButtonOutlet: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let datePicker = UIDatePicker()
    var usableProjectSections: [String] = []
    var currentProject = ""
    var selectedProject = ""
    var selectedProjectTask = ""
    var taskNamePassed = ""
    var dueDatePassed = ""

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        self.taskNameTextField.delegate = self;
        self.dueDateTextField.delegate = self;
        self.projectTextField.delegate = self;
        self.projectSectionTextField.delegate = self;
        self.notesTextView.delegate = self;
        
        //setting some text
        notesTextView.text = "Write down some notes, whether it be important information or just some general reminders you might forget. Don't worry, we don't judge."
        notesTextView.textColor = UIColor.lightGray
        taskNameTextField.text = taskNamePassed
        dueDateTextField.text = dueDatePassed
        
        writeNotesView.isHidden = true
        
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
        addTaskButtonOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        addTaskButtonOutlet.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        addTaskButtonOutlet.layer.shadowRadius = 1.0
        addTaskButtonOutlet.layer.shadowOpacity = 0.8
        addTaskButtonOutlet.layer.cornerRadius = 10
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextView.textColor == UIColor.lightGray {
            notesTextView.text = nil
            notesTextView.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextView.text.isEmpty {
            notesTextView.text = "Write down some notes, whether it be important information or just some general reminders you might forget. Don't worry, we don't judge."
            notesTextView.textColor = UIColor.lightGray
        }
    }
    
    
    
    @IBAction func viewPicker(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            addTaskView.isHidden = false
            writeNotesView.isHidden = true
        case 1:
            addTaskView.isHidden = true
            writeNotesView.isHidden = false
        default:
            break;
        }
    }
    
    //dismiss the view
    @IBAction func discardActionButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //add the todo with the current properties
    @IBAction func addTaskButtonAction(_ sender: Any) {
        
        if taskNameTextField.text != "" {
            
            if projectTextField.text == "" {
                projectTextField.text = "General"
            }
            if projectSectionTextField.text == "" {
                projectSectionTextField.text = "General"
            }
            
            //setting up coreData
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let task = TaskData(context: context)
            
            //setting TaskData values
            task.taskName = taskNameTextField.text!
            task.taskProject = projectTextField.text!
            task.taskProjectSection = projectSectionTextField.text!
            task.taskDueDate = dueDateTextField.text!
            task.taskNotes = notesTextView.text!
            task.taskIsRemind = remindSwitch.isOn
            task.isChecked = false
            task.isStarred = false
            task.todayItemIndex = 0
            task.todaySectionIndex = 0
            
            //saving to coreData
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "loadSidebar"), object: nil)
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    //add an attachment
    @IBAction func addAttachmentAction(_ sender: Any) {
        
    }

    
    
    //creating the pickers
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
        
        //if we're creating datePicker toolbar, it is a different function
        if item == 3 {
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTaskViewController.dismissDateKeyboard))
        } else {
            doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(addTaskViewController.dismissKeyboard))
        }
        
        toolBar.setItems([flexButton,doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        toolBar.barTintColor = UIColor.white
        toolBar.tintColor = UIColor.darkGray
        
        if item == 1 {
            projectTextField.inputAccessoryView = toolBar
        } else if item == 2 {
            projectSectionTextField.inputAccessoryView = toolBar
        } else {
            dueDateTextField.inputAccessoryView = toolBar
        }
    }
    
    
    
    //dismiss any keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //dismiss the date picker
    func dismissDateKeyboard() {
        view.endEditing(true)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        dueDateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    
    
    //creating the date picker
    func createDatePicker() {
        dueDateTextField.inputView = datePicker
        
        datePicker.backgroundColor = UIColor.white
    }
    
}



//an extension for the picker delegates
extension addTaskViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    
    //number of sections in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    //setting number of rows in the picker, dependant on project picker or project section picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if pickerView.tag == 1 {
            return projects.count + 1
        } else {
            
            for i in 0..<taskClass.count {
                if taskClass[i].taskProject == projectTextField.text! {
                    usableProjectSections.append(taskClass[i].taskProjectSection!)
                }
            }
            
            return usableProjectSections.count
        }
        
    }
    
    
    
    //setting picker values, projects or project sections
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            
            if row == 0 {
                return "General"
            } else {
                return projects[row-1].projectName
            }
            
        } else {
            return usableProjectSections[row]
        }
    }
    
    
    
    //setting values if picker selects something
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
            
            selectedProjectTask = usableProjectSections[row]
            projectSectionTextField.text = selectedProjectTask
        }
    }
}
