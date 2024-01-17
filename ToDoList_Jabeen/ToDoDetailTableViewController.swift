//
//  ToDoDetailTableViewController.swift
//  ToDoList_Jabeen
//  Created by Syeda Jabeen on 11/01/23.
//

import Foundation
import UIKit

class ToDoDetailTableViewController: UITableViewController {
    
    var toDo: ToDo?
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var isCompletionButton: UIButton!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    // defines a function that updates the state of a "Save" button. It checks if a text field (probably for a title) is empty. If not, it enables the "Save" button; otherwise, it disables it.
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
   // This code sets a label (dueDateLabel) to display a formatted date including month, day, year, hour, and minute.
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = date.formatted(.dateTime.month(.defaultDigits)
            .day().year(.twoDigits).hour().minute())
    }
    // sets up a to-do list view. If there's an existing to-do item, it displays its details; otherwise, it sets default values. It includes UI updates for title, completion status, due date, and notes.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDueDate: Date
            if let toDo = toDo 
        {
              navigationItem.title = "To-Do"
              titleTextField.text = toDo.title
              isCompletionButton.isSelected = toDo.isComplete
              currentDueDate = toDo.dueDate
              notesTextView.text = toDo.notes
                
        }
            else
            {
              currentDueDate = Date()
                    //.addingTimeInterval(24*60*60)
            }
                
            dueDatePickerView.date = currentDueDate
        
            updateDueDateLabel(date: currentDueDate)

            updateSaveButtonState()
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        
        updateSaveButtonState()
    }
    @IBAction func returnPressed(_ sender: UITextField) {
        
        sender.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        isCompletionButton.isSelected.toggle()
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: sender.date)
    }
    
    var isDatePickerHidden = true
    
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    
    //it dynamically adjusts the row height based on whether a date picker or notes are visible, and uses default height for other rows.
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == false:
            return 216
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    //when the user taps a row, it handles the visibility of a date picker and updates the UI accordingly.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            updateDueDateLabel(date: dueDatePickerView.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // this code prepares and updates the data (to-do item) before saving or transitioning to another view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
        let isComplete = isCompletionButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
    
        if toDo != nil {
                toDo?.title = title
                toDo?.isComplete = isComplete
                toDo?.dueDate = dueDate
                toDo?.notes = notes
            } else {
                toDo = ToDo(title: title, isComplete: isComplete,
                   dueDate: dueDate, notes: notes)
                return
        }
    }
}

