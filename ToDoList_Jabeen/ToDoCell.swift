//
//  ToDoCell.swift
//  ToDoList_Jabeen
//
//

import UIKit

@objc protocol ToDoCellDelegate: AnyObject {
      func checkmarkTapped(sender: ToDoCell)
    func updateText(text: String, index: Int)
  }

// This class represents a to-do item in a list with a checkmark button and a title text field. The text field is set up to handle user input.
class ToDoCell: UITableViewCell, UITextFieldDelegate {
   
     var index: Int = 0
    
    @IBOutlet weak var isCompleteButton: UIButton!
    
    @IBOutlet weak var title: UITextField!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        title.delegate = self
    }

    // this code sets up communication between the to-do cell and its delegate (ToDoTableViewController) for handling checkmark taps and future text updates.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    weak var delegate: ToDoCellDelegate?
    
    
    @IBAction func CompleteButtonTapped(_ sender: UIButton) {
        delegate?.checkmarkTapped(sender: self)
    }
    
    class ToDoTableViewController: UITableViewController, ToDoCellDelegate{
        func updateText(text: String, index: Int) {
            
        }
        
        
        func checkmarkTapped(sender: ToDoCell) {
        }
    }
    // MARK: - Update
    //this save updated text on press return key from keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder() // Dismiss keyboard on pressing Done
        
        let newText = textField.text ?? "" // Get the entered text
        delegate?.updateText(text: newText, index: index)
        
        return true
    }
}
