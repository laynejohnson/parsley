//
//  ViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/1/21.
//

import UIKit
import CoreData

class ParsleyViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Access to app delegate as an object to access persistentContainer (singleton).
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Initialize array to hold data.
    var itemArray = [Item]()
    
    var selectedList : List? {
        
        // didSet keyword code block happens as soon as selectedList is set with value.
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Configure search bar appearance.
        
        // Set search bar icon color.
        searchBar.searchTextField.leftView?.tintColor = .black
        
        // Set search bar text color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
        }
    
        // Set search bar background color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9411764706, alpha: 1)
        }
        
        searchBar.delegate = self
        
    }
    
    // MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Provide a cell object for each row.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        // Fetch data for the row.
        let item = itemArray[indexPath.row]
        
        // Configure cell's contents.
        cell.textLabel?.text = item.title
        
        // Set cell text color.
        cell.textLabel?.textColor = UIColor.black
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Save updated properties.
        saveItems()
        
        // Call datasource method again to refresh data.
        tableView.reloadData()
        
        // Deselect row (remove highlight) after selection.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            
            // Remove item from context.
            context.delete(itemArray[indexPath.row])
            
            // Remove item from listArray.
            itemArray.remove(at: indexPath.row)
            
            // Update database.
            saveItems()
            
            // Reload tableView.
            tableView.reloadData()
        }
    }
    
    // MARK: - Add New Items
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        // TODO: Add validation for text field.
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
            
            // Action when user clicks the add button.
            // Create new item.
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedList
            
            // Add new item to array.
            self.itemArray.append(newItem)
            
            // Save item to db.
            self.saveItems()
            
            // Reload table view.
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
        
        // Save/commit current state of the context to persistent container.
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        // Item.fetchRequest() is the default value.
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedList!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
        }

        do {
            itemArray = try context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    func deleteItem(indexPath: IndexPath) {
        
        // Delete item from context.
        context.delete(itemArray[indexPath.row])
        
        // Delete item from array.
        itemArray.remove(at: indexPath.row)
        
        // Save changes.
        saveItems()
    }
    
    // MARK: - End ParlseyViewController
}

// MARK: - Search Bar Delegate Methods

extension ParsleyViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Reload table view with search text.
        
        if searchBar.text == "" {
            
            loadItems()
            
        } else {
            
            // Create data request.
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            // Create NSPredicate query.
            let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
            
            // Sort results.
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            // Load items.
            loadItems(with: request, predicate: predicate)
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                // Dismiss keyboard.
                searchBar.resignFirstResponder()
            }
        }
    }
}

// MARK: - User Defaults
/*
 // User defaults:
 // Create new default.
 let defaults = UserDefaults.standard
 
 // Save updated array to user defaults.
 defaults.set(self.itemArray, forKey: "TodoListArray")
 
 // User defaults are stored in plist files as key:value pairs; can be retrieved by key.
 // Set array to array in user defaults (viewDidLoad).
 if let items = defaults.array(forKey: "TodoListArray") as! [String] {
 itemArray = items
 }
 */

// MARK: - NS Coder

/*
 // Encoding data with NS Coder:
 // Class must conform to Encodable protocol; item type is now able to encode itself into a plist or JSON; all properties must have standard data types (cannot use property with custom class inside class).
 // Can initilize multiple custom plists.
 
 // Create file path.
 let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
 
 // Create encoder.
 let encoder = PropertyListEncoder()
 
 // Encode data.
 func saveData() {
 do {
 let data = try encoder.encode(itemArray)
 // Write data to file path
 try data.write(to: dataFilePath!)
 } catch {
 print("Error encoding item array, \(error)")
 }
 }
 
 // Decode data, class must conform to Decodable protocol (Encodable + Decodable = Codable).
 // In viewDidLoad:
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
