//
//  UITableViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    // category selected from Category screen
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    
    var itemArray = [Item]()
    
    // UIApplication.shared.delegate is the current running application delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // SQLite database is located  in Users/{user}/Library/Developer/CoreSimulator/Devices/{deviceId}/data/Containers/Data/Application/{applicationId}/Library/ApplicationSupport/DataModel.sqlite
        print(dataFilePath)
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if(itemArray[indexPath.row].done) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        to delete items
//
//        context.delete(itemArray[indexPath.row]) // delete first from DB
//        itemArray.remove(at: indexPath.row) // then delete from UI

        
        
        saveItems()
        // selected row flashes grey insead of staying grey
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: Add New items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UI Alert
            print(textField)
            if textField.text != "" {
                
                let newItem = Item(context: self.context)
                newItem.title = textField.text!
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.saveItems()
                
            }
        }

            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Data Model Manipulation Methods
    
    func saveItems() {
        
        do{
            // Core Data save
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        // redundant, default set in the parameter
        // let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // if a predicate was supplied in the parameter
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            // else default, single category predicate
            request.predicate = categoryPredicate
        }
        
        do {
            // Core Data fetch
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

// MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
            // create and format CoreData DB search query
            let request: NSFetchRequest<Item> = Item.fetchRequest()
            
            // [cd] means the search is neither case-sensitive nor diacritic-sensitive
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            
            request.predicate = predicate
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            request.sortDescriptors = [sortDescriptor]
            
            // send request
            loadItems(with: request, predicate: predicate)
     
    }
    
    // if search bar empty, show all items from Core Data
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // run on background thread while request is processing
            DispatchQueue.main.async {
                searchBar.resignFirstResponder() // dismiss keyboard, hide cursor
            }
        }
    }
}
