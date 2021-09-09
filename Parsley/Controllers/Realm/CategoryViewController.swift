//
//  CategoryViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/9/21.

// USE THIS VIEW CONTROLLER FOR REALM SETUP.

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let realm = try! Realm()
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set search bar icon color.
        searchBar.searchTextField.leftView?.tintColor = .black
        
        // Set search bar text color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = UIColor.black
        }
        
        // Set search bar background color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            //            textfield.backgroundColor = #colorLiteral(red: 0.9725490196, green: 0.9647058824, blue: 0.9411764706, alpha: 1)
            textfield.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        searchBar.delegate = self
        
        // Load data.
//        loadCategories()
    }
    
    // MARK: - Table View Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell object for each row.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        // Configure cell contents.
        cell.textLabel?.text = categories[indexPath.row].name
        
        // Set cell text color.
        cell.textLabel?.textColor = UIColor.black
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.Segues.itemsList, sender: self)
    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            // Remove list from context.
//            context.delete(categories[indexPath.row])
//
//            // Remove list from listArray.
//            categories.remove(at: indexPath.row)
//
//            // Update database.
//            save(category: category)
//
//            // Reload tableView.
//            tableView.reloadData()
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedList = categories[indexPath.row]
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write({
                realm.add(category)
            })
        } catch {
            print("There was an error saving context: \(error)")
        }
    }
    
//    func loadCategories(with request: NSFetchRequest<List> = List.fetchRequest(), predicate: NSPredicate? = nil) {
//
//        request.predicate = predicate
//
//        do {
//            // Returns an array of objects that meet the criteria specified by a given fetch request.
//            // Save contents of fetch request to array.
//            categories = try context.fetch(request)
//        } catch{
//            print("Error fetching data from context \(error)")
//        }
//
//        tableView.reloadData()
//    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New List", message: "", preferredStyle: .alert)
        
        // TODO: Add validiation for text field
        let action = UIAlertAction(title: "Create", style: .default) { [self] (action) in
            
            // Action when user clicks the add button.
            // Create new list.
            let newCategory = Category()
            newCategory.name = textField.text!
            
            // Add new list to array.
            self.categories.append(newCategory)
            
            // Save list to db.
            self.save(category: newCategory)
            
            // Reload table view.
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "Create New List"
            textField = alertTextField
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
} // End ListViewController

// MARK: - Search Bar Extension

//extension CategoryViewController: UISearchBarDelegate {
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        // Reload table view with search text.
//        
//        if searchBar.text == "" {
//            
//            loadCategories()
//            
//        } else {
//            
//            // Create data request.
//            let request : NSFetchRequest<List> = List.fetchRequest()
//            
//            // Create NSPredicate query.
//            let predicate = NSPredicate(format: "name CONTAINS [cd] %@", searchBar.text!)
//            
//            // Sort results.
//            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//            
//            // Load items.
//            loadCategories(with: request, predicate: predicate)
//        }
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            
//            loadCategories()
//            
//            DispatchQueue.main.async {
//                // Dismiss keyboard.
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}

