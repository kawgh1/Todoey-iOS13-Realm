//
//  CategoryViewController.swift
//  Todoey
//
//  Created by J on 5/7/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // initialize Realm
    let realm = try! Realm()
    
    // Results is an auto-updating container type in Realm returned from object queries.
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        loadCategories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = FlatSkyBlue()
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // calls parent SwipeTableViewController cellForRowAt method which returns a SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                       
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Yet!"
        cell.selectionStyle = .none
        
        let backgroundColorHexValue = categories?[indexPath.row].backgroundColor ?? UIColor.randomFlat().hexValue()
        
        
        // gradient background colors and contrasting text color
        
        if let backgroundColor = UIColor(hexString: backgroundColorHexValue) {
            cell.backgroundColor = backgroundColor
            cell.textLabel?.textColor = ContrastColorOf(backgroundColor, returnFlat: true)
        }
        
        return cell
    }
    
    
    // MARK: - Data Model Manipulation Methods
    
    func saveCategory(category: Category) {
        
        do {
            // Realm Data save
                try realm.write {
                    realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadCategories() {
  
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        // handle action by updating model with deletion
            if let categoryToBeDeleted = self.categories?[indexPath.row] {
                do {
                    try self.realm.write {
                        self.realm.delete(categoryToBeDeleted)
                    }
                } catch {
                    print("Error deleting category from realm, \(error)")
                }
            }

    }
    
    // MARK: - Add New Categories


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once the user clicks the Add Item button on our UI Alert
            print(textField)
            if textField.text != "" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.backgroundColor =  UIColor.randomFlat().hexValue()
                
                self.saveCategory(category: newCategory)
                
            }
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

    
    // MARK: - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
}
