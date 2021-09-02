//
//  ViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/1/21.
//

import UIKit

class ParsleyViewController: UITableViewController {
    
    var itemArray = ["Go to market","Repot plants","Overwinter Harley","Harvest parsley",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Provide a cell object for each row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        // Fetch data for the row.
        let item = itemArray[indexPath.row]
        
        // Configure cell's contents.
        cell.textLabel?.text = item
        
        return cell
    }
    
    // MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
    }
    
    // MARK - Add New Items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // Action when user clicks the add button
            self.itemArray.append(textField.text!)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - User Defaults
    /*
     // User defaults:
     // Create new default
     let defaults = UserDefaults.standard
     
     // Save updated array to user defaults
     defaults.set(self.itemArray, forKey: "TodoListArray")
     
     // User defaults are stored in plist files as key:value pairs; can be retrieved by key
     // Set array to array in user defaults (viewDidLoad)
     if let items = defaults.array(forKey: "TodoListArray") as! [String] {
     itemArray = items
     }
     */
}
