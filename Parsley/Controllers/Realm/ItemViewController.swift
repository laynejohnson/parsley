//
//  ItemViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/9/21.
//
// TODO VIEW CONTROLLER.

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var items: Results<Item>?
    
    var selectedCategory : Category? {
        
        // didSet keyword code block executes as soon as selectedList is set with value.
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Set search bar icon color.
        searchBar.searchTextField.leftView?.tintColor = .black
        
        // Set search bar text color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
        }
        
        // Set search bar background color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 0.9960784314, green: 1, blue: 1, alpha: 1)
        }
        
        searchBar.delegate = self
    }
    
    // MARK: - tableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Provide a cell object for each row.
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        // Fetch data for the row.
        if let item = items?[indexPath.row] {
            
            // Configure cell's contents.
            cell.textLabel?.text = item.title
            
            // Set cell text color.
            cell.textLabel?.textColor = UIColor.black
            
            // Set cell accessory type (checkmark).
            cell.accessoryType = item.done ? .checkmark : .none
            
            // Set accessory color.
            cell.tintColor = #colorLiteral(red: 0.1450980392, green: 0.9215686275, blue: 0.6274509804, alpha: 1)
            
        } else {
            cell.textLabel?.text = "All todos completed! 🎉"
        }
        
        return cell
    }
    
    // MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = items?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status: \(error)")
            }
        }
        
        // Call datasource method again to refresh data.
        tableView.reloadData()
        
        // Deselect row (remove highlight) after selection.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let item = items?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(item)
                    }
                } catch {
                    print("There was an error deleting item: \(error)")
                }
            }
            
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        
//                        let date = Date()
//                        let formatter = DateFormatter()
//                        formatter.dateFormat = "MM.dd.yyyy"
//                        let result = formatter.string(from: date)
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("There was an error saving new items, \(error)")
                }
            }
            
            // Reload table view.
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create New Todo"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    // MARK: - Data Manipulation Methods
    
    func loadItems() {
        
        // Load all items.
        //        items = realm.objects(Item.self)
        
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    // MARK: - End ParlseyViewController
}

// MARK: - Search Bar Delegate Methods

extension ItemViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Filter items.
        items = items?.filter("title CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        // Reload tableView data.
        tableView.reloadData()
        
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
