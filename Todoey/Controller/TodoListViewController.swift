//
//  UITableViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    // category selected from Category screen
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    // Results is an auto-updating container type in Realm returned from object queries.
    var todoItems: Results<Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
  
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added Yet!"
        }
        
        return cell
    }
    
    // MARK: Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // to delete item
                    // realm.delete(item)
                    
                    // update item when selected --> display checkmark
                    item.done = !item.done
                }
            } catch {
                print("error updating item in Realm, \(error)")
            }
        }
        
        tableView.reloadData()
        
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
            
            if let currentCategory = self.selectedCategory {
                
                if textField.text != "" {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item to Realm, \(error)")
                    }
                }
            }
            self.tableView.reloadData()
           
        }

            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: Data Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
}

// MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // .filter takes in an NSPredicate as a parameter
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
     
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
