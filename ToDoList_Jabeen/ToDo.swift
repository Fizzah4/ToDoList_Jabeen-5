//
//  ToDo.swift
//  ToDoList_Jabeen
//  Created by Syeda Jabeen on 11/01/23.
//

import Foundation

//This code creates a blueprint for to-do tasks, including a name, completion status, deadline, and optional notes.

struct ToDo: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    init(title: String, isComplete: Bool, dueDate: Date,
       notes: String?) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.dueDate = dueDate
        self.notes = notes
    }
    //this code sets up where to store to-do items and provides a method to load them from a file in that location.
    static let documentsDirectory =
       FileManager.default.urls(for: .documentDirectory,
       in: .userDomainMask).first!
    
    static let archiveURL =
       documentsDirectory.appendingPathComponent("toDos")
       .appendingPathExtension("plist")
    
    static func loadToDos() -> [ToDo]?  {
        guard let codedToDos = try? Data(contentsOf: archiveURL) else
           {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self,
           from: codedToDos)
    }
    //this code saves a list of to-do items by converting them into a format that can be stored in a file, and then writes that data to a specific location.
    static func saveToDos(_ toDos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(toDos)
        try? codedToDos?.write(to: archiveURL, options: .noFileProtection)
    }
    
    static func ==(lhs: ToDo, rhs: ToDo) -> Bool {
        return lhs.id == rhs.id
    }
   
    //it's a tool specifically designed to format due dates in a short and easy-to-read way.
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        return formatter
    }()
    
    // this code generates and provides an array of three sample to-do items.
    static func loadSampleToDos() -> [ToDo] {
        let toDo1 = ToDo(title: "To-Do One", isComplete: false,
           dueDate: Date(), notes: "Notes 1")
        let toDo2 = ToDo(title: "To-Do Two", isComplete: false,
           dueDate: Date(), notes: "Notes 2")
        let toDo3 = ToDo(title: "To-Do Three", isComplete: false,
           dueDate: Date(), notes: "Notes 3")
        
        return [toDo1, toDo2, toDo3]
    }
}
