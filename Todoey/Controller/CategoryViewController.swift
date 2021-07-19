//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Adham Hamed on 7/17/21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
//Realm is used for single users, it stores all of the data locally on our device


class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    // Initializing a new access point to our realm DB 
    
    var categoryArray : Results<Category>?
    // var categoryArray is a collection of Results of Category objects, we have it as an optional incase our Category is nil or contains nothing in it

    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategories()
    // when our view loads up, we load all the categories (our initial VC)
    }

//MARK: - Table View DataSource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
        //This Table view datasource method returns the number of categories as the number of rows (numberOfRowsInSection) and if the categoryArray is nil or has nothing in it, it will return 1 cell ( ?? 1 )
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //This initilaizes a cell thats resuable (dequeResuableCell) and we set the cells identifier in Main.storyboard > CategoryVC as "CategoryCell"
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        //Cell from line 31, will have a text label depending if we have a      (categoryArray?) and if we do we look at the categoryArray Results collection and we pick out the out for the current index path and we use the name property to fill up the text label if the categoryArray is nil or has nothing we fill that cell with (?? "No categories added yet")
        
        return cell
        
        //Then we return the cell
        
    }

//MARK: - App Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        //This is what takes place when we select a cell from our categoryArray, we preform a Segue that takes us to the ToDoListVC, which is initialized an identifier of "goToItems"
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        //before we preform the segue we create an instance of our destinationVC or where we want our desination to be, and we downcast it ( as! ) to our ToDoListVC, in other words (segue.destination as! ToDoListViewController) takes us from CategoryVC to ToDoListVC
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
            //We set our desinationVC as the selected category at the categoryArray?[indexPath].row, so according to whichever category we select it will take us inside that specific category that contains all the items within that category so if we click on Home category it will show stove, lamp, fridge. If we click on Work category it will take us to paperwork, staples, computers
        }
    }
    
//MARK: - Add New Cells
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add category", style: .default) { action in
        // When we hit the addButtonPressed or the (+) button, we create and alert that has the text field of "Add Category" ( pop up window )
            
            let newCategory = Category()
        // when we click on the add button we create a newCategory that is a new Category() object
            newCategory.name = textField.text!
        // Then we give the category a name (newCategory.name) based on what the user typed in the (textField.text!) > (textField is a local variable that only allows the user to input text when the button is pressed, and this is why its only declared in addButtonPressed.)
            self.save(category: newCategory)
        // Then we call the save method to save this category to our REALM DB
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Category title"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated : true, completion : nil)
    }
    
//MARK: - Data Manipulation Methods
    
    func save(category: Category){  //we pass in the new category that we created     (category: Category)
        
        do{
            try realm.write{    //we call realm.write to commit changes to our REALM
                realm.add(category) //the changes we would like to make is to add that new category that we created to our REALM DB
            }
        } catch {
            print("error occured saving category \(error) ")
        }
        tableView.reloadData()  // Calls all data source methods by reloading the view with our new data
    }
    
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        
        // In this method, we set our categoryArray to our realm DB (categoryArray = realm) and to fetch all of the objects that belong in the Category data type ( .objects(Category.self) )
        
        tableView.reloadData() // Calls all data source methods by reloading the view with our new data

    }
}
