//
//  UITableViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
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
    
    // called after viewDidLoad()
    override func viewWillAppear(_ animated: Bool) {
        
        let parentCategoryColor = UIColor(hexString: selectedCategory!.backgroundColor) ?? FlatSkyBlue()
        
        searchBar.searchTextField.backgroundColor = FlatWhite()
        searchBar.barTintColor = parentCategoryColor
     
        // Page Title
        title = selectedCategory?.name ?? "Items"
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(parentCategoryColor, returnFlat: true)]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(parentCategoryColor, returnFlat: true)]
        navBarAppearance.backgroundColor = UIColor(hexString: parentCategoryColor.hexValue())
     
        
        if let navBar = navigationController?.navigationBar {
           
            navBar.backgroundColor = UIColor(hexString: parentCategoryColor.hexValue())
            navBar.tintColor = ContrastColorOf(parentCategoryColor, returnFlat: true)
        }  else {
            fatalError("Navigation Controller does not exist")
        }
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    // MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // calls parent SwipeTableViewController cellForRowAt method which returns a SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            cell.selectionStyle = .none
            
            // gradient background colors and contrasting text color
            
            let parentCategoryColor = UIColor(hexString: selectedCategory!.backgroundColor) ?? FlatSkyBlue()
            
            if let backgroundColor = parentCategoryColor.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                cell.backgroundColor = backgroundColor
                cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
            }
            
            
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
            
        present(alert, animated: true, completion: {
            alert.view.superview?.isUserInteractionEnabled = true;
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertOnTapOutside)))
        })
        
    }
    
    @objc func dismissAlertOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
        
    
    
    // MARK: Data Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    // Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        // handle action by updating model with deletion
            
            if let itemToBeDeleted = self.todoItems?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(itemToBeDeleted)
                    }
                } catch {
                    print("Error deleting item from realm, \(error)")
                }
            }

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
