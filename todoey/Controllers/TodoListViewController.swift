//
//  ViewController.swift
//  todoey
//
//  Created by Anwar Numa on 8/9/19.
//  Copyright © 2019 Anwar Numa. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController{
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Categories? {
        didSet{
            loadItems()
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
    }

    //MARK: - Table View Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
        
            cell.textLabel?.text = item.title
        
            cell.accessoryType = item.done ? .checkmark : .none

        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
//        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
//        saveItems()
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                item.done = !item.done
                    //deleting
                    //realm.delete(item)
                }
            }catch{
                print("Error in did selecrow")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()

        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newitem = Item()
                        newitem.title = textField.text!
                        newitem.dateCreated = Date()
                        currentCategory.items.append(newitem)
                    }
                }catch{
                    print("Crashed in the add button pressed with error: \(error)")
                }
            }
            self.tableView.reloadData()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Todoey Item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
       
    }
    
    
    
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    

}

//MARK: - Search bar methods
extension TodoListViewController:  UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }

    }
}
