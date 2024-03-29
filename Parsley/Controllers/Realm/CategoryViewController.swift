//
//  CategoryViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/9/21.

// USE THIS VIEW CONTROLLER FOR REALM SETUP.
// LIST VIEW CONTROLLER.

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addListButton: UIBarButtonItem!
    
    let realm = try! Realm()
    
    // Realm queries return results in the form of a Results object.
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set search bar icon color.
        searchBar.searchTextField.leftView?.tintColor = #colorLiteral(red: 0.2980392157, green: 0.2901960784, blue: 0.3019607843, alpha: 1)
        
        // Set search bar text color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.textColor = #colorLiteral(red: 0.2980392157, green: 0.2901960784, blue: 0.3019607843, alpha: 1)
        }
        
        // Set search bar background color.
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8823529412, blue: 0.9019607843, alpha: 1)
        }
        
        // Accessibility.
        addListButton.accessibilityLabel = "Add new list"
        
        searchBar.delegate = self
        
        // Load data.
        loadCategories()
    }
    
    // MARK: - tableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Nil coalescing operator: if categories is not nil, return categories. If nil, return 1.
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell object for each row.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        // Configure cell contents.
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Create a new list"
        
        // Set cell text color.
        cell.textLabel?.textColor = UIColor.black
        
        return cell
    }
    
    // MARK: - tableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.Segues.todoItems, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            if let category = categories?[indexPath.row] {
                do {
                    try realm.write {
                        realm.delete(category)
                    }
                } catch {
                    print("There was an error deleting category: \(error)")
                }
            }
            // Reload tableView.
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ItemViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categories?[indexPath.row]
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
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    // MARK: - Add New Category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New List", message: "", preferredStyle: .alert)
        
        // TODO: Add validiation for text field
        let action = UIAlertAction(title: "Create", style: .default) { [self] (action) in
            
            // Action when user clicks the add button.
            // Create new category.
            let newCategory = Category()
            newCategory.name = textField.text!
            
            // Save category.
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
    
} // End CategoryViewController

// MARK: - Search Bar Extension

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Filter categories.
        categories = categories?.filter("name CONTAINS [cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        
        // Reload tableView data.
        tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadCategories()
            
            DispatchQueue.main.async {
                // Dismiss keyboard.
                searchBar.resignFirstResponder()
            }
        }
    }
}
