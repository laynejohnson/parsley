//
//  ViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/1/21.
//

import UIKit
import CoreData

//class TodoViewController: UITableViewController {
//
//    @IBOutlet weak var searchBar: UISearchBar!
//
//    // Access to app delegate as an object to access persistentContainer (singleton).
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    // Initialize array to hold data.
//    var itemArray = [Item]()
//
//    var selectedList : List? {
//
//        // didSet keyword code block executes as soon as selectedList is set with value.
//        didSet {
//            loadItems()
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//
//        // Set search bar icon color.
//        searchBar.searchTextField.leftView?.tintColor = .black
//
//        // Set search bar text color.
//        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
//            textfield.textColor = UIColor.black
//        }
//
//        // Set search bar background color.
//        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
////            textfield.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9411764706, alpha: 1)
//            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        }
//
//        searchBar.delegate = self
//    }
//
//    // MARK: - Tableview Datasource Methods
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        return itemArray.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        // Provide a cell object for each row.
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
//
//        // Fetch data for the row.
//        let item = itemArray[indexPath.row]
//
//        // Configure cell's contents.
//        cell.textLabel?.text = item.title
//
//        // Set cell text color.
//        cell.textLabel?.textColor = UIColor.black
//
//        // Set cell accessory type (checkmark).
//        cell.accessoryType = item.done ? .checkmark : .none
//
//        // Set accessory color.
//        cell.tintColor = #colorLiteral(red: 0.1450980392, green: 0.9215686275, blue: 0.6274509804, alpha: 1)
//
//        return cell
//    }
//
//    // MARK: - Tableview Delegate Methods
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//
//        // Save updated properties.
//        saveItems()
//
//        // Call datasource method again to refresh data.
//        tableView.reloadData()
//
//        // Deselect row (remove highlight) after selection.
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            // Remove item from context.
//            context.delete(itemArray[indexPath.row])
//
//            // Remove item from listArray.
//            itemArray.remove(at: indexPath.row)
//
//            // Update database.
//            saveItems()
//
//            // Reload tableView.
//            tableView.reloadData()
//        }
//    }
//
//    // MARK: - Add New Items
//
//    @IBAction func addItem(_ sender: UIBarButtonItem) {
//
//        var textField = UITextField()
//
//        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
//
//        // TODO: Add validation for text field.
//        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in
//
//            // Action when user clicks the add button.
//            // Create new item.
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedList
//
//            // Add new item to array.
//            self.itemArray.append(newItem)
//
//            // Save item to db.
//            self.saveItems()
//
//            // Reload table view.
//            self.tableView.reloadData()
//
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alert.addTextField { alertTextField in
//            alertTextField.placeholder = "Create New Todo"
//            textField = alertTextField
//        }
//
//        alert.addAction(action)
//        alert.addAction(cancelAction)
//
//        present(alert, animated: true, completion: nil)
//
//    }
//    // MARK: - Data Manipulation Methods
//
//    func saveItems() {
//
//        // Save/commit current state of the context to persistent container.
//        do {
//            try context.save()
//        } catch {
//            print("Error saving context: \(error)")
//        }
//    }
//
//    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//        // Item.fetchRequest() is the default value.
//
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedList!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//        do {
//            itemArray = try context.fetch(request)
//        } catch{
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
//
//    func deleteItem(indexPath: IndexPath) {
//
//        // Delete item from context.
//        context.delete(itemArray[indexPath.row])
//
//        // Delete item from array.
//        itemArray.remove(at: indexPath.row)
//
//        // Save changes.
//        saveItems()
//    }
//
//    // MARK: - End ParlseyViewController
//}
//
//// MARK: - Search Bar Delegate Methods
//
//extension TodoViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Reload table view with search text.
//
//        if searchBar.text == "" {
//
//            loadItems()
//
//        } else {
//
//            // Create data request.
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            // Create NSPredicate query.
//            let predicate = NSPredicate(format: "title CONTAINS [cd] %@", searchBar.text!)
//
//            // Sort results.
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//            // Load items.
//            loadItems(with: request, predicate: predicate)
//
//        }
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//
//            loadItems()
//
//            DispatchQueue.main.async {
//                // Dismiss keyboard.
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
