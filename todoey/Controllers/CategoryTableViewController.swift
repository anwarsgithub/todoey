//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Anwar Numa on 8/11/19.
//  Copyright © 2019 Anwar Numa. All rights reserved.
//

import UIKit
import RealmSwift
//import SwipeCellKit


class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Categories>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        loadItems()

    
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        
        cell.backgroundColor = UIColor(hexString: (categoryArray?[indexPath.row].color) ?? "1D9BF9")
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
   

    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //add what happens when its pressed
            //print(textField.text)
            let newItem = Categories()
            newItem.name = textField.text == "" ? "New Category" : textField.text!
            newItem.color = UIColor.randomFlat.hexValue()

            self.saveItems(category: newItem )
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new Category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
        
    }
 


    
    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Category", sender: self)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinaionVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinaionVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    //MARK: - Data manipulation methods
    
    func saveItems(category: Categories){
        do {
            try realm.write {
                realm.add(category)
            }
        }catch{
            
            print("Error saving context!")
            
        }
        self.tableView.reloadData()
    }
    
    
    func loadItems(){

        categoryArray = realm.objects(Categories.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete date
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting the data with Error: \(error)")
            }
 
        }
    }
    
    
    
}

