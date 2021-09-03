//
//  CategoryViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/3/21.
//

import UIKit
import CoreData

class ListViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listArray = [List]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    // MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return listArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a reusable cell object for each row.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        // Configure cell contents.
        cell.textLabel?.text = listArray[indexPath.row].name
        
        return cell
    }
    
    // MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.Segues.itemsList, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ParsleyViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedList = listArray[indexPath.row]
        }
    }
    
    
    
    // MARK: - Data Manipulation Methods

    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("There was an error saving context: \(error)")
        }
    }
    
    func loadCategories(with request : NSFetchRequest<List> = List.fetchRequest()) {
        
        do {
            listArray = try context.fetch(request)
        } catch {
            print("There was an error fetching context: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func deleteList(indexPath: IndexPath) {
        
        // Remove list from context.
        context.delete(listArray[indexPath.row])
        
        // Remove list from listArray.
        listArray.remove(at: indexPath.row)
        
        // Update database.
        saveData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Create New List", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create", style: .default) { [self] (action) in
            
            // Action when user clicks the add button.
            // Create new item.
            let newList = List(context: self.context)
            newList.name = textField.text!
            
            // Add new item to array.
            self.listArray.append(newList)
            
            // Save item to db.
            self.saveData()
            
            // Reload table view.
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
            
            alertTextField.placeholder = "Create New List"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
