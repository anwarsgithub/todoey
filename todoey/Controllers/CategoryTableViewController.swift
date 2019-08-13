//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Anwar Numa on 8/11/19.
//  Copyright © 2019 Anwar Numa. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categoryArray = [Categories]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
   

    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //add what happens when its pressed
            //print(textField.text)
            
            
            let newItem = Categories(context: self.context)
            newItem.name = textField.text == "" ? "New Category" : textField.text
            self.categoryArray.append(newItem)

            self.saveItems()
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
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinaionVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinaionVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: - Data manipulation methods
    
    func saveItems(){
        do {
            try context.save()
        }catch{
            
            print("Error saving context!")
            
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Categories> = Categories.fetchRequest()){

        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("Fetch request threw this error: \(error)")
        }
    }
    
    
    
}
