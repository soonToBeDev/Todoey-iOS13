//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//Realm is used for single users, it stores all of the data locally on our device


class ToDoListViewController : UITableViewController {
    
    var toDoItems: Results<Item>?   //toDoItems is a collection of Results that contains Item objects
    let realm = try! Realm()        // Initializing a new access point to our realm DB 
    var selectedCategory : Category?{
        didSet{
            loadItems() //loadItems gets called according to what category we selected
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
    }
    
    //MARK: - Table View Datasource cells
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1  //Will populate our rows with toDoItems (cell.textLabel?.text = item.title) and will also check if the item.done is true if so then it will return .checkmark otherwise it will return .none (cell.accessoryType = item.done == true ? .checkmark : .none). If toDoItems are nil or nothing then we will retrun 1 cell ( ?? 1 ) which triggers the else block ( cell.textLabel?.text = "No Items Added" )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - Table View Delegate Cells
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //When we select any of the cells
        
        if let item = toDoItems?[indexPath.row] {   //we grab a reference to that specified item by looking into the collection of results of toDoItems and look at the current indexPath.row (current cell selected)
            do{
                try realm.write{    //update its value
                    item.done = !item.done  //togling the item.done method to be the opposite of what it used to be. if there was a check mark and we selected it then there will be no checkmark and vice versa
                }
            } catch {
                print("error done saving status \(error)")
            }
        }
        
        tableView.reloadData()
        //Then we reload the data
        tableView.deselectRow(at: indexPath, animated: true)
        //and deselect our cell (no more grey highlight)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // What will happen with the user cllicks on the add item button
            if let currentCategory = self.selectedCategory{
            // when our addButtonPressed is triggered, we optionally bind selectedCategory since its an optional (var selectedCategory : Category?) if its not nil, then we set it to be "currentCategory"
                do{
                    try self.realm.write{   //We update our realm
                        let newItem = Item()    //Creating a new Item
                        newItem.dateCreated = Date()    //Setting the Date it was created
                        newItem.title = textField.text! //Setting the title of it
                        currentCategory.items.append(newItem)   //and we append the currentCategory into items as a newItem
                        //we commit all of this to our realm DB
                    }
                } catch{
                    print("Error occured saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
            //then we finally reload our tableView with all the new data
            
        }
        alert.addTextField { alertTextfield in
            alertTextfield.placeholder = "Create new item"
            textField = alertTextfield
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulating methods
    
    func loadItems(){
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        //toDoItems ( is a collection of Results that contains Item objects ) is set to equal the selectedCategory?.items
        //we set selectedCategory to be of type Category? (var selectedCategory : Category?) and inside our Category model we have our List of items that reflect to our Item data -> ( Item.swift ) (let items = List<Item>())
        //then these items are .sorted by their title and listed in alphabetical order (byKeyPath: "title", ascending: true)
        
        tableView.reloadData()  //We call our datasource method to reload our tableview
    }
    
    
}

//MARK: - Search Bar Methods

extension ToDoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //When we click on the search bar
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        //We filter our toDoItems based on a predicate which states that the title of the item must contain ( title CONTAINS[cd] %@) the specificed argument in the search bar's textfield (searchBar.text!) and we sort it by the date it was created in ascending order from earliest to latest
        tableView.reloadData()
        //We reload our tableView by reloading the datasource method
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            //When we dismiss our search bar
            loadItems() //We then call loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
