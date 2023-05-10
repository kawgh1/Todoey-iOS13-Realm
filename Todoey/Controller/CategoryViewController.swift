//
//  CategoryViewController.swift
//  Todoey
//
//  Created by J on 5/7/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    // UIApplication.shared.delegate is the current running application delegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SQLite database is located  in Users/{user}/Library/Developer/CoreSimulator/Devices/{deviceId}/data/Containers/Data/Application/{applicationId}/Library/ApplicationSupport/DataModel.sqlite
        print(dataFilePath)
        
        loadCategories()


        
    }
    
    // MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    
    // MARK: - Data Model Manipulation Methods
    
    func saveCategories() {
        
        do {
            // Core Data save
            try context.save()
        } catch {
            print("Error saving category, \(error)")
        }
        self.tableView.reloadData()
    }
    
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {

        // redundant, default set in the parameter
        // let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            // Core Data fetch
            categoryArray = try context.fetch(request)
        } catch {
            print("Error fetching categories from context \(error)")
        }
        tableView.reloadData()
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
                
                let newCategory = Category(context: self.context)
                newCategory.name = textField.text!
                
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
                
            }
        }

            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        
    }
    

    
    // MARK: - TableView Delegate Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationViewController = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
}
