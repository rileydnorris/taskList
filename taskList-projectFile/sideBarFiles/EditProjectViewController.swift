//
//  EditProjectViewController.swift
//  taskList-projectFile
//
//  Created by Riley Norris on 7/8/17.
//  Copyright © 2017 Riley Norris. All rights reserved.
//

import UIKit

class EditProjectViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var remindSwitch: UISwitch!
    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var editProjectView: UIView!
    @IBOutlet weak var writeNotesView: UIView!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var actualView: UIView!
    @IBOutlet weak var editProjectOutlet: UIButton!
    
    var projectName = ""
    var notes = ""
    var dueDate = ""
    var isRemind = false
    var remindDate = ""
    var projectIndex = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegates
        self.nameTextField.delegate = self;
        self.dueDateTextField.delegate = self;
        //self.notesTextField.delegate = self;
        
        writeNotesView.isHidden = true
        
        nameTextField.text = projectName
        if notesTextField.text == "" {
            //setting some text
            notesTextField.text = "Write down some notes, whether it be important information or just some general reminders you might forget. Don't worry, we don't judge."
            notesTextField.textColor = UIColor.lightGray
        } else {
            notesTextField.text = notes
        }
        dueDateTextField.text = dueDate
        remindSwitch.isOn = isRemind
        projectNameLabel.text = projectName
        
        //customizing the view
        actualView.layer.shadowRadius = 20
        actualView.layer.cornerRadius = 10
        actualView.layer.shadowColor = UIColor.darkGray.cgColor
        actualView.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        actualView.layer.shadowRadius = 2.0
        actualView.layer.shadowOpacity = 1.0
        
        //editting the add button
        editProjectOutlet.layer.shadowColor = UIColor.lightGray.cgColor
        editProjectOutlet.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        editProjectOutlet.layer.shadowRadius = 1.0
        editProjectOutlet.layer.shadowOpacity = 0.8
        editProjectOutlet.layer.cornerRadius = 10

    }
    
    
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            editProjectView.isHidden = false
            writeNotesView.isHidden = true
        case 1:
            editProjectView.isHidden = true
            writeNotesView.isHidden = false
        default:
            break;
        }
    }
    
    
    
    @IBAction func editProjectAction(_ sender: Any) {
        
        for i in 0..<projects.count {
            if projects[i].projectName == projectName {
                projectIndex = i
            }
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        projects[projectIndex].projectName = nameTextField.text!
        projects[projectIndex].dueDate = dueDateTextField.text!
        projects[projectIndex].notes = notesTextField.text!
        projects[projectIndex].remindDate = ""
        
        appDelegate.saveContext()
        
        //reloading the tableView in ViewController
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
        
        //dismiss view
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //setting the textView default text, and changing it when it begins editing
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesTextField.textColor == UIColor.lightGray {
            notesTextField.text = nil
            notesTextField.textColor = UIColor.black
        }
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesTextField.text.isEmpty {
            notesTextField.text = "Write down some notes, whether it be important information or just some general reminders you might forget. Don't worry, we don't judge."
            notesTextField.textColor = UIColor.lightGray
        }
    }

    
    

    @IBAction func discardViewAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
