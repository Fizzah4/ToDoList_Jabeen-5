//
//  ToDoTableViewController.swift
//  ToDoList_Jabeen
//  Created by Syeda Jabeen on 11/01/23.
//

import Foundation
import UIKit

//this code sets up a view controller for displaying a to-do list. It loads existing to-do items if available, or uses sample to-do items if none exist.

class ToDoTableViewController: UITableViewController, ToDoCellDelegate

{
    var toDos = [ToDo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let savedToDos = ToDo.loadToDos() {
            toDos = savedToDos
        } else {
            toDos = ToDo.loadSampleToDos()
        }
        //the "Edit" button allows users to edit the list.
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    //this code specifies how many rows (cells) the table view should display, and it's based on the count of to-do items in the array.
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }
        //this code creates and configures a cell for each row in the table view. It sets up the cell with the title and completion status of the corresponding to-do item.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier", for: indexPath) as! ToDoCell
    
        cell.delegate = self
        cell.index = indexPath.row
        let toDo = toDos[indexPath.row]
        cell.title?.text = toDo.title
        cell.isCompleteButton.isSelected = toDo.isComplete
        
        return cell
    }
    //this code allows all rows in the table view to be editable,
    override func tableView(_ tableView: UITableView, canEditRowAt
                            indexPath: IndexPath) -> Bool {
        return true
    }
    //this code allows users to delete a to-do item by removing it from the list and updating the table view accordingly.
    override func tableView(_ tableView: UITableView, commit
                            editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
                            IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    //This code prepares the editing screen. If you're editing an existing to-do (selected from the list), it sets up the details. If you're adding a new one, it opens the editing screen without any details.
    @IBSegueAction func editToDo(_ coder: NSCoder, sender: Any?) ->ToDoDetailTableViewController? {
        
        let detailController = ToDoDetailTableViewController(coder: coder)
        
        guard let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
        else{
            // if sender is the add button, return an empty controller
            return detailController
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        detailController?.toDo = toDos[indexPath.row]
        return detailController
    }
    //this code handles the task of marking a to-do item as complete or incomplete when its checkmark is tapped.
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var toDo = toDos[indexPath.row]
            toDo.isComplete.toggle()
            toDos[indexPath.row] = toDo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(toDos)
        }
    }
    // MARK: - Update
    //this save updated text
    //this code handles the task of modifying the title of a to-do item based on user input.
    func updateText(text: String, index: Int) {
       
        var toDo = toDos[index]
        
        toDo.title = text
        toDos[index] = toDo
        ToDo.saveToDos(toDos)
    }
    
   //This code updates the to-do list based on changes made in the detail view, either by modifying an existing item or adding a new one, and ensures the updates are saved.
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoDetailTableViewController 
        
        if let toDo = sourceViewController.toDo {
            if let indexOfExistingToDo = toDos.firstIndex(of: toDo) {
                toDos[indexOfExistingToDo] = toDo
                tableView.reloadRows(at: [IndexPath(row: indexOfExistingToDo, section: 0)], with: .automatic)
            } else {
                let newIndexPath = IndexPath(row: toDos.count, section: 0)
                toDos.append(toDo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveToDos(toDos)
    }
}
