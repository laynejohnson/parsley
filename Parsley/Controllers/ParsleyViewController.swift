//
//  ViewController.swift
//  Parsley
//
//  Created by Layne Johnson on 9/1/21.
//

import UIKit

class ParsleyViewController: UITableViewController {
    
    let itemArray = ["Go to market","Repot plants","Overwinter Harley","Harvest parsley",]
    
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
}
