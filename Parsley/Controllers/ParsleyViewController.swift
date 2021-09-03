//
//  ViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/1/21.
//

import UIKit
import CoreData

class ParsleyViewController: UITableViewController {
    
    // Access to app delegate as an object to access persistentContainer (singleton)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Provide a cell object for each row
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        // Fetch data for the row.
        let item = itemArray[indexPath.row]
        
        // Configure cell's contents.
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Call datasource method again to refresh data
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //        print(itemArray[indexPath.row])
    }
    
    // MARK: - Add New Items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            
            // Action when user clicks the add button
            // Create new item
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            // Add new item to array
            self.itemArray.append(newItem)
            
            self.saveItems()
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Data Manipulation Methods
    
    func saveItems() {
        
        // Transfer data from context stagin area into persistent container
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
} // End ViewController

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

// MARK: - NS Coder

/*
 // Encoding data with NS Coder:
 // Class must conform to Encodable protocol; item type is now able to encode itself into a plist or JSON; all properties must have standard data types (cannot use property with custom class inside class)
 // Can initilize multiple custom plists
 
 // Create file path
 let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 
 // Create encoder
 let encoder = PropertyListEncoder()
 
 // Encode data
 func saveData() {
 do {
 let data = try encoder.encode(itemArray)
 // Write data to file path
 try data.write(to: dataFilePath!)
 } catch {
 print("Error encoding item array, \(error)")
 }
 }
 
 // Decode data, class must conform to Decodable protocol (Encodable + Decodable = Codable)
 // In viewDidLoad
 loadItems()
 
 // Func
 func loadItems() {
 if let data = try? Data(contentsOf: dataFilePath!) {
 let decoder = PropertyListDecoder()
 
 do {
 itemArray = try decoder.decode([Item].self, from: data)
 } catch {
 print("Error decoding item array \(error)")
 }
 }
 }
 */
